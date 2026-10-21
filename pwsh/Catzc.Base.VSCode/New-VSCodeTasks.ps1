<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.VSCode/New-VsCodeTasks.ps1
    name: new-vs-code-tasks
    filetype: ps1
    role: function
    subkind: writer
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.VSCode
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.VSCode/tests/New-VsCodeTasks.Tests.ps1
    docs: "[New-VsCodeTasks.ps1.md](docs/references/pwsh/catzc-base-vscode/New-VsCodeTasks.ps1.md)"
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
