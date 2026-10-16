<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Invoke-DotnetFormat.ps1
    kind: automation-function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Invoke-DotnetFormat.Tests.ps1
    adrs:
      - ADR-PRIN-CONFIG#2
  config:
    synopsis: |-
      The dotnet-format formatter engine: formats the given C# files with `dotnet format whitespace` and returns the
      files it changed.
    description: |-
      One Format-Code engine adapter ([ADR-PRIN-CONFIG#2](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config2)).
      `dotnet format whitespace --folder` formats by the repository's .editorconfig alone — the same rules the editor's
      C# extension applies — with no project to load, so it takes seconds and needs only the .NET SDK. `--verify-no-changes`
      with a JSON `--report` names the files that differ; without -DryRun, a second run over exactly those rewrites them.
      Exit codes: 0 = clean, 2 = files differ (expected), anything else is a tool error, which throws with the output.

      The workspace is the repository root, so a file outside it is not formatted. A changed C# type source changes the
      compiled-type cache key, so the next import rebuilds the combined types assembly.
    parameters:
      File: Absolute paths of the .cs files to format.
      DryRun: List the files dotnet format would change without writing them.
    outputs: '[string[]] Absolute paths of the files changed (or, under -DryRun, that would change).'
---
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
