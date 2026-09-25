---
artifact: spec
schema: 1
feature: <YYYYMMDD-slug>
revision: 1
status: specifying
risk: standard
---

# <Feature title>

- Feature id: <YYYYMMDD-slug>
- Revision: <integer, start at 1>
- Status: specifying | spec-approved
- Risk lane: quick | standard | high-risk
- Approved by: <user, date>
- Related decisions: <.agents/decisions/NNNN-slug.md, or none>

## Problem

<What is wrong or missing today, in two to five sentences.>

Facts found in the code:

- <fact, with file path>
- <fact, with file path>

## Decisions

| # | Question | Decision | Why |
| --- | --- | --- | --- |
| D1 | <question> | <chosen answer> | <one line> |
| D2 | <question> | <chosen answer> | <one line> |

## Out of scope

- <rejected or postponed item>: <why>

## Acceptance criteria

- AC1: WHEN <event>, THE SYSTEM SHALL <result>.
- AC2: IF <unwanted condition>, THEN THE SYSTEM SHALL <result>.
- AC3: THE SYSTEM SHALL <always-true rule>.

Acceptance IDs are stable. Each AC maps to exactly one plan, one or more tasks,
and test or manual evidence.

## Non-functional and operational checks

| Area | Requirement or `not applicable` with reason | Evidence |
| --- | --- | --- |
| Security | <...> | <...> |
| Privacy | <...> | <...> |
| Accessibility | <...> | <...> |
| Performance | <...> | <...> |
| Observability | <...> | <...> |
| Rollback | <...> | <...> |

## Follow-ups

- <gap to decide later>

## Change log

- <date>: spec approved.
- <date>: revision <N>; changed <D#/AC#>; affected plans <...>; reason <...>.
