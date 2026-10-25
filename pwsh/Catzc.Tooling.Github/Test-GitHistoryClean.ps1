<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-github/Test-GitHistoryClean.ps1.md"
  warning: "Generated Header"
---
#>

function Test-GitHistoryClean {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Token,

        [string] $Ref = 'HEAD',

        [string] $RepositoryPath = (Get-RepositoryRoot),

        [string[]] $ExcludePath = @([System.IO.Path]::GetRelativePath((Get-RepositoryRoot), (Join-Path (Get-CatzcModulesRoot) '.vendor')) -replace '\\', '/')
    )

    Assert-PathExist $RepositoryPath -PathType Container

    # The objects the scan starts from: the ref's commit, or every ref's object for --all.
    $roots = Invoke-Executable "git rev-parse $Ref" -WorkingDirectory $RepositoryPath -PassThru -NoAssert -Silent
    if ($roots.ExitCode -ne 0) {
        throw "Cannot resolve ref '$Ref' in '$RepositoryPath': $($roots.Errors)"
    }

    # Every object once, in pack order; the scan walks only what the roots reach.
    $objects = Invoke-Executable 'git cat-file --batch-all-objects --batch --unordered' -WorkingDirectory $RepositoryPath -AsBytes -NoAssert -Silent
    if ($objects.ExitCode -ne 0) {
        throw "Cannot read the objects of '$RepositoryPath': $($objects.Errors)"
    }

    # git ends its lines with LF on every platform; one root per line.
    $rootIds = [string[]] @($roots.Output -split '\r?\n' | Where-Object { $_ })
    $scan = [Catzc.Base.Git.GitHistoryScan]::Scan($objects.Bytes, $rootIds, $Token, $ExcludePath)
    [pscustomobject]@{
        Clean    = $scan.Clean
        Token    = $Token
        Ref      = $Ref
        Blobs    = @($scan.Blobs)
        Paths    = @($scan.Paths)
        Messages = @($scan.Messages)
    }
}
