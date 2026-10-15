<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Invoke-Prettier.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-PRIN-CONFIG#2
---
#>

<#
.SYNOPSIS
    The prettier formatter engine: formats the given files with Prettier and returns the files it changed.
.DESCRIPTION
    Exit 1 means files differ and is expected; a higher exit is a tool error, for example an unparsable file.
.PARAMETER File
    Absolute paths of the files to format.
.PARAMETER DryRun
    List the files Prettier would change without writing them.
.OUTPUTS
    [string[]] Absolute paths of the files changed (or, under -DryRun, that would change).
#>
function Invoke-Prettier {
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
    if (-not (Test-Command 'prettier')) {
        throw 'Prettier is not installed. Install it with:  Install-Prettier   (or: npm install -g prettier), then re-run Format-Code.'
    }

    $changed = [System.Collections.Generic.List[string]]::new()
    foreach ($batch in @(Split-CommandLineBatch -Item $File)) {
        $quoted = ($batch | ForEach-Object { "`"$_`"" }) -join ' '
        $list = Invoke-Executable "prettier --list-different $quoted" -PassThru -NoAssert -Silent
        if ($list.ExitCode -gt 1) {
            throw "Prettier failed (exit $($list.ExitCode)): $($list.Full)"
        }
        # --list-different prints one differing path per line; strip any ANSI colour first.
        $plain = $list.Output -replace '\x1b\[[0-9;]*m', ''
        foreach ($line in ($plain -split '\r?\n')) {
            if ($line.Trim() -and $line -notmatch '^\[') {
                $changed.Add([System.IO.Path]::GetFullPath($line.Trim(), (Get-RepositoryRoot)))
            }
        }
    }

    if ($changed.Count -gt 0 -and -not $DryRun) {
        foreach ($batch in @(Split-CommandLineBatch -Item $changed.ToArray())) {
            $quoted = ($batch | ForEach-Object { "`"$_`"" }) -join ' '
            $write = Invoke-Executable "prettier --write $quoted" -PassThru -NoAssert -Silent
            if ($write.ExitCode -ne 0) {
                throw "Prettier failed (exit $($write.ExitCode)): $($write.Full)"
            }
        }
    }

    , [string[]] $changed.ToArray()
}
