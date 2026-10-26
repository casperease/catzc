function Get-DiagramArticleStem {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        # The repository-relative paths to look in: the tracked files and the changed ones.
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $Candidate
    )

    # A `yml drawio` block directly above its png's image names one stem; a slide is never a carrier.
    $pattern = '(?m)^```yml drawio[ \t]*\r?\n(?:(?!```)[^\r\n]*\r?\n)*```[ \t]*\r?\n(?:[ \t]*\r?\n)*!\[[^\]]*\](?:\((?:\./)?\.assets/([^/)]+)\.drawio\.png\)|\[([^\]]+)\])'
    foreach ($page in @($Candidate | Where-Object { $_ -cmatch '^docs/.+\.md$' -and -not $_.EndsWith('.slide.md') } |
                Select-Object -Unique)) {
        $full = Join-Path $RepositoryRoot $page
        if (-not [System.IO.File]::Exists($full)) {
            continue
        }
        $folder = $page.Substring(0, $page.LastIndexOf('/'))
        $text = [System.IO.File]::ReadAllText($full)
        $references = Get-DiagramImageReference -Text $text
        foreach ($match in [regex]::Matches($text, $pattern)) {
            # An inline image names its png; a reference names it through its definition, and one naming no diagram is no stem.
            $name = if ($match.Groups[1].Success) {
                $match.Groups[1].Value
            }
            else {
                $references[$match.Groups[2].Value.ToLowerInvariant()]
            }
            if ($name) {
                "$folder/.assets/$name"
            }
        }
    }
}
