---
artifact: implementation
schema: 1
feature: <YYYYMMDD-slug>
revision: 1
status: ready-for-review
risk: standard
---

# Implementation <N>: <title>

- Plan: `plan-<N>-<slug>.md`
- Part: <all | Part A (phases 1-3) | fix round 2>
- Date: <date>
- Spec revision: <integer>

## Summary

<Two to four sentences: what now works.>

## Files changed

| File | Change |
| --- | --- |
| `<path>` | <one line> |

## Deviations from the plan

- <none, or what differs and why; anything material was approved by the user on <date>>

## Checks (actually run)

| Command | Result |
| --- | --- |
| <typecheck> | pass / fail (<short output>) |
| <lint> | |
| <test> | |
| <build> | |

Pre-existing failures confirmed on the previous commit: <none, or which>

## Manual checks

- Done: <list>
- Not done: <list, with reason>

## Notes for the reviewer

- <anything tricky, follow-ups found>

## Outcome metrics

- Lead time: <known / not measured>
- Spec changes after implementation began: <count / unknown>
- Review rounds: <count>
- Automated acceptance coverage: <known / not measured>
- Escaped defects: <known / unknown>
