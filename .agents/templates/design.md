# Design: <feature title>

- Feature: `.agents/features/<feature-id>/spec.md`
- Spec revision: <integer>
- Risk lane: high-risk | standard with design required

## Context and constraints

- <constraint>

## Ownership and data flow

Describe which module owns each state and how data crosses boundaries.

## Contracts

- API, event, file, or component contract: <...>

## Failure, security, and rollback

- Failure path: <...>
- Trust boundaries and control owners: <actor, resource, owning module>
- Authorization/privacy and negative cases: <denied, invalid, replayed, or out-of-order behavior and evidence>
- Rollback or forward recovery: <...>

## Non-functional evidence

- Performance: <target and test>
- Accessibility: <target and test>
- Observability: <signal and location>

## Alternatives rejected

- <alternative>: <reason>
