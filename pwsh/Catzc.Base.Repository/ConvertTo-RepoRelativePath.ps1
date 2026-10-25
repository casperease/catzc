<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-repository/ConvertTo-RepoRelativePath.ps1.md"
  warning: "Generated Header"
---
#>

function ConvertTo-RepoRelativePath {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path
    )

    $full = [IO.Path]::GetFullPath($Path)

    $outputRoot = [IO.Path]::GetFullPath((Get-OutputRoot))
    $fromOutput = [IO.Path]::GetRelativePath($outputRoot, $full)
    if ($fromOutput -ne $full -and -not $fromOutput.StartsWith('..')) {
        if ($fromOutput -eq '.') {
            return 'out'
        }
        return 'out/' + ($fromOutput -replace '\\', '/')
    }

    # 2. Otherwise repo-root-relative; 3. else degrade to a normalized absolute path.
    $root = [IO.Path]::GetFullPath((Get-RepositoryRoot))
    $relative = [IO.Path]::GetRelativePath($root, $full)
    if ($relative -eq $full -or $relative.StartsWith('..')) {
        return $full
    }

    $relative -replace '\\', '/'
}
