---
name: prompt-master
description: Write or improve concise, paste-ready prompts for a named AI tool when explicitly asked. During SDD planning, refine feature handoff prompts without changing their workflow gates or source artifacts.
metadata:
  sdd-steps: plan
  sdd-when: writing or revising a feature's prompts.md handoff prompts
---

# Prompt Master

## Standalone prompts

- Identify the receiving tool, task, input, scope, required output, and success
  evidence. Ask only when a missing choice materially changes the prompt.
- Use the shortest prompt that preserves those facts. Refer to available files
  instead of pasting their contents. Do not request hidden reasoning.
- Keep model names and tool-specific controls out unless verified for the
  receiving tool and needed for the task.

## SDD handoffs

When `sdd-plan` writes a feature's `prompts.md`, use
`.agents/templates/prompts.md` as the required structure. For each plan:

1. Fill the exact plan path and current spec revision in separate Implement,
   Review, and Ship blocks. Each block must work without chat history.
2. Keep only the stage's gate, action, allowed scope, output artifact,
   verification, and stop condition. The spec, design, plan, and repository
   rules hold the detail; do not restate them in the prompt.
3. Preserve independent review and explicit commit authorization. Prompt
   wording cannot approve a plan, waive evidence, or grant external access.
4. Remove every template placeholder. Check that paths, revision, and
   artifact names agree with the actual feature files before handing over.

Do not add a target-tool footer or prompt-engineering commentary to an SDD
`prompts.md` artifact. For a standalone prompt requested by the user, provide
the paste-ready prompt and a brief note only when setup is needed.
