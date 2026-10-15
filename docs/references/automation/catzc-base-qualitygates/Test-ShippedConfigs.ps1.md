---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Test-ShippedConfigs.ps1.md
    kind: reference
    body_sha: e5bf8ba23b14
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-CONF-LOADING#4
---

# automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over the config
registry ([ADR-CONF-LOADING#4](/docs/adr/configuration/module-config-loading.md#rule-adr-conf-loading4)). It walks
the module folders of the loaded code root (Get-CatzcModulesRoot) — the source tree or a built package — and
lists every issue:

- a shipped configs/<name>.yml with no `type:` entry in configs.yml;
- a configs.yml entry that names no shipped config;
- a configs.yml type that does not resolve;
- a shipped config that does not load through Get-Config (its type rejects it).

A config several modules ship (glossary) is loaded once per owner, with -Module.
```
