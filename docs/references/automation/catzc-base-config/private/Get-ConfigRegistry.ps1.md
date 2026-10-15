---
catzc:
  derived:
    path: docs/references/automation/catzc-base-config/private/Get-ConfigRegistry.ps1.md
    kind: comment-page
    body_sha: c49af383a648
    adrs:
      - ADR-AUTO-ASSETDEP#1
      - ADR-PWSH-CACHE#4
---

# automation/Catzc.Base.Config/private/Get-ConfigRegistry.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The registry Get-Config reads: maps each shipped config name to its C# config type (`type:`). An
unregistered config loads raw. Loaded directly here (not via Get-Config, to avoid
circularity), validated by the C# type Catzc.Base.Config.ConfigsConfig (which the registry registers for
its own 'configs' config), and cached for the session. The file is located through Get-CatzcModuleRoot, so
the shipped registry resolves inside the loaded module in both run modes
([ADR-AUTO-ASSETDEP#1](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1)).
```

## comment:2

Above `$cached = $ExecutionContext.SessionState.PSVariable.GetValue('script:configRe...`.

```text
strict-clean
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```

## comment:3

Above `$cached =...`.

```text
strict-clean
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```
