---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/configs/contracts.yml.md
    kind: comment-page
    body_sha: "0b2cd4e4847c"
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-PWSH-PARAM#4
      - ADR-REPO-CONTRACT#10
      - ADR-REPO-CONTRACT#2
      - ADR-REPO-CONTRACT#8
    links: []
---

# automation/Catzc.Base.Contracts/configs/contracts.yml

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `addressing: full-path`.

```text
Contracts settings for Get-Contract ([ADR-REPO-CONTRACT](/docs/adr/repository/api-contracts.md)).

Every key is optional: an omitted key takes the sensible default declared once on
Catzc.Base.Contracts.ContractsConfig
([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)), and a Get-Contract parameter
overrides the resolved value per call
([ADR-PWSH-PARAM#4](/docs/adr/pwsh/parameter-design.md#rule-adr-pwsh-param4)).
```

## comment:2

Above `addressing: full-path`.

```text
How one contract asset addresses many files
([ADR-REPO-CONTRACT#8](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract8)):
  full-path      an asset addresses the one real file at its own path (built; the default)
  manifest-glob  a glob in a manifest names the files (declared, not built: selecting it throws NotImplemented)
  per-folder     one asset applies to each file of its folder (declared, not built: selecting it throws NotImplemented)
```

## comment:3

Above `target_roots:`.

```text
Each owning module's target root: the repository-relative folder its assets' paths are relative to
([ADR-REPO-CONTRACT#2](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract2)). A module not named here takes
the default, the repository root. contracts/ holds no dot-prefixed folder
([ADR-REPO-CONTRACT#10](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract10)), so a module whose files sit
under a dot-prefixed root names that root here.
```
