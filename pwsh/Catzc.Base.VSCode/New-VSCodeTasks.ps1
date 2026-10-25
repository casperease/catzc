<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-vs-code/New-VSCodeTasks.ps1.md"
  header: "generated"
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
