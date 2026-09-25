---
name: sdd-converge
description: Compare implementation and review evidence against the spec to identify remaining gaps before shipping.
metadata:
  sdd-steps: workflow
  sdd-when: optional after review or before ship
---

# Converge

Read the spec, plans, implementation reports, review rounds, and exact diff or
commit range. Do not change code or approve your own implementation.

For every decision and acceptance criterion, record met, unmet, or unverified
with evidence. Include untested error paths, operational checks, manual checks,
and out-of-scope changes. An unverified criterion cannot support a pass without
an explicit user decision to accept the risk.

Write a convergence report and route unmet items to implementation. Route
changed requirements back to clarify/specify before shipping.
