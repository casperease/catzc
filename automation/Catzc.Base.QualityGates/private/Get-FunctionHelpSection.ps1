# catzc:
#   path: automation/Catzc.Base.QualityGates/private/Get-FunctionHelpSection.ps1
#   module: Catzc.Base.QualityGates
#   visibility: private

<#
.SYNOPSIS
    Splits the text of a comment-based help block into its preamble and its sections.
.DESCRIPTION
    Lines are kept exactly as written, so rendering the sections back in their order reproduces the block.
    [ADR-REPO-HELP#1](/docs/adr/repository/function-help.md#rule-adr-repo-help1)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-FunctionHelpSection.ps1.md#comment1)
.PARAMETER HelpText
    The block comment, from its opening to its closing delimiter, with LF line endings.
.OUTPUTS
    [pscustomobject] @{ Preamble; Section } — the lines before the first keyword, and each section as @{ Name; Arg; Lines }.
#>
function Get-FunctionHelpSection {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $HelpText
    )

    $body = $HelpText.Substring(2, $HelpText.Length - 4)
    if ($body.StartsWith("`n", [System.StringComparison]::Ordinal)) {
        $body = $body.Substring(1)
    }
    if ($body.EndsWith("`n", [System.StringComparison]::Ordinal)) {
        $body = $body.Substring(0, $body.Length - 1)
    }

    $keyword = [regex]::new('^\.(SYNOPSIS|DESCRIPTION|PARAMETER|INPUTS|OUTPUTS|EXAMPLE|NOTES|LINK|COMPONENT|ROLE|FUNCTIONALITY|FORWARDHELPTARGETNAME|FORWARDHELPCATEGORY|REMOTEHELPRUNSPACE|EXTERNALHELP)\b[ \t]*(\S*)[ \t]*$')
    $preamble = [System.Collections.Generic.List[string]]::new()
    $sections = [System.Collections.Generic.List[object]]::new()
    $current = $null
    foreach ($line in $body.Split("`n")) {
        $match = $keyword.Match($line)
        if ($match.Success) {
            $current = [pscustomobject]@{ Name = '.' + $match.Groups[1].Value; Arg = $match.Groups[2].Value; Lines = [System.Collections.Generic.List[string]]::new() }
            $sections.Add($current)
        }
        elseif ($null -eq $current) {
            $preamble.Add($line)
        }
        else {
            $current.Lines.Add($line)
        }
    }
    [pscustomobject]@{ Preamble = $preamble.ToArray(); Section = $sections.ToArray() }
}
