# Principle: Everything as code

## Rules: PDR-EAC

### Rule PDR-EAC-EVERYTHINGCOMMITTED

Every artifact required to build, test, deploy, or operate the system lives in version control — application code, infrastructure,
pipelines, environment config, schemas/migrations, specs, tests, container/orchestration, networking/DNS, and governing docs. The PDR-EAC
rules are the mechanics of TDR-ONETRUTH-REPOSITORYISRECORD.

- [Principle](#principle)

### Rule PDR-EAC-DIFFABLEISVERSIONED

If an artifact can be diffed, reviewed, and rolled back it belongs in version control; prefer tools that store their configuration as files
over UIs, databases, or proprietary formats.

- [How to apply](#how-to-apply)

### Rule PDR-EAC-NOUNVERSIONEDSTATE

Never keep configuration or operational state outside version control (UI-managed settings, variable libraries, shared documents, manual
runbooks) — it cannot be diffed or reproduced and it drifts silently.

- [The anti-pattern](#the-anti-pattern)

## Context

Organizations commonly version-control the source code of their applications while treating configuration, infrastructure definitions,
pipeline definitions, and operational artifacts as second-class citizens — managed through UIs, wikis, shared drives, or tribal knowledge.
This creates a class of assets that cannot be reproduced, compared, audited, or rolled back.

This principle is the mechanics of [TDR-ONETRUTH-REPOSITORYISRECORD](../thesis/one-source-of-truth.md#rule-tdr-onetruth-repositoryisrecord):
the repository is the configuration record of everything it delivers, and the rules here say what that requires of each artifact.

## Principle

The list in PDR-EAC-EVERYTHINGCOMMITTED is not exhaustive: if an artifact is required to reproduce an environment or a process, it is code.
If it is code, it belongs in version control.

## Why

Three requirements drive this principle:

**Reproducibility.** Teams must be able to provision any environment in a fully automated fashion and know that any new environment
reproduced from the same configuration is identical. This is only possible when the scripts and configuration required to provision an
environment are stored in a shared, accessible system [^1].

**Traceability.** Teams must be able to pick any environment and determine quickly and precisely the versions of every dependency used to
create that environment. They must also be able to compare two versions of an environment and see what has changed between them [^1].

**Version alignment.** A version control repository produces an infinite stream of versions — each commit is a snapshot. When all artifacts
live in the same repository, every snapshot is internally consistent by definition: the configuration version matches the automation version
matches the documentation version matches the infrastructure definitions. There is no "which version of the config goes with which version
of the code?" question — the commit answers it. When artifacts are split across repositories, UIs, or manual stores, version alignment
becomes an explicit coordination problem that must be solved through naming conventions, tagging discipline, or cross-references — all of
which are fragile.

These requirements yield concrete benefits: disaster recovery (rebuild from scratch), auditability (who changed what and when), higher
quality (faster feedback loops), capacity management (horizontal scaling from known-good definitions), and rapid response to defects
(rollback to a known-good state).

## The anti-pattern

DORA's research explicitly identifies this as a common pitfall: applying version control only to application code, rather than to everything
required to reproduce testing and production environments [^1].

## How to apply

The test of PDR-EAC-DIFFABLEISVERSIONED applies to any value, definition, or process whose home is in question. This principle is
technology-agnostic. It applies regardless of which version control system, infrastructure tooling, or deployment platform is in use.

## References

[^1]:
    DORA, [Version control](../../references/dora/capabilities.md#version-control) — Research-backed capability identifying comprehensive
    version control as a predictor of continuous delivery, with reproducibility and traceability as the two core requirements.
