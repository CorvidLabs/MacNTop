# macOS App Release Setup Instructions (for Claude)

Use these instructions to set up code signing, notarization, and GitHub release workflows for a macOS app distributed via GitHub.

## Prerequisites

The user must have:
- Apple Developer account ($99/year)
- Self-hosted GitHub Actions runner on macOS
- Swift Package Manager project that builds a macOS executable

## Step 1: Developer ID Certificate

Guide user to create a Developer ID Application certificate:

1. Go to [developer.apple.com/account/resources/certificates](https://developer.apple.com/account/resources/certificates)
2. Click **+** → Select **Developer ID Application**
3. Choose **G2 Sub-CA** (for Xcode 11.4.1+)
4. Create CSR via Keychain Access → Certificate Assistant → Request a Certificate From a Certificate Authority
5. Upload CSR, download `.cer`, double-click to install

Verify installation:
```bash
security find-identity -v -p codesigning | grep "Developer ID"
```

Expected output format:
```
"Developer ID Application: Name (TEAM_ID)"
```

## Step 2: Notarization Credentials

Guide user to store credentials locally (not in GitHub):

1. Generate App-Specific Password at [appleid.apple.com](https://appleid.apple.com) → Sign-In and Security → App-Specific Passwords
2. Store in Keychain:

```bash
xcrun notarytool store-credentials "PROFILE_NAME" \
  --apple-id "APPLE_ID_EMAIL" \
  --team-id "TEAM_ID" \
  --password "APP_SPECIFIC_PASSWORD"
```

The `PROFILE_NAME` should be descriptive like `GitHub-Mac-Notarize` or `AppName-Notarize`.

## Step 3: Create Release Workflow

Create `.github/workflows/release.yml` with these key steps:

```yaml
name: Release

on:
  push:
    tags:
      - 'v*'
  workflow_dispatch:
    inputs:
      version:
        description: 'Version tag (e.g., v1.0.0)'
        required: true
        type: string

env:
  APP_NAME: YOUR_APP_NAME
  BUNDLE_ID: com.yourcompany.appname
  SIGNING_IDENTITY: "Developer ID Application: Name (TEAM_ID)"
  NOTARIZE_PROFILE: "PROFILE_NAME"

jobs:
  build-and-release:
    runs-on: self-hosted
    steps:
      - uses: actions/checkout@v4

      - name: Determine Version
        id: version
        run: |
          if [ "${{ github.event_name }}" = "workflow_dispatch" ]; then
            echo "version=${{ inputs.version }}" >> $GITHUB_OUTPUT
          else
            echo "version=${GITHUB_REF#refs/tags/}" >> $GITHUB_OUTPUT
          fi

      - name: Build Release
        run: swift build -c release

      - name: Create App Bundle
        run: |
          rm -rf "${{ env.APP_NAME }}.app"
          mkdir -p "${{ env.APP_NAME }}.app/Contents/MacOS"
          mkdir -p "${{ env.APP_NAME }}.app/Contents/Resources"
          cp .build/release/${{ env.APP_NAME }} "${{ env.APP_NAME }}.app/Contents/MacOS/"
          cat > "${{ env.APP_NAME }}.app/Contents/Info.plist" << 'PLIST'
          <?xml version="1.0" encoding="UTF-8"?>
          <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
          <plist version="1.0">
          <dict>
              <key>CFBundleExecutable</key>
              <string>APP_NAME</string>
              <key>CFBundleIdentifier</key>
              <string>BUNDLE_ID</string>
              <key>CFBundleName</key>
              <string>APP_NAME</string>
              <key>CFBundleShortVersionString</key>
              <string>VERSION</string>
              <key>CFBundleVersion</key>
              <string>BUILD_NUMBER</string>
              <key>LSMinimumSystemVersion</key>
              <string>14.0</string>
              <key>LSUIElement</key>
              <true/>
              <key>NSHighResolutionCapable</key>
              <true/>
          </dict>
          </plist>
          PLIST

      - name: Sign App Bundle
        run: |
          codesign --force --options runtime \
            --sign "${{ env.SIGNING_IDENTITY }}" \
            --timestamp \
            "${{ env.APP_NAME }}.app/Contents/MacOS/${{ env.APP_NAME }}"
          codesign --force --options runtime \
            --sign "${{ env.SIGNING_IDENTITY }}" \
            --timestamp \
            "${{ env.APP_NAME }}.app"
          codesign --verify --verbose "${{ env.APP_NAME }}.app"

      - name: Create ZIP for Notarization
        run: ditto -c -k --keepParent "${{ env.APP_NAME }}.app" "${{ env.APP_NAME }}.zip"

      - name: Notarize App
        run: |
          xcrun notarytool submit "${{ env.APP_NAME }}.zip" \
            --keychain-profile "${{ env.NOTARIZE_PROFILE }}" \
            --wait

      - name: Staple Notarization Ticket
        run: xcrun stapler staple "${{ env.APP_NAME }}.app"

      - name: Create Distribution ZIP
        run: |
          rm "${{ env.APP_NAME }}.zip"
          ditto -c -k --keepParent "${{ env.APP_NAME }}.app" "${{ env.APP_NAME }}-${{ steps.version.outputs.version }}.zip"

      - name: Verify Final App
        run: |
          spctl --assess --verbose "${{ env.APP_NAME }}.app"
          codesign -dv --verbose=4 "${{ env.APP_NAME }}.app"

      - name: Create GitHub Release
        if: startsWith(github.ref, 'refs/tags/')
        uses: softprops/action-gh-release@v1
        with:
          files: ${{ env.APP_NAME }}-${{ steps.version.outputs.version }}.zip
          generate_release_notes: true
          prerelease: ${{ contains(steps.version.outputs.version, 'beta') }}
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## Step 4: Test Release

```bash
git tag v0.1.0-beta
git push origin v0.1.0-beta
```

Monitor with:
```bash
gh run watch --repo OWNER/REPO
```

## Key Values to Customize

| Value | Description | Example |
|-------|-------------|---------|
| `APP_NAME` | Executable name from Package.swift | `Ports` |
| `BUNDLE_ID` | Reverse-DNS identifier | `com.corvidlabs.ports` |
| `SIGNING_IDENTITY` | Full cert name from `security find-identity` | `Developer ID Application: Zach Eriksen (8M8SAX62V2)` |
| `NOTARIZE_PROFILE` | Profile name from `xcrun notarytool store-credentials` | `GitHub-Mac-Notarize` |
| `LSUIElement` | `true` for menu bar apps (no dock icon), `false` for regular apps | `true` |
| `LSMinimumSystemVersion` | Minimum macOS version | `14.0` |

## Security Notes

- **No secrets in GitHub** - All signing/notarization uses local Keychain on self-hosted runner
- **Developer ID cert** is for public distribution outside App Store
- **One cert works for all apps** - No need to create per-app certificates
- **Notarization profile can be shared** across apps if using same Apple ID

## Troubleshooting

### "The signature is invalid"
- Ensure `--options runtime` flag is used (required for notarization)
- Sign executable first, then the .app bundle

### Notarization fails
- Check credentials: `xcrun notarytool history --keychain-profile "PROFILE_NAME"`
- Verify bundle ID matches what's registered with Apple

### Gatekeeper blocks app
- Ensure stapling completed: `xcrun stapler validate App.app`
- Check with: `spctl --assess --verbose App.app`
