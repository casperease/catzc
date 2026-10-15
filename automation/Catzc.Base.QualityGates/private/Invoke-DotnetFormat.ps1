<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Invoke-DotnetFormat.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-PRIN-CONFIG#2
---
#>

<#
.SYNOPSIS
    The dotnet-format formatter engine: formats the given C# files with `dotnet format whitespace` and returns the
    files it changed.
.DESCRIPTION
    Exit 2 means files differ and is expected; any other non-zero exit is a tool error and throws with the output.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Invoke-DotnetFormat.ps1.md#comment1)
.PARAMETER File
    Absolute paths of the .cs files to format.
.PARAMETER DryRun
    List the files dotnet format would change without writing them.
.OUTPUTS
    [string[]] Absolute paths of the files changed (or, under -DryRun, that would change).
#>
function Invoke-DotnetFormat {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $File,

        [switch] $DryRun
    )

    if ($File.Count -eq 0) {
        return , [string[]] @()
    }
    $root = [System.IO.Path]::GetFullPath((Get-RepositoryRoot))
    $relative = @($File | ForEach-Object { [System.IO.Path]::GetRelativePath($root, $_) -replace '\\', '/' } |
            Where-Object { -not ($_ -eq '..' -or $_.StartsWith('../')) })

    $changed = [System.Collections.Generic.List[string]]::new()
    $report = Join-Path ([System.IO.Path]::GetTempPath()) "catzc-dotnet-format-$([guid]::NewGuid().ToString('N'))"
    try {
        foreach ($batch in @(Split-CommandLineBatch -Item $relative)) {
            $null = New-Item -ItemType Directory -Path $report -Force
            $quoted = ($batch | ForEach-Object { "`"$_`"" }) -join ' '
            $check = Invoke-Executable "dotnet format whitespace `"$root`" --folder --verify-no-changes --report `"$report`" --include $quoted" -PassThru -NoAssert -Silent
            if ($check.ExitCode -notin 0, 2) {
                throw "dotnet format could not format the C# files (exit $($check.ExitCode)):`n$($check.Full)"
            }
            foreach ($json in @(Get-ChildPath $report -File -Filter '*.json' -Depth 1)) {
                foreach ($entry in @(Get-Content -LiteralPath $json -Raw | ConvertFrom-Json)) {
                    $changed.Add([System.IO.Path]::GetFullPath($entry.FilePath))
                }
                Remove-Item -LiteralPath $json
            }
        }
    }
    finally {
        if (Test-Path -LiteralPath $report) {
            Remove-Item -LiteralPath $report -Recurse -Force
        }
    }

    if ($changed.Count -gt 0 -and -not $DryRun) {
        $changedRelative = @($changed | ForEach-Object { [System.IO.Path]::GetRelativePath($root, $_) -replace '\\', '/' })
        foreach ($batch in @(Split-CommandLineBatch -Item $changedRelative)) {
            $quoted = ($batch | ForEach-Object { "`"$_`"" }) -join ' '
            $write = Invoke-Executable "dotnet format whitespace `"$root`" --folder --include $quoted" -PassThru -NoAssert -Silent
            if ($write.ExitCode -ne 0) {
                throw "dotnet format could not format the C# files (exit $($write.ExitCode)):`n$($write.Full)"
            }
        }
    }

    , [string[]] @($changed | Select-Object -Unique)
}
