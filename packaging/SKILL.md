---
name: sdd-kit
description: Install the sdd-kit spec-driven development workflow into the current project. Use when the user asks to install or set up sdd-kit, spec-driven development, or the sdd-specify, sdd-plan, sdd-implement, sdd-review and sdd-ship skills.
---

# Install sdd-kit

sdd-kit is a spec-driven development workflow: Spec, Plan, Implement, Review,
Ship. Each step is a skill that leaves a file in `.agents/features/`, so any
agent in any session can continue the work. `README.md` next to this file has
the full guide.

The kit's files sit next to this `SKILL.md`. Install them into the project the
user is working in.

## Steps

1. **Check the project.** Run `git status` in the project root. If it has
   uncommitted changes, tell the user and ask before continuing.
2. **Check for conflicts.** Look for `AGENTS.md`, `CLAUDE.md`, `.agents/`,
   `.claude/skills/` and `scripts/` in the project root. Never overwrite an
   existing file without asking.
   - Existing `AGENTS.md`: keep it and add the kit's "Where things live" and
     "Non-negotiables" sections to it.
   - Existing `CLAUDE.md`: add the line `@AGENTS.md` at the top.
3. **Copy the kit.** Copy `AGENTS.md`, `CLAUDE.md`, `LICENSE` (as
   `.agents/SDD-KIT-LICENSE`), `.agents/`, `.claude/skills/` and `scripts/`
   from this skill's folder into the project root. Do not copy this
   `SKILL.md`.
4. **Fill in `.agents/rules/project.md` with the user.** Read the project's
   stack, commands and structure from its files, then ask the user to confirm
   the commands. This is the most important step.
5. **Verify.** Run `pwsh -NoProfile -File scripts/sdd-doctor.ps1 -Path .`
   (Windows) or `sh scripts/sdd-doctor.sh .` and report the real output.
6. **Hand over.** Tell the user to start a feature with `/sdd-specify`, and
   that nothing is committed until they ask.

Never commit, push or install packages during the install.
