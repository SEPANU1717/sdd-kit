# Prompts: <feature title>

Paste one block per new session, in order. Run the doctor before implementation.
Each step starts only after the previous one is reviewed and shipped.

## Plan 1: <title>

```text
pwsh -NoProfile -File scripts/sdd-doctor.ps1 -Path .
/sdd-implement .agents/features/<feature-id>/plan-1-<slug>.md
```

Then in a new session:

```text
/sdd-review .agents/features/<feature-id>/plan-1-<slug>.md
```

After a pass:

```text
/sdd-ship .agents/features/<feature-id>/plan-1-<slug>.md
```

## Plan 2: <title>

<same three blocks>

## All in one session (optional)

Do not use this shortcut for High-risk work or for changes to the SDD kit
itself. Independent review is part of the control, not an optional speed mode.
