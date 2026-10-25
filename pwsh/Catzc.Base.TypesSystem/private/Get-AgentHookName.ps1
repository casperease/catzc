<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-types-system/private/Get-AgentHookName.ps1.md"
  warning: "Generated Header"
---
#>

function Get-AgentHookName {
    [CmdletBinding()]
    [OutputType([string[]])]
    param()

    $hooks = Join-Path (Get-RepositoryRoot) '.claude/hooks'
    if (-not [System.IO.Directory]::Exists($hooks)) {
        return [string[]] @()
    }
    [string[]] $names = @(Get-ChildPath $hooks -Directory -Depth 1 -Exclude @('bin') | Where-Object {
            @(Get-ChildPath $_ -File -Filter '*.csproj' -Depth 1).Count -gt 0
        } | ForEach-Object { [System.IO.Path]::GetFileName($_) })
    [Array]::Sort($names, [System.StringComparer]::Ordinal)
    , $names
}
