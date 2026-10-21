---
name: catzc-module
description:
  How a cats module is built to the domain rules, one file at a time with its tests; for build-inspiration-module and catzc-worker; input is
  the module folder and the brief's functions.
user-invocable: false
allowed-tools: Bash, Read, Glob, Grep, Write, Edit
paths: pwsh/**
metadata:
  catzc:
    config:
      model_floor: sonnet
      needs: [pwsh]
---

# catzc-module

1. Reuse before you add: search `docs/references/pwsh/index.md`, `file-kinds.yml` and the `types/` folders for a function, kind, type or
   limit that already does it (a `TimeLimit`, `Get-ChildPath`, `DurableHash`, the extension and hook builders). One function per
   `Verb-Noun.ps1`; public at the module root, helpers in `private/`; an internal psm1 exports an explicit list, so a new loader function is
   named in its `Export-ModuleMember` before its first test run; a shared head mechanism lives in `Catzc.Base.CodeMeta`; the module's group
   and dependencies in `configs/dependencies.yml`; a config is `configs/<name>.yml` mirrored by a typed record `types/<Name>Config.cs`
   (snake_case, ADR-BCL-TYPES-SNAKECASEMIRRORSYAML) registered in `configs.yml`, its sensible default declared once on the type
   (ADR-AUTO-DEFAULT-ONERESOLUTIONORDER) and a shipped value away from it given a `differs` reason in `configs.yml` (`Test-ShippedConfigs`
   fails it otherwise), never an absolute or `..` path checked in (ADR-AUTO-PATH-TWOFORMS), resolved at the point of use
   (ADR-AUTO-PATH-BINDINGFORMONLYATBINDING).
2. L0 tests with neutral fixture names (widget, gadget; ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES), `Get-Config` mocked, `TestDrive:` for the
   file system, every config rejection and every parameter covered; L1 proves the shipped config loads (`Test-ShippedConfigs`); the file's
   head and page follow from `Format-FileMeta`, never by hand.
3. Edit one file, run its test file through catzc-check, then the next; never a sweep; strict-mode clean; an ADR the code cites is read in
   full first and cited by its full rule code, `ADR-<DOMAIN>-<ADR>-<RULE>`.
