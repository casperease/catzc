---
name: catzc-module
description:
  How a cats module is built to the domain rules, one file at a time with its tests; for build-inspiration-module and catzc-worker; input is
  the module folder and the brief's functions.
user-invocable: false
allowed-tools: Bash, Read, Glob, Grep, Write, Edit
paths: automation/**
metadata:
  catzc:
    immutable:
      with_body_sha: "5a5badfb8c98"
      repo_status: clean
      path: ".claude/skills/catzc-module/SKILL.md"
      folder: skills/catzc-module
      name: skill
      filetype: md
      kind: capability
      language: markdown
      track: ".claude"
      tracktype: vendor-settings
      vendor: claude
      module: ".claude"
      moduletype: settings
    edges:
      cites:
        - ADR-AUTO-DEFAULT#6
        - ADR-AUTO-PATH#{1,3}
        - ADR-AUTO-TEST#3
        - ADR-AUTO-TYPES#8
    config:
      model_floor: sonnet
      needs: [pwsh]
---

# catzc-module

1. One function per `Verb-Noun.ps1`; public at the module root, helpers in `private/`; the module's group and dependencies in
   `configs/dependencies.yml`; a config is `configs/<name>.yml` mirrored by a typed record `types/<Name>Config.cs` (snake_case,
   ADR-AUTO-TYPES#8) registered in `configs.yml`, its sensible default declared once on the type (ADR-AUTO-DEFAULT#6), never an absolute or
   `..` path checked in (ADR-AUTO-PATH#1), resolved at the point of use (ADR-AUTO-PATH#3).
2. L0 tests with neutral fixture names (widget, gadget; ADR-AUTO-TEST#3), `Get-Config` mocked, `TestDrive:` for the file system, every
   config rejection and every parameter covered; L1 proves the shipped config loads (`Test-ShippedConfigs`); the file's head and page follow
   from `Format-FileMeta`, never by hand.
3. Edit one file, run its test file through catzc-check, then the next; never a sweep; strict-mode clean; an ADR the code cites is read in
   full first and cited as `ADR-X#n`.
