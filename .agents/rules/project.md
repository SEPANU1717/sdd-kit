# Project

Fill this in once per repository. Every skill reads it. Keep it short and true;
delete lines that do not apply.

## Product

- Name: <project name>
- What it does, for whom: <one or two sentences>
- Stage: <prototype | beta | production>

## Stack

- Language and framework: <e.g. TypeScript, Next.js App Router>
- Data: <e.g. PostgreSQL with Drizzle>
- UI: <e.g. Tailwind, shadcn/ui>
- Package manager: <e.g. pnpm>
- Hosting: <e.g. VPS behind Cloudflare>

## Commands (verified)

Agents run these before a task can be `ready-for-review` and during review.

| Check | Command |
| --- | --- |
| Types | <e.g. pnpm typecheck> |
| Lint | <e.g. pnpm lint> |
| Tests | <e.g. pnpm test> |
| Build | <e.g. pnpm build> |
| Local DB migrate | <e.g. pnpm db:migrate> |

Known pre-existing failures (so agents do not chase them): <none>

## Structure

- <folder>: <what lives there>
- <folder>: <what lives there>

## Conventions

- Commits: Conventional Commits (`feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`).
- Diff size: aim under 400 lines per reviewable part.
- File size: aim under 300 lines, hard limit 500.
- <naming, error handling, testing style, design system file, etc.>

## Skill overrides (optional)

Skills are discovered automatically (see `skill-discovery.md`). Use this table
only to change that for this project: force a skill on, turn it off, or change
its steps.

| Skill | Override | Steps | Why |
| --- | --- | --- | --- |
| <!-- apple-design --> | <!-- force-on / off / steps --> | <!-- specify, plan, review --> | <!-- every screen must meet our design bar --> |

## Boundaries

- Never: <e.g. drop tables, edit production data, change auth without approval>
- Ask first: <e.g. new dependency, schema change, public URL change>
