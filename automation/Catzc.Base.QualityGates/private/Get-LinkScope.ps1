<#
.SYNOPSIS
    Lists the repository-relative files the link engine reads.
.DESCRIPTION
    With no -Path, every git-tracked file (Get-GitTrackedPath) — the repository as committed, not whatever lies
    untracked in the working folder. With -Path, the given files and the files under the given folders, from the
    filesystem. Either way the classes .gitattributes declares are never aligned: linguist-vendored (the third-party
    tree), catzc-fixture (test fixture trees, whose links are data on purpose), and linguist-generated (files the
    automation writes — the ADR index and glossary, the managed root-config copies — whose sources are aligned
    instead). No list of its own: a new class is declared in the .gitattributes source.
.PARAMETER RepositoryRoot
    The repository root the returned paths are relative to.
.PARAMETER Path
    Optional files or folders (absolute or relative to the current location) to limit the scope to.
.OUTPUTS
    [string[]] repository-relative, '/'-separated paths.
#>
function Get-LinkScope {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [string[]] $Path
    )

    # Never enumerate a whole drive: neither the repository root nor a -Path may be a disk root (C:\, /, a UNC
    # share root). A relative -Path resolves against the current location, so '.' run from C:\ would be all of C:.
    $isDiskRoot = {
        param([string] $FullPath)
        $FullPath.TrimEnd('\', '/') -eq ([System.IO.Path]::GetPathRoot($FullPath)).TrimEnd('\', '/')
    }

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    Assert-False (& $isDiskRoot $root) -ErrorText "Get-LinkScope: the repository root '$root' is a disk root — refusing to scan a whole drive."
    $files = if ($Path) {
        foreach ($item in $Path) {
            $full = [System.IO.Path]::GetFullPath((Resolve-Path -LiteralPath $item).Path)
            Assert-False (& $isDiskRoot $full) -ErrorText "Get-LinkScope: -Path '$item' resolves to the disk root '$full' — refusing to scan a whole drive."
            $found = if (Test-Path -LiteralPath $full -PathType Container) {
                [System.IO.Directory]::EnumerateFiles($full, '*', [System.IO.SearchOption]::AllDirectories)
            }
            else {
                $full
            }
            foreach ($file in $found) {
                [System.IO.Path]::GetRelativePath($root, $file) -replace '\\', '/'
            }
        }
    }
    else {
        Get-GitTrackedPath '.'
    }

    $inRepository = @($files | Where-Object { $_ -notmatch '^\.\./' })
    $attributes = Get-GitAttributeValue -RepositoryRoot $root -Path $inRepository -Attribute linguist-vendored, linguist-generated, catzc-fixture
    @($inRepository | Where-Object {
            $classes = $attributes[$_]
            -not $classes -or -not (
                $classes['linguist-vendored'] -in 'set', 'true' -or
                $classes['linguist-generated'] -in 'set', 'true' -or
                $classes['catzc-fixture'] -in 'set', 'true')
        })
}
