<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Invoke-Prettier.ps1
    kind: automation-function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-PRIN-CONFIG#2
  config:
    synopsis: 'The prettier formatter engine: formats the given files with Prettier and returns the files it changed.'
    description: |-
      One Format-Code engine adapter ([ADR-PRIN-CONFIG#2](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config2)):
      every file language languages.yml gives `formatter: prettier` is formatted here. Prettier picks its parser from
      each file's extension and applies the root .prettierrc.yml and .editorconfig, so the Markdown and pipeline YAML
      rules live in those files, not in a command per language.

      `prettier --list-different` names the files that differ; without -DryRun, `prettier --write` then rewrites
      exactly those. The files go to Prettier in batches that keep each command line short. Exit codes: 0 = clean,
      1 = files differ (expected), anything higher is a tool error (a file Prettier cannot parse), which throws with
      Prettier's own output.

      Prettier must be on PATH — install it once with Install-Prettier.
    parameters:
      File: Absolute paths of the files to format.
      DryRun: List the files Prettier would change without writing them.
    outputs: '[string[]] Absolute paths of the files changed (or, under -DryRun, that would change).'
---
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
