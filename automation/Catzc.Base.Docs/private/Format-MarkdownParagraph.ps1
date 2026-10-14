<#
.SYNOPSIS
    Wraps one paragraph or list item of generated markdown at the 140-column prose width, the way Prettier fills it.
.DESCRIPTION
    Greedy fill — each line takes as many words as fit in Width columns, prefix included — which is what Prettier's
    `proseWrap: always` produces, so generated markdown (the ADR index, the glossary) is formatter-stable
    ([ADR-REPO-FORMAT#5](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format5)). The first line carries
    FirstPrefix (a list marker such as '- '), every later line ContinuationPrefix (the marker's indent).

    Prettier never breaks inside an inline code span or a link, so a `code span` and a [text](target) link each count
    as part of one unbreakable word, spaces included. A word longer than the width stays whole on its own line.

    Private helper for the Catzc.Base.Docs generators; not exported.
.PARAMETER Text
    The paragraph text; runs of whitespace outside code spans and links collapse to one space.
.PARAMETER FirstPrefix
    The prefix of the first line (e.g. '- ' or '  - '). Empty for a plain paragraph.
.PARAMETER ContinuationPrefix
    The prefix of every following line (e.g. '  ' or '    '). Empty for a plain paragraph.
.PARAMETER Width
    The maximum line width, prefix included. Defaults to 140, the repository's markdown width.
.OUTPUTS
    [string[]] The wrapped lines.
.EXAMPLE
    Format-MarkdownParagraph -Text $definition -FirstPrefix '- ' -ContinuationPrefix '  '
#>
function Format-MarkdownParagraph {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $Text,

        [string] $FirstPrefix = '',

        [string] $ContinuationPrefix = '',

        [int] $Width = 140
    )

    # A word is a run of code spans, links, and other non-space characters — the units Prettier does not break.
    $words = [regex]::Matches($Text, '(?:`[^`]*`|\[[^\]]*\]\([^)]*\)|\S)+') | ForEach-Object { $_.Value }

    $lines = [System.Collections.Generic.List[string]]::new()
    $prefix = $FirstPrefix
    $line = ''
    foreach ($word in $words) {
        # A code span or link may run across source lines; it prints on one line with single spaces.
        $word = $word -replace '\s+', ' '
        $candidate = if ($line) {
            "$line $word"
        }
        else {
            $word
        }
        if ($line -and ($prefix.Length + $candidate.Length) -gt $Width) {
            $lines.Add($prefix + $line)
            $prefix = $ContinuationPrefix
            $line = $word
        }
        else {
            $line = $candidate
        }
    }
    if ($line) {
        $lines.Add($prefix + $line)
    }

    , $lines.ToArray()
}
