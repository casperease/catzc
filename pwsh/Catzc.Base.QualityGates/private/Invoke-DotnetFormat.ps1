<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Invoke-DotnetFormat.ps1.md"
  header: "generated"
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

    Assert-DotnetOffline $root
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
