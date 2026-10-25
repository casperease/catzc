<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-GeneratedWriterInputFile.ps1.md"
  warning: "Generated Header"
---
#>

function Get-GeneratedWriterInputFile {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [AllowEmptyCollection()]
        [string[]] $InputGlob,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    $depth = 1
    foreach ($glob in @($InputGlob | Where-Object { $_ })) {
        $segments = $glob.Split('/')
        $reach = if ($segments -contains '**') {
            [Catzc.Base.Globs.GlobPattern]::new($glob).LiteralPrefix.Split('/', [System.StringSplitOptions]::RemoveEmptyEntries).Count +
            (Get-Config -Config generated-files).input_depth
        }
        else {
            $segments.Count
        }
        if ($reach -gt $depth) {
            $depth = $reach
        }
    }
    $relative = { param($Path) [System.IO.Path]::GetRelativePath($RepositoryRoot, $Path).Replace('\', '/') }
    [pscustomobject]@{
        File   = [string[]] @(foreach ($path in @(Get-ChildPath $RepositoryRoot -File -Depth $depth)) {
                & $relative $path
            })
        Folder = [string[]] @(foreach ($path in @(Get-ChildPath $RepositoryRoot -Directory -Depth $depth)) {
                & $relative $path
            })
    }
}
