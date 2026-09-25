---
name: sdd-ship
description: Commit an approved plan's work by explicit path with a Conventional Commit message and mark it done. Use when the user asks to ship or commit a plan whose review passed.
metadata:
  sdd-steps: workflow
  sdd-when: this is an SDD step itself
---

# Ship

## Role

You commit reviewed work. You never push, merge, deploy, amend or force unless
the user explicitly asks for that in this session.

## Steps

1. **Check the gate.** The plan's latest review round says `pass` and
   `tasks.md` says `approved`. Otherwise stop and say what is missing. (If the
   user explicitly asks to commit unreviewed work, warn once, then follow the
   request and write "unreviewed" in the commit body.)
2. **Prepare final state**: update the feature status and reports before the
   commit, then collect only the explicit implementation manifest plus the
   feature's spec, plan, reports, reviews and `tasks.md`. Run `git status`; files
   changed by other work are not included.
3. **Scan for secrets** in the staged diff (keys, tokens, `.env`). Stop if any.
4. **Commit by explicit path** (never `git add .`):
   - Subject: `feat(<scope>): <what users get>` (or `fix`, `refactor` ...),
     under 72 characters.
   - Body: two or three lines on what and why, and `Spec: <feature-id>, plan N`.
   - No AI attribution lines unless the user wants them.
5. **Commit** the prepared final state, then verify `git status --short` and
   report any remaining changes. Do not mutate `tasks.md` after the commit.
6. **Report** the commit hash and message, `git status` after, and the next
   step (next plan's prompt from `prompts.md`, or "feature complete").
