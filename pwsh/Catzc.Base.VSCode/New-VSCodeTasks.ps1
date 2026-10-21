<#
---
catzc:
  immutable:
    with_body_sha: "12ff78e090d8"
  edges:
    test: pwsh/Catzc.Base.VSCode/tests/New-VSCodeTasks.Tests.ps1
    docs: "[New-VSCodeTasks.ps1.md](docs/references/pwsh/catzc-base-vs-code/New-VSCodeTasks.ps1.md)"
    cites:
      - ADR-REPO-ROOTCFG
---
#>

function New-VsCodeTasks {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $config = Get-Config -Config vscode-tasks

    $rendered = [ordered]@{
        version = $config.version
        tasks   = @($config.tasks)
    }
    if ($config.inputs.Count) {
        $rendered['inputs'] = @($config.inputs)
    }

    (ConvertTo-Json -InputObject $rendered -Depth 8) + "`n"
}
