<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Slides/private/Get-AdrRuleText.ps1
    folder: private
    name: get-adr-rule-text
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Slides
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  config:
    synopsis: Reads the registry text of one ADR rule, by its citation code.
    description: |-
      Resolves the code through the ADR citation map, opens the ADR, and returns the paragraph under the rule's heading as plain text,
      links reduced to their text and whitespace collapsed, so a slide that quotes the rule can be compared to it (ADR-REPO-SLIDES#4).
      Null when the code is not of the form ADR-NAME#n or the index knows no such rule.
    parameters:
      Code: 'One rule citation, such as ADR-PRIN-EAC#2.'
      RepositoryRoot: The repository root whose ADR index is read.
    outputs: '[string] The rule''s text, or null.'
---
#>

function Get-AdrRuleText {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Code,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    $match = [regex]::Match($Code, '^(ADR-[A-Z0-9]+(?:-[A-Z0-9]+)*)#(\d+)$')
    if (-not $match.Success) {
        return $null
    }
    $adr = $match.Groups[1].Value
    $rule = [int] $match.Groups[2].Value

    $map = Get-AdrCitationMap -RepositoryRoot $RepositoryRoot
    if (-not $map.HasRule($adr, $rule)) {
        return $null
    }
    $file = Join-Path $RepositoryRoot ($map.PathOf($adr).TrimStart('/'))
    Assert-PathExist $file -PathType Leaf

    $lines = [System.IO.File]::ReadAllLines($file)
    $heading = "### Rule ${adr}:$rule"
    $index = [Array]::IndexOf($lines, $heading)
    if ($index -lt 0) {
        return $null
    }

    $paragraph = [System.Collections.Generic.List[string]]::new()
    for ($i = $index + 1; $i -lt $lines.Length; $i++) {
        $line = $lines[$i]
        if ($line.Trim().Length -eq 0) {
            if ($paragraph.Count -gt 0) {
                break
            }
            continue
        }
        if ($line.StartsWith('#', [System.StringComparison]::Ordinal) -or $line.StartsWith('- [', [System.StringComparison]::Ordinal)) {
            break
        }
        $paragraph.Add($line.Trim())
    }

    if ($paragraph.Count -eq 0) {
        return $null
    }
    [Catzc.Base.Slides.SlideSource]::PlainText(($paragraph -join ' '))
}
