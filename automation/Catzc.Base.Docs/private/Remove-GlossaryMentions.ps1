<#
.SYNOPSIS
    Blanks the mentions in a piece of prose — backtick spans and quoted text — keeping its line breaks.
.DESCRIPTION
    The avoided-phrasing gate (G4) is about use, not mention
    ([ADR-REPO-VOCAB](/docs/adr/repository/controlled-vocabulary.md),
    [ADR-REPO-VOCAB#5](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab5)): a phrase written inside
    backticks, "double quotes", or “curly quotes” names the phrase rather
    than using it. This replaces every such span with spaces, keeping each newline, so the remaining prose keeps its
    offsets and a match still maps to its line. A span may wrap lines but never crosses a blank line, so a stray
    quote cannot swallow the rest of a document.

    Private helper for the glossary gates; not exported.
.PARAMETER Text
    The prose to blank the mentions of.
.OUTPUTS
    [string] The prose with every mention replaced by spaces (newlines kept).
.EXAMPLE
    Remove-GlossaryMentions 'avoid "widget suite", say `gadget run`'
#>
function Remove-GlossaryMentions {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Text
    )

    # One character of a span: anything but the closing delimiter, or a newline not followed by a blank line.
    $span = {
        param([string] $open, [string] $close)
        [regex]::Escape($open) + '(?:[^' + [regex]::Escape($close) + '\n]|\n(?![ \t]*\n))*?' + [regex]::Escape($close)
    }
    $pattern = @(
        (& $span '`' '`')
        (& $span '"' '"')
        (& $span ([string][char]0x201C) ([string][char]0x201D))
    ) -join '|'

    [regex]::Replace($Text, $pattern, {
            param($match)
            $match.Value -replace '[^\n]', ' '
        })
}
