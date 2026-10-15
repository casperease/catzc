<#
.SYNOPSIS
    The bicep formatter engine: formats the given Bicep files with the managed Bicep CLI and returns the files it
    changed.
.DESCRIPTION
    One Format-Code engine adapter.
    [ADR-PRIN-CONFIG#2](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config2)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Invoke-BicepFormat.ps1.md#comment1)
.PARAMETER File
    Absolute paths of the .bicep files to format.
.PARAMETER DryRun
    List the files the Bicep CLI would change without writing them.
.OUTPUTS
    [string[]] Absolute paths of the files changed (or, under -DryRun, that would change).
#>
function Invoke-BicepFormat {
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
    $bicep = Resolve-ToolExecutable -Tool bicep
    if (-not ($bicep.Found -and $bicep.VersionOk)) {
        throw "The bicep engine needs the Bicep CLI at the tools.yml pin '$($bicep.Required)' (found: $($bicep.Version ?? 'none')). Run Install-Bicep."
    }

    $changed = [System.Collections.Generic.List[string]]::new()
    $folder = Join-Path ([System.IO.Path]::GetTempPath()) "catzc-bicep-format-$([guid]::NewGuid().ToString('N'))"
    [System.IO.Directory]::CreateDirectory($folder) | Out-Null
    try {
        # Numbered copies: two files of one name in different folders never collide.
        for ($index = 0; $index -lt $File.Count; $index++) {
            [System.IO.File]::Copy($File[$index], (Join-Path $folder "$index.bicep"))
        }
        $pattern = (Join-Path $folder '*.bicep') -replace '\\', '/'
        $result = Invoke-Executable "`"$($bicep.Path)`" format --pattern `"$pattern`"" -PassThru -NoAssert -Silent
        if ($result.ExitCode -ne 0) {
            throw "bicep could not format the Bicep files (exit $($result.ExitCode)):`n$($result.Full)"
        }
        for ($index = 0; $index -lt $File.Count; $index++) {
            $original = [System.IO.File]::ReadAllBytes($File[$index])
            $formatted = [System.IO.File]::ReadAllBytes((Join-Path $folder "$index.bicep"))
            if (-not [System.Linq.Enumerable]::SequenceEqual($original, $formatted)) {
                if (-not $DryRun) {
                    [System.IO.File]::WriteAllBytes($File[$index], $formatted)
                }
                $changed.Add($File[$index])
            }
        }
    }
    finally {
        [System.IO.Directory]::Delete($folder, $true)
    }

    , [string[]] $changed.ToArray()
}
