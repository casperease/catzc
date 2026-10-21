<#
---
catzc:
  immutable:
    with_body_sha: "381381965cfc"
  edges:
    test: pwsh/Catzc.Tooling.Core/tests/Resolve-SessionToolHint.Tests.ps1
    docs: "[Resolve-SessionToolHint.ps1.md](docs/references/pwsh/catzc-tooling-core/private/Resolve-SessionToolHint.ps1.md)"
---
#>

function Resolve-SessionToolHint {
    [OutputType([System.Management.Automation.CommandInfo])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Config
    )

    foreach ($hint in $Config.session_path_hints) {
        $dir = [System.Environment]::ExpandEnvironmentVariables($hint)
        if ([string]::IsNullOrWhiteSpace($dir) -or -not (Test-Path -LiteralPath $dir)) {
            continue
        }

        $names = @($Config.command) +
        (@($env:PATHEXT -split ';') | Where-Object { $_ } | ForEach-Object { "$($Config.command)$_" })
        $present = $false
        foreach ($n in $names) {
            if (Test-Path -LiteralPath (Join-Path $dir $n)) {
                $present = $true
                break
            }
        }
        if (-not $present) {
            continue
        }

        $sep = [System.IO.Path]::PathSeparator
        if (($env:PATH -split $sep) -notcontains $dir) {
            $env:PATH = "$env:PATH$sep$dir"
            Write-Message "Session PATH: appended '$dir' so $($Config.command) resolves (session_path_hints)"
        }
        return Get-Command $Config.command -CommandType Application -ErrorAction Ignore | Select-Object -First 1
    }

    return $null
}
