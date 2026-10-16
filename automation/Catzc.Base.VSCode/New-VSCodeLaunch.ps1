<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.VSCode/New-VSCodeLaunch.ps1
    name: new-vs-code-launch
    filetype: ps1
    kind: function
    subkind: writer
    language: powershell
    track: automation
    module: Catzc.Base.VSCode
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.VSCode/tests/New-VSCodeLaunch.Tests.ps1
    cites:
      - ADR-REPO-ROOTCFG
  config:
    synopsis: |-
      Renders .vscode/launch.json content from the vscode-launch registry — the debug launch profiles the
      editor offers.
    description: |-
      Reads the authored launch-profile registry (configs/vscode-launch.yml, via Get-Config -Config
      vscode-launch, which maps and validates it as a VscodeLaunchConfig) and renders it to the launch.json content: the version and
      configurations as JSON, in registry order, without a head (Build-RootConfig writes the generated-file head as a JSONC comment
      head, which VS Code reads in launch.json). The per-profile explanations live as comments in the yml — the
      authored, searched artifact — not in the rendering.

      This is a pure renderer: it returns the content and writes nothing — it is the `generator` the
      root-config registry names for the .vscode/launch.json target, and Build-RootConfig owns the write.
      See [ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md).
    outputs: '[string] The rendered launch.json content (LF-joined; the writer canonicalises).'
    examples:
      - New-VSCodeLaunch
---
#>

function New-VSCodeLaunch {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $config = Get-Config -Config vscode-launch

    $rendered = [ordered]@{
        version        = $config.version
        configurations = @($config.configurations | ForEach-Object { $_.fields })
    }

    (ConvertTo-Json -InputObject $rendered -Depth 8) + "`n"
}
