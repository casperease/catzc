<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Docs/Format-MarkdownParagraph.ps1
    name: format-markdown-paragraph
    filetype: ps1
    role: function
    subkind: formatter
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Docs/tests/Format-MarkdownParagraph.Tests.ps1
    docs: "[Format-MarkdownParagraph.ps1.md](docs/references/pwsh/catzc-base-docs/Format-MarkdownParagraph.ps1.md)"
    cites:
      - ADR-REPO-FORMAT-GENERATEDARTIFACTSFORMATTED
---
#>

function Format-MarkdownParagraph {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory, Position = 0)]
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
