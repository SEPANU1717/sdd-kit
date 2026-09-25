---
name: sdd-clarify
description: Find and resolve high-risk ambiguities in an existing spec before planning.
metadata:
  sdd-steps: workflow
  sdd-when: optional before plan
---

# Clarify

Read the current spec, constitution, relevant rules, decisions, and repository
evidence. Do not write code or a plan.

Ask at most five targeted questions about the highest-impact ambiguity. Ground
each question in evidence and recommend an answer. Record approved answers in
the spec by incrementing its revision, preserving stable IDs, and adding a
change-log entry. Mark derived plans stale when affected.

Do not invent technical design to close a product decision. Route architectural
ambiguity to the design artifact and planning step.
