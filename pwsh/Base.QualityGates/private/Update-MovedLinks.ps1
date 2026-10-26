function Update-MovedLinks {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $File,

        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $Map
    )

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    $oldOf = @{}
    foreach ($old in $Map.Keys) {
        $oldOf[$Map[$old]] = $old
    }
    $pattern = [regex]'\]\((?<target>[^)\s#]+)(?<anchor>#[^)\s]*)?\)'
    $changed = @{}
    $invalid = [System.IO.Path]::GetInvalidPathChars()
    # Only Markdown carries these links; a binary file's bytes can look like one and are never rewritten.
    foreach ($relative in @($File | Where-Object { $_.EndsWith('.md', [System.StringComparison]::OrdinalIgnoreCase) })) {
        # A moved file's links were written from where it stood, so each resolves from there and is rewritten from where it stands.
        $was = if ($oldOf.ContainsKey($relative)) {
            $oldOf[$relative]
        }
        else {
            $relative
        }
        $wasFolder = [System.IO.Path]::Combine($root, [System.IO.Path]::GetDirectoryName($was))
        $hereFolder = [System.IO.Path]::Combine($root, [System.IO.Path]::GetDirectoryName($relative))
        $text = [System.IO.File]::ReadAllText([System.IO.Path]::Combine($root, $relative))
        $rewritten = $pattern.Replace($text, {
                param($match)
                $target = $match.Groups['target'].Value
                if ($target -match '^[a-zA-Z][a-zA-Z0-9+.-]*:' -or $target.StartsWith('/') -or $target.IndexOfAny($invalid) -ge 0) {
                    return $match.Value
                }
                $resolved = [System.IO.Path]::GetRelativePath($root,
                    [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($wasFolder, $target))).Replace('\', '/')
                # A link neither end of which moved is left as written, however it is spelled.
                if (-not $Map.Contains($resolved) -and $was -ceq $relative) {
                    return $match.Value
                }
                $to = if ($Map.Contains($resolved)) {
                    $Map[$resolved]
                }
                else {
                    $resolved
                }
                $link = [System.IO.Path]::GetRelativePath($hereFolder, [System.IO.Path]::Combine($root, $to)).Replace('\', '/')
                if ($link -ceq $target) {
                    return $match.Value
                }
                "]($link$($match.Groups['anchor'].Value))"
            })
        if ($rewritten -cne $text) {
            $changed[$relative] = $rewritten
        }
    }
    $changed
}
