<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Move-FunctionHelpCitation.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
---
#>

<#
.SYNOPSIS
    Moves a function's ADR citations out of the synopsis and onto the sorted tail of the description.
.DESCRIPTION
    Only a parenthesised citation is moved out of the synopsis and only a line made of citations out of the...
    [ADR-REPO-HELP#2](/docs/adr/repository/function-help.md#rule-adr-repo-help2)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Move-FunctionHelpCitation.ps1.md#comment1)
.PARAMETER Section
    The help sections, each @{ Name; Arg; Lines }. The synopsis and description sections are changed in place.
.OUTPUTS
    [string[]] The problems a person must settle; empty when none.
#>
function Move-FunctionHelpCitation {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [object[]] $Section
    )

    $link = '\[ADR-[A-Z]+(?:-[A-Z]+)*(?:#\d+)?\]\([^)]*\)'
    $bare = 'ADR-[A-Z]+(?:-[A-Z]+)*(?:#\d+)?'
    $either = "(?:$link|$bare)"
    $parenthesised = [regex]::new("\s*\(\s*$either(?:\s*,\s*$either)*\s*\)")
    $citationOnly = [regex]::new("^\s*$either(?:\s*(?:,|and)?\s*$either)*\s*,?\s*$")
    $docsLink = [regex]::new('^\s*\[comment:\d+\]\([^)]*\)\s*$')
    $problems = [System.Collections.Generic.List[string]]::new()

    $synopsis = $Section | Where-Object { $_.Name -ceq '.SYNOPSIS' } | Select-Object -First 1
    $description = $Section | Where-Object { $_.Name -ceq '.DESCRIPTION' } | Select-Object -First 1
    $moved = [System.Collections.Generic.List[string]]::new()
    $docsLinks = [System.Collections.Generic.List[string]]::new()

    if ($null -ne $synopsis) {
        $joined = $synopsis.Lines -join "`n"
        foreach ($match in $parenthesised.Matches($joined)) {
            $moved.Add($match.Value)
        }
        if ($moved.Count -gt 0 -and $null -eq $description) {
            $problems.Add('the synopsis cites an ADR and the help has no description to move the citation to')
            $moved.Clear()
        }
        elseif ($moved.Count -gt 0) {
            $stripped = $parenthesised.Replace($joined, '')
            if ([regex]::IsMatch($stripped, $bare)) {
                $problems.Add('the synopsis cites an ADR outside parentheses, so it cannot be moved without rewriting the sentence')
                $moved.Clear()
            }
            else {
                $synopsis.Lines = [System.Collections.Generic.List[string]]::new([string[]] @($stripped -split "`n"))
            }
        }
        elseif ([regex]::IsMatch($joined, $bare)) {
            $problems.Add('the synopsis cites an ADR outside parentheses, so it cannot be moved without rewriting the sentence')
        }
    }

    if ($null -eq $description) {
        return , [string[]] $problems.ToArray()
    }

    $kept = [System.Collections.Generic.List[string]]::new()
    foreach ($line in $description.Lines) {
        if ($docsLink.IsMatch($line)) {
            $docsLinks.Add($line.TrimEnd())
        }
        elseif ($line.Trim() -and $citationOnly.IsMatch($line)) {
            $moved.Add($line)
        }
        else {
            $kept.Add($line)
        }
    }
    if ($moved.Count -eq 0 -and $docsLinks.Count -eq 0) {
        return , [string[]] $problems.ToArray()
    }

    # A link spelling wins over a bare spelling of the same citation.
    $byCitation = [ordered]@{}
    foreach ($text in $moved) {
        foreach ($match in [regex]::Matches($text, "$link|$bare")) {
            $spelled = $match.Value
            $citation = if ($spelled.StartsWith('[', [System.StringComparison]::Ordinal)) {
                $spelled.Substring(1, $spelled.IndexOf(']', [System.StringComparison]::Ordinal) - 1)
            }
            else {
                $spelled
            }
            if (-not $byCitation.Contains($citation) -or $spelled.StartsWith('[', [System.StringComparison]::Ordinal)) {
                $byCitation[$citation] = $spelled
            }
        }
    }
    # Sorted by code, then by rule number; a citation of the whole ADR has no number and comes first.
    $keyed = foreach ($citation in $byCitation.Keys) {
        $number = -1
        if ($citation -match '#(\d+)$') {
            $number = [int] $Matches[1]
        }
        [pscustomobject]@{ Citation = $citation; Code = ($citation -replace '#\d+$', ''); Number = $number }
    }
    $sorted = @($keyed | Sort-Object -Property Code, Number | ForEach-Object Citation)

    while ($kept.Count -gt 0 -and [string]::IsNullOrWhiteSpace($kept[$kept.Count - 1])) {
        $kept.RemoveAt($kept.Count - 1)
    }
    for ($index = 0; $index -lt $sorted.Count; $index++) {
        $separator = if ($index -lt $sorted.Count - 1) {
            ','
        }
        else {
            ''
        }
        $kept.Add('    ' + $byCitation[$sorted[$index]] + $separator)
    }
    foreach ($docs in $docsLinks) {
        $kept.Add($docs)
    }
    $description.Lines = $kept
    , [string[]] $problems.ToArray()
}
