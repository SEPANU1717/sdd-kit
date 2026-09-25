---
artifact: review
schema: 1
feature: <YYYYMMDD-slug>
revision: 1
status: pass
risk: standard
---

# Review <N>: <title>

- Plan: `plan-<N>-<slug>.md`
- Spec: `spec.md`
- Reviewer: <agent/session or human>
- Independent from implementation: yes | no | unavailable
- Baseline: <commit SHA, or explicit reason unavailable>
- Diff scope: <exact commit range or working-tree paths>

## Round 1 (<date>)

- Scope reviewed: <all | Part A | fix round>
- Verdict: pass | changes-requested | blocked

### Checks (run by the reviewer)

| Command | Result |
| --- | --- |
| <typecheck> | |
| <lint> | |
| <test> | |
| <build> | |

### Acceptance

| Criterion | Met? | Evidence |
| --- | --- | --- |
| AC1 | yes / no | `<path>:<line>` or test name |

### Traceability

| Task | Test/evidence | Result |
| --- | --- | --- |
| T1.1 | <...> | met / not met |

### Findings

| # | Severity | Finding | Where | Required fix |
| --- | --- | --- | --- | --- |
| F1 | blocker / major / minor | <what is wrong> | `<path>:<line>` | <what to do> |

Severity: blocker = breaks a decision, security or data; major = acceptance not
met or wrong behavior; minor = style or small risk (does not block `pass`).

### Scope check

- Changes outside the plan: <none, or list>

<!-- Add "## Round 2", "## Round 3" below for later rounds. -->
