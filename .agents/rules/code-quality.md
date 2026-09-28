# Code Quality and Consistency

Read for implementation and code review. The approved spec, local project
rules, and existing module behavior take priority over generic style advice.

- Inspect nearby code and tests before editing. Follow established naming,
  error handling, contracts, and component conventions.
- Keep a business rule at its owning layer. Update shared contracts,
  validators, and consumers together when a shape changes; avoid duplicate
  rules in client and server code.
- Prefer existing services and primitives. Add an abstraction only when it
  removes real complexity or matches a demonstrated local pattern.
- Make failure behavior explicit and preserve the project's type and lint
  standards. Explain any necessary suppression at the narrowest point.
- Test changed behavior at its owning layer. Add meaningful invalid-input,
  denial, retry, and concurrency cases when the feature can encounter them.
- Keep diffs scoped. Avoid unrelated formatting, renames, dependency churn,
  and generated-file edits. Update relevant documentation when contracts or
  user behavior change.
- Run applicable routine checks from `project.md`; record failures honestly.
