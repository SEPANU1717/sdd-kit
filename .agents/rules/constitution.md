# Project Constitution

This file contains durable project principles. It is not a feature spec and it
must not contain implementation tasks.

## Principles

1. **Separate what from how.** Specs describe user outcomes and constraints.
   Plans and designs describe architecture and implementation.
2. **Evidence over confidence.** Agents distinguish confirmed, inferred, and
   unverified facts. A command that did not run is not a passing check.
3. **Small reversible changes.** Prefer the smallest independently testable
   slice, explicit rollback, and bounded blast radius.
4. **User control at irreversible boundaries.** Ask before schema changes,
   new dependencies, external messages, public URL changes, deployment,
   production data access, commits, or pushes unless explicitly authorized.
5. **Traceable behavior.** Every in-scope acceptance criterion maps to a task
   and test or documented manual evidence.
6. **Security and privacy by default.** Secrets stay out of artifacts and logs;
   authorization, sensitive data, and external inputs are validated at their
   owning boundary.
7. **Preserve unrelated work.** Never reset, overwrite, delete, or stage files
   outside the explicit task scope.
8. **Context is conditional.** Read a rule or skill when its trigger applies;
   do not load unrelated project documentation merely because it exists.

## Governance

- Amendments require a dated change-log entry and impact note.
- Accepted decisions in `.agents/decisions/` and this constitution outrank
  general skill advice.
- A feature may add stricter rules, but may not silently weaken these principles.
