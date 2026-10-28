function Get-GeneratedGuardHook {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    $answer = Invoke-Executable 'git rev-parse --git-path hooks' -WorkingDirectory $root -PassThru -Silent
    $folder = "$($answer.Output)".Trim()
    if (-not $folder) {
        throw "Get-GeneratedGuardHook: git named no hooks folder for '$root'."
    }

    $marker = '# catzc-generated-guard-hook: written by Enable-GeneratedGuardHook, removed by Disable-GeneratedGuardHook.'
    $shim = @(
        '#!/bin/sh'
        $marker
        'exec pwsh -NoProfile -Command ". ./importer.ps1; Assert-GeneratedStaysCommitted"'
        ''
    ) -join "`n"

    [pscustomobject] @{
        Path   = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($root, $folder, 'pre-commit'))
        Marker = $marker
        Shim   = $shim
    }
}
