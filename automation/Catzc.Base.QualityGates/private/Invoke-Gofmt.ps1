# catzc:
#   path: automation/Catzc.Base.QualityGates/private/Invoke-Gofmt.ps1
#   module: Catzc.Base.QualityGates
#   visibility: private

<#
.SYNOPSIS
    The gofmt formatter engine: formats the given Go files with the managed go's gofmt and returns the files it
    changed.
.DESCRIPTION
    The gofmt is the one beside the managed go at the pin, never the first on PATH; an off-pin go throws.
    [ADR-PRIN-CONFIG#2](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config2),
    [ADR-AUTO-GO](/docs/adr/automation/go/go-test-artifacts.md)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Invoke-Gofmt.ps1.md#comment1)
.PARAMETER File
    Absolute paths of the .go files to format.
.PARAMETER DryRun
    List the files gofmt would change without writing them.
.OUTPUTS
    [string[]] Absolute paths of the files changed (or, under -DryRun, that would change).
#>
function Invoke-Gofmt {
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
    $go = Resolve-ToolExecutable -Tool go
    if (-not ($go.Found -and $go.VersionOk)) {
        throw "The gofmt engine needs the managed go at the tools.yml pin '$($go.Required)' (found: $($go.Version ?? 'none')). Run Install-Go."
    }
    $gofmt = Join-Path ([System.IO.Path]::GetDirectoryName($go.Path)) ($IsWindows ? 'gofmt.exe' : 'gofmt')
    Assert-PathExist $gofmt -PathType Leaf

    $changed = [System.Collections.Generic.List[string]]::new()
    foreach ($batch in @(Split-CommandLineBatch -Item $File)) {
        $quoted = ($batch | ForEach-Object { "`"$_`"" }) -join ' '
        $list = Invoke-Executable "`"$gofmt`" -l $quoted" -PassThru -NoAssert -Silent
        if ($list.ExitCode -ne 0) {
            throw "gofmt could not read the Go files (exit $($list.ExitCode)):`n$($list.Full)"
        }
        foreach ($line in ($list.Output -split '\r?\n')) {
            if ($line.Trim()) {
                $changed.Add([System.IO.Path]::GetFullPath($line.Trim()))
            }
        }
    }

    if ($changed.Count -gt 0 -and -not $DryRun) {
        foreach ($batch in @(Split-CommandLineBatch -Item $changed.ToArray())) {
            $quoted = ($batch | ForEach-Object { "`"$_`"" }) -join ' '
            Invoke-Executable "`"$gofmt`" -w $quoted" -Silent
        }
    }

    , [string[]] $changed.ToArray()
}
