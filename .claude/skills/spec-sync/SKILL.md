---
name: spec-sync
description: Keep markdown module specs in specs/<module>/ synchronized with source code using spec-sync. Use this whenever creating, editing, or reviewing code in a module that has (or should have) a spec, or whenever the user mentions specs, spec-sync, companion files (tasks.md/requirements.md/context.md/testing.md/design.md), or asks to add/update a module's documentation.
---

# Spec-Sync Workflow

This project uses [spec-sync](https://github.com/CorvidLabs/spec-sync) for bidirectional spec-to-code validation. Specs live in `specs/<module>/<module>.spec.md`.

## Companion files

## Verified SDD change lifecycle (5.0)

For every meaningful source, test, public documentation, schema, or configuration change:

1. Run `specsync change new "<intent>" --json` and conduct the returned interview with the user.
2. Use `specsync change answer <id> <question-id> <answer> --json` until no questions remain.
3. Complete the adaptively selected artifacts and semantic deltas. Requirements use stable
   `REQ-<module>-<number>` IDs, a normative SHALL statement, and acceptance criteria.
4. Ask the user for the definition approval, then run `specsync change approve <id>`.
5. Run `specsync change start <id>` before editing implementation code.
6. Keep tasks and artifacts current, then run `specsync change verify <id>`.
7. Present verification evidence and ask for closing approval. Only after explicit approval,
   run `specsync change accept <id>`; archive separately with `specsync change archive <id>`.

Never invent or self-grant either human approval. If an approved definition changes, its digest
becomes stale and must be approved again. `specsync check` validates canonical specs plus approved
active deltas, requirement-to-test evidence, change coverage, and CI gates.

Each canonical spec may have policy-selected companion files. Read and update the ones present; do not create empty companions only for ceremony:

- **`tasks.md`** — Work items for this module. Check off tasks (`- [x]`) as you complete them. Add new tasks if you discover work needed.
- **`requirements.md`** — Acceptance criteria and user stories. These are permanent invariants, not tasks — do not check them off. Update if requirements change.
- **`context.md`** — Architectural decisions, key files, and current status. Update when you make design decisions or change what's in progress.
- **`testing.md`** — Test strategy: automated test locations, manual QA checklists, and edge cases/boundary conditions.
- **`design.md`** *(opt-in)* — Layout, component hierarchy, design tokens, and asset references. Present when `companions.design` is enabled in config.

## Before modifying any module

1. Read the relevant spec in `specs/<module>/<module>.spec.md`
2. Read whichever companion files are present (`requirements.md`, `tasks.md`, `context.md`, `testing.md`, `design.md`, or project-defined files)
3. After changes, run `specsync check` to verify specs still pass

## After completing work

1. Mark completed items in `tasks.md` — check off finished tasks, add new ones discovered
2. Update `context.md` — record decisions made, update current status
3. If requirements changed, update `requirements.md` acceptance criteria
4. If test coverage changed, update `testing.md` with new test files or edge cases
5. If UI/layout changed, update `design.md` with revised layout, components, or tokens

## Before creating a PR

Run `specsync check --strict` — all specs must pass with zero warnings.

## When adding new modules

Run `specsync scaffold <module-name>` to create a spec, companion files, a registry
entry, and auto-detected source files — or `specsync new <module-name>` for a
minimal spec-only draft. Complete the spec before writing code. The
`/specsync:create-spec` command (or tool-equivalent) runs this for you, and
accepts either a bare module name or a natural-language feature description
(e.g. `/specsync:create-spec "I want a feature that lets users export their
data as CSV"`) — pass a description and it will pick a module name and use
the description to draft the spec's Purpose and Requirements.

## Key commands

- `specsync check` — validate all specs against source code
- `specsync check --json` — machine-readable validation output
- `specsync coverage` — show which modules lack specs
- `specsync score` — quality score for each spec (0-100)
- `specsync scaffold <name>` — full scaffold: spec + companions + registry entry + source detection
- `specsync new <name>` — quick-create a minimal spec (add `--full` for companions)
- `specsync resolve --remote` — verify cross-project dependencies
