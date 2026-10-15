<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Move-FunctionHelpCitation.ps1
    kind: private-function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-REPO-HELP#2
  config:
    synopsis: Takes a function's ADR citations out of its help block, since the meta head lists them.
    description: Only a parenthesised citation is moved out of the synopsis and only a line made of citations out of the description, never prose.
    parameters:
      Section: The help sections, each @{ Name; Arg; Lines }. The synopsis and description sections are changed in place.
    outputs: '[string[]] The problems a person must settle; empty when none.'
---
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
    # A rule id in registry form ends in a colon and a number, which makes it an example value, not a citation.
    $bare = 'ADR-[A-Z]+(?:-[A-Z]+)*(?:#\d+)?(?![A-Za-z0-9-]|:\d)'
    $either = "(?:$link|$bare)"
    $parenthesised = [regex]::new("\s*\(\s*$either(?:\s*,\s*$either)*\s*\)")
    $citationOnly = [regex]::new("^\s*$either(?:\s*(?:,|and)?\s*$either)*\s*,?\s*$")
    $docsLink = [regex]::new('^\s*\[comment:\d+\]\([^)]*\)\s*$')
    $problems = [System.Collections.Generic.List[string]]::new()

    $synopsis = $Section | Where-Object { $_.Name -ceq '.SYNOPSIS' } | Select-Object -First 1
    $description = $Section | Where-Object { $_.Name -ceq '.DESCRIPTION' } | Select-Object -First 1

    if ($null -ne $synopsis) {
        $joined = $synopsis.Lines -join "`n"
        $stripped = $parenthesised.Replace($joined, '')
        if ([regex]::IsMatch($stripped, $bare)) {
            $problems.Add('the synopsis cites an ADR outside parentheses, so it cannot be removed without rewriting the sentence')
        }
        elseif ($stripped -cne $joined) {
            $synopsis.Lines = [System.Collections.Generic.List[string]]::new([string[]] @($stripped -split "`n"))
        }
    }

    if ($null -eq $description) {
        return , [string[]] $problems.ToArray()
    }

    $kept = [System.Collections.Generic.List[string]]::new()
    $docsLinks = [System.Collections.Generic.List[string]]::new()
    $removed = 0
    foreach ($line in $description.Lines) {
        if ($docsLink.IsMatch($line)) {
            $docsLinks.Add($line.TrimEnd())
        }
        elseif ($line.Trim() -and $citationOnly.IsMatch($line)) {
            $removed++
        }
        else {
            $kept.Add($line)
        }
    }
    if ($removed -eq 0 -and $docsLinks.Count -eq 0) {
        return , [string[]] $problems.ToArray()
    }

    while ($kept.Count -gt 0 -and [string]::IsNullOrWhiteSpace($kept[$kept.Count - 1])) {
        $kept.RemoveAt($kept.Count - 1)
    }
    foreach ($docs in $docsLinks) {
        $kept.Add($docs)
    }
    $description.Lines = $kept
    , [string[]] $problems.ToArray()
}
