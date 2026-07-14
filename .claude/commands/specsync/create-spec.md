---
description: Scaffold a new spec-sync module spec from a module name or a natural-language feature description (full scaffold by default, or minimal with --minimal)
argument-hint: <module-name-or-description> [--minimal]
---

Create a new spec-sync module spec.

Arguments: `$ARGUMENTS`

1. Parse the arguments above: the first whitespace-separated token is the
   module name. If the arguments also contain `--minimal` (in any position),
   remove it and remember that minimal mode was requested.
2. Look at whatever text remains. It will be one of:
   - **A bare module name** — a short identifier like `auth-service` or
     `billing`. Use it as-is.
   - **A free-text feature description** — a sentence or phrase describing
     what to build, e.g. `"I want a feature that lets users export their
     data as CSV"`. In this case, invent a short, kebab-case module name that
     captures the idea (e.g. `csv-export`). If the right name is ambiguous,
     ask the user to confirm or rename it before continuing. Keep the full
     description at hand — you'll use it in step 5.
3. If minimal mode was requested, run:
   ```
   specsync new <module-name>
   ```
   This creates a minimal spec only (no companion files).
4. Otherwise (default), run:
   ```
   specsync scaffold <module-name>
   ```
   This creates the spec, companion files (`tasks.md`, `requirements.md`,
   `context.md`, `testing.md`, and `design.md` if `companions.design` is
   enabled), a registry entry, and auto-detects related source files.
5. Open the newly created `specs/<module-name>/<module-name>.spec.md` and fill
   in the `Purpose`, `Requirements`, and `Public API` sections. If a free-text
   description was given in step 2, use it directly to draft these sections —
   ask clarifying questions if it's underspecified, but do not leave the
   sections as unfilled placeholder text. Do the same for `requirements.md`
   (acceptance criteria) and `tasks.md` (initial task breakdown), if present.
6. Run `specsync check` to confirm the new spec passes validation.
