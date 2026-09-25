# Writing Specs and Plans

## Spec: the what and why

A spec is for the user and for every later agent. It holds decisions, not code.

- **Problem**: what is wrong or missing today, with facts found in the code
  (file paths are fine here).
- **Decisions**: every question asked, the chosen answer, and a one-line reason.
  Number them (D1, D2 ...) so plans and reviews can cite them.
- **Out of scope**: what was explicitly rejected or postponed, and why. This
  stops later agents from "helpfully" adding it.
- **Acceptance criteria**: observable results, written so a reviewer can check
  them without asking anyone.
- **Follow-ups**: known gaps to decide later.

### Acceptance criteria style

Use one of these shapes (EARS style), one behavior per line:

- `WHEN <event>, THE SYSTEM SHALL <result>.`
- `WHILE <state>, THE SYSTEM SHALL <result>.`
- `IF <unwanted condition>, THEN THE SYSTEM SHALL <result>.`
- `THE SYSTEM SHALL <always-true rule>.`

Good: `WHEN the owner switches Hexagon off for Hoodie, THE SYSTEM SHALL stop
showing Hexagon on the Hoodie product page.`

Bad: `Fabric switching works well.`

## Plan: the how

A plan is for the implementer and the reviewer.

- Link the spec and list the decision ids it implements.
- **Evidence**: the files, functions and line numbers it relies on, all checked
  in the repository. Never invent a path.
- **Phases**: ordered, each small enough to review; name the split point when
  the plan could exceed about 400 lines.
- **Tests**: which behaviors get which tests.
- **Out of scope**: repeat the spec's list plus anything the plan defers.
- **Acceptance**: the spec's criteria that this plan covers, plus technical
  ones (migration has a down file, no file over 500 lines).
- **Verification**: the exact commands from `rules/project.md` and the manual
  checks.
- **Estimate**: lines of diff and where to split.

## Decisions (ADRs)

Write `.agents/decisions/NNNN-<slug>.md` when a decision should outlive the
feature (for example "customer reviews are never edited by staff"). Keep it to
context, decision, consequences. Link it from the spec.

## Style

- Present tense, short sentences, no marketing words.
- One idea per bullet.
- Prefer a table when comparing options.
- Never hide uncertainty: write `Unverified:` in front of anything not checked.
