---
artifact: plan
schema: 1
feature: <YYYYMMDD-slug>
revision: 1
status: planned
risk: standard
---

# Plan <N>: <title>

- Feature: `.agents/features/<feature-id>/spec.md`
- Implements decisions: <D1, D3, D4>
- Spec revision: <integer>
- Depends on: <plan N-1, or none>
- Status: planned | plan-approved
- Estimate: <about N lines of diff>; split point: <phase, if over 400>

## Goal

<One paragraph: what exists when this plan is done.>

## Evidence (checked in the repository)

- `<path>:<line>`: <what it is and why it matters>
- `<path>:<line>`: <...>

## Phases

### Phase 1: <name>

- <change>
- <change>

### Phase 2: <name>

- <change>

## Tasks and traceability

| Task | Depends on | Files/area | Acceptance criteria | Test/evidence |
| --- | --- | --- | --- | --- |
| T1.1 | none | <...> | AC1 | <test or manual check> |

## Tests

- <behavior> → <test file or kind>

## Out of scope

- <from the spec, plus anything this plan defers to a later plan>

## Acceptance

- Spec: <AC1, AC2 covered by this plan>
- Technical: <e.g. migration has a down file; no file over 500 lines>

## Verification

- Commands: <types, lint, test, build from rules/project.md>
- Manual: <what a human should click through>

## Expert skills to apply

- <skill name>: <what it must check or guide in this plan, or "none">

## Risks and stop points

- <risk> → <what the implementer does: stop and ask, or mitigation>
