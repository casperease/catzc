---
catzc:
  immutable:
    with_body_sha: "269fbf877d06"
    repo_status: locked
    path: docs/references/automation/catzc-base-config/private/Get-ConfigRegistry.ps1.md
    folder: docs/references/automation/catzc-base-config/private
    name: get-config-registry-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-PWSH-CACHE#4
---

# automation/Catzc.Base.Config/private/Get-ConfigRegistry.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the config registry (this module's configs/configs.yml), keyed by config name.

### description

The registry Get-Config reads: maps each shipped config name to its C# config type (`type:`). An
unregistered config loads raw. Loaded directly here (not via Get-Config, to avoid
circularity), validated by the C# type Catzc.Base.Config.ConfigsConfig (which the registry registers for
its own 'configs' config), and cached for the session. The file is located through Get-CatzcModuleRoot, so
the shipped registry resolves inside the loaded module in both run modes
([ADR-AUTO-ASSETDEP#1](../../../../adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1)).

## comment:1

Above `$cached =...`, written with `#`.

```text
strict-clean
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```
