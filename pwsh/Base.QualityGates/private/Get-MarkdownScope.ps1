function Get-MarkdownScope {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [string[]] $Path,

        [string] $OptOut
    )

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    $lookup = Get-ScopeLookup -RepositoryRoot $root -Path $Path -Command Get-MarkdownScope

    # A tracked file deleted from disk but not yet committed has nothing to read.
    $markdown = @(Get-GitTrackedPath $lookup | Where-Object {
            $_ -like '*.md' -and [System.IO.File]::Exists((Join-Path $root $_))
        })
    if ($markdown.Count -eq 0) {
        return , [string[]] @()
    }

    # Assigned, so the set holds the paths, not the one array.
    $exemptPaths = Get-ContentExemptPath -RepositoryRoot $root -Path $markdown
    $exempt = [System.Collections.Generic.HashSet[string]]::new([string[]] @($exemptPaths))
    $attributes = if ($OptOut) {
        Get-GitAttributeValue -RepositoryRoot $root -Path $markdown -Attribute $OptOut
    }
    else {
        @{}
    }
    , [string[]] @($markdown | Where-Object {
            $classes = $attributes[$_]
            -not $exempt.Contains($_) -and -not ($OptOut -and $classes -and $classes[$OptOut] -eq 'unset')
        })
}
