<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-generated-files/private/Get-GeneratedWriterInputFile.ps1.md"
  header: "generated"
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

    # Only a glob with no literal folder walks the root, so a narrow writer pays only for the folders its own globs reach.
    $files = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    $folders = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    $walks = @{}
    foreach ($glob in @($InputGlob | Where-Object { $_ })) {
        if ($glob.IndexOfAny([char[]] '*?[') -lt 0) {
            if ([System.IO.File]::Exists((Join-Path $RepositoryRoot $glob))) {
                [void] $files.Add($glob)
            }
            continue
        }
        $prefix = [Catzc.Base.Globs.GlobPattern]::new($glob).LiteralPrefix
        $rest = $glob.Substring($prefix.Length).Split('/')
        $depth = if ($rest -contains '**') {
            (Get-Config -Config generated-files).input_depth
        }
        else {
            $rest.Count
        }
        if (-not $walks.ContainsKey($prefix) -or $walks[$prefix] -lt $depth) {
            $walks[$prefix] = $depth
        }
    }
    $levels = { param([string] $Prefix) $Prefix.Split('/', [System.StringSplitOptions]::RemoveEmptyEntries).Count }
    # The walker returns full paths under the root, so the relative path is one array-wide cut, never a loop per path.
    $cut = '^.{' + ([System.IO.Path]::GetFullPath($RepositoryRoot).TrimEnd('\', '/').Length + 1) + '}'
    foreach ($prefix in @($walks.Keys | Sort-Object { & $levels $_ })) {
        $covered = @($walks.Keys | Where-Object {
                $_ -ne $prefix -and $prefix.StartsWith($_, [System.StringComparison]::Ordinal) -and
                ((& $levels $prefix) - (& $levels $_) + $walks[$prefix]) -le $walks[$_]
            }).Count -gt 0
        $folder = Join-Path $RepositoryRoot $prefix
        if ($covered -or -not [System.IO.Directory]::Exists($folder)) {
            continue
        }
        $files.UnionWith([string[]] @(@(Get-ChildPath $folder -File -Depth $walks[$prefix]) -replace $cut -replace '\\', '/'))
        $folders.UnionWith([string[]] @(@(Get-ChildPath $folder -Directory -Depth $walks[$prefix]) -replace $cut -replace '\\', '/'))
    }
    [pscustomobject]@{
        File   = [string[]] @($files)
        Folder = [string[]] @($folders)
    }
}
