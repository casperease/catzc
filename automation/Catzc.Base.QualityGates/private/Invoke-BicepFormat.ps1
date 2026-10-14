<#
.SYNOPSIS
    The bicep formatter engine: formats the given Bicep files with the managed Bicep CLI and returns the files it
    changed.
.DESCRIPTION
    One Format-Code engine adapter ([ADR-PRIN-CONFIG#2](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config2)).
    The Bicep CLI is the one at the tools.yml pin (Install-Bicep), never whichever bicep is first on PATH; a missing or
    off-pin CLI throws, naming Install-Bicep. Each file is formatted to a temporary copy (`bicep format --outfile`) and
    compared byte for byte, so -DryRun never touches the file; without -DryRun a changed copy replaces it.
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
    $copy = Join-Path ([System.IO.Path]::GetTempPath()) "catzc-bicep-format-$([guid]::NewGuid().ToString('N')).bicep"
    try {
        foreach ($path in $File) {
            $result = Invoke-Executable "`"$($bicep.Path)`" format `"$path`" --outfile `"$copy`"" -PassThru -NoAssert -Silent
            if ($result.ExitCode -ne 0) {
                throw "bicep could not format '$path' (exit $($result.ExitCode)):`n$($result.Full)"
            }
            $original = [System.IO.File]::ReadAllBytes($path)
            $formatted = [System.IO.File]::ReadAllBytes($copy)
            if (-not [System.Linq.Enumerable]::SequenceEqual($original, $formatted)) {
                if (-not $DryRun) {
                    [System.IO.File]::WriteAllBytes($path, $formatted)
                }
                $changed.Add($path)
            }
        }
    }
    finally {
        if (Test-Path -LiteralPath $copy) {
            Remove-Item -LiteralPath $copy -Force
        }
    }

    , [string[]] $changed.ToArray()
}
