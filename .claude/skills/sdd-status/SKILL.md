---
name: sdd-status
description: Read-only overview of what is done, in progress, waiting for review or blocked, and what to run next. Use when the user asks what is left, what is not done, where things stand, or what to do next.
metadata:
  sdd-steps: workflow
  sdd-when: this is an SDD step itself
---

# Status

Read-only. Change nothing.

## Steps

1. Read `.agents/state/tasks.md`, then each listed feature folder's newest
   files (spec status, plans, latest impl and review round).
2. Check reality: `git log --oneline -15` and `git status --short`. Flag any
   mismatch (for example `ready-for-review` but no uncommitted or recent
   changes, or uncommitted files that belong to no feature).
3. Report grouped as:
   - In progress now
   - Waiting on the user (approvals, questions, manual checks)
   - Waiting for review
   - Planned, not started
   - Blocked (and on what)
   - Follow-ups recorded in specs
   - Quality gates: clarify/checklist/analyze/converge completed, pending, or
     not applicable
4. End with a recommended order and the exact next prompt or skill to run.
   Mention stale derived artifacts and unverified baselines explicitly.
