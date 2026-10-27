---
name: catzc-module
description:
  Build or change a cats module to the domain rules, one file at a time with its tests, each verified before the next; the default job for
  code, tests and docs; input is the module folder and the brief's functions.
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
   named in its `Export-ModuleMember` before its first test run; a shared head mechanism lives in `Catzc.Base.CodeMeta`; a contract output
   is `void`, a contract type or `<type>[]`, never `pscustomobject` (`New-CatsCommandLookup` refuses it), and a new or changed public
   parameter updates the command's provided contract under `contracts/<unit>/0.0.0/` in the same step, then `Build-ContractReference`
   renders the page; the module's group and dependencies in `configs/dependencies.yml`; a config is `configs/<name>.yml` mirrored by a typed
   record `types/<Name>Config.cs` (snake_case, ADR-BCL-TYPES-SNAKECASEMIRRORSYAML) registered in `configs.yml`, its sensible default
   declared once on the type (ADR-AUTO-DEFAULT-ONERESOLUTIONORDER) and a shipped value away from it given a `differs` reason in
   `configs.yml` (`Test-ShippedConfigs` fails it otherwise), never an absolute or `..` path checked in (ADR-AUTO-PATH-TWOFORMS), resolved at
   the point of use (ADR-AUTO-PATH-BINDINGFORMONLYATBINDING).
2. L0 tests with neutral fixture names (widget, gadget; ADR-AUTO-TEST-DISTINCTFIXTURES), `Get-Config` mocked, `TestDrive:` for the file
   system, every config rejection and every parameter covered; L1 proves the shipped config loads (`Test-ShippedConfigs`); the file's head
   and page follow from `Format-FileMeta`, never by hand: a new file is written with no head and `Format-Code` derives it (a hand head whose
   cites the code lacks is deleted); an optional registry key lands with its type test case and its registry page in one pass, and a
   file-meta engine test follows the script-scope `Get-<Kind>FileMetaFact` precedent in `Invoke-FileMetaEngine.Tests.ps1`; a test reads a
   property over a maybe-empty result with `ForEach-Object <Property>`, since `@(…).Property` throws under strict mode.
3. Edit one file, run its test file through catzc-gate, then the next; never a sweep; strict-mode clean; an ADR the code cites is read in
   full first and cited by its full rule code, `ADR-<DOMAIN>-<ADR>-<RULE>`; a validation attribute also runs when the function reassigns its
   parameter, so put a computed default in a local; a new member goes after an existing member, never between a comment and its line, since
   the comments step moves the joined run onto the page; a C# type past its limit splits into public static helper types, never partial
   classes.
4. Verify each file and then the set to catzc-verify; a scratch script under `out/` carries the task's name and never overwrites another's;
   prose passes the glossary checks and docs examples use the discovery theme; a cross-cutting record's shape is confirmed with the
   coordinator before its first bulk entries; an edit the domain rules require on an owned or touched file (a re-imprinted head, inline help
   moved to its page, a family form the glossary flags) is pre-approved: made and reported, never asked.
