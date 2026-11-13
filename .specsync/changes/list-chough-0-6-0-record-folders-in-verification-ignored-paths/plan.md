---
change: list-chough-0-6-0-record-folders-in-verification-ignored-paths
artifact: plan
---

# Plan

## Approach

Add a `verification_ignored_paths` array to `.specsync/sdd.json` listing
`.chough/sessions/`, `.chough/archive/` and `.chough/bugs/` (SpecSync 6.1.2 and later
honour it). No other key changes.

## Out of scope

Every other policy key, the Chough migration commit itself, and any spec or code change.

## Steps

1. Edit `.specsync/sdd.json` to add the three entries.
2. Run `specsync check`, `chough doctor` and the repository's own checks.
3. Human scope approval and review, then finalize and archive in this PR.

## Risks

Low. The entries only exclude Chough record folders from verification freshness; they
do not exclude source, tests or specs.

## Constraints consulted

Chough docs/cli.md Doctor table (`records_in_verification`, REQ-records-014).
