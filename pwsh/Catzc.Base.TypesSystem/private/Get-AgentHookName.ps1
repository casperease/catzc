<#
---
catzc:
  immutable:
    with_body_sha: "02f0758182e1"
---
#>

function Get-AgentHookName {
    <#
    .SYNOPSIS
        Names every agent hook: each folder under .claude/hooks/ that holds a .csproj, in ordinal order.
    #>
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
