<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-AdrCodesFileMetaFact.ps1
    kind: fact-function
    module: Catzc.Base.QualityGates
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Get-AdrCodesFileMetaFact.Tests.ps1
    adrs:
      - ADR-REPO-LINK#5
  config:
    synopsis: 'The adr-codes meta kind''s fact: the ADR citations the file and its comment page make, sorted and without duplicates.'
    description: |-
      A citation is `ADR-<CODE>#<n>`; the colon form belongs to a rule's own heading and is no citation. A rule the file defines itself is
      listed under `defines`, never here, and a code the ADR index does not register is no citation. A file whose class the kind's
      `domain_classes` setting names also lists a bare `ADR-<CODE>`, and one whose class `held_classes` names keeps every code its head
      already holds, so the head is where its citations live; both settings default to the classes the kind selects. The spelling is
      [ADR-REPO-LINK#5](/docs/adr/repository/markdown-links.md#rule-adr-repo-link5), and the order is ordinal, so a rerun never moves a code.
    parameters:
      State: What Get-MarkdownMetaState read from the file.
      Path: The file's repository-relative path.
      Kind: The registry entry that subscribed this function.
    outputs: '[System.Collections.Specialized.OrderedDictionary] one entry per key of the kind.'
---
#>

function Get-AdrCodesFileMetaFact {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory)]
        [pscustomobject] $State,

        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [Catzc.Base.QualityGates.FileMetaKind] $Kind
    )

    $text = if ($State.PSObject.Properties['Body']) {
        $State.Body
    }
    else {
        $State.Rest
    }
    $repositoryRoot = Get-RepositoryRoot
    $page = (Get-Config -Config comments).PageFor($Path)
    if ($page -and (Test-Path -LiteralPath (Join-Path $repositoryRoot $page) -PathType Leaf)) {
        $text += "`n" + (Get-MarkdownMetaState -Text ([System.IO.File]::ReadAllText((Join-Path $repositoryRoot $page)))).Body
    }

    $registry = if ($Kind.registry) {
        $Kind.registry
    }
    else {
        Get-Config -Config file-meta
    }
    $fileClass = $registry.ClassOf($Path)
    $withDomain = [Catzc.Base.QualityGates.FileMetaKind]::InClasses($Kind.ClassSetting('domain_classes'), $fileClass)
    $map = Get-AdrCitationMap -RepositoryRoot $repositoryRoot
    # Body text cites a rule as ADR-<CODE>#<n> only: a wildcard there is a mention of a family, never a citation. The group form is the
    # head's own notation, read back below from the held list.
    $pattern = if ($withDomain) {
        '(?<![\w-])ADR-[A-Z]+(?:-[A-Z]+)*(?:#\d+|(?![\w#-]|:\d))'
    }
    else {
        '(?<![\w-])ADR-[A-Z]+(?:-[A-Z]+)*#\d+'
    }
    $codes = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($match in [regex]::Matches($text, $pattern)) {
        [void] $codes.Add($match.Value)
    }
    if (-not $withDomain) {
        foreach ($defined in (Get-AdrDefinedRule -Text $text)) {
            [void] $codes.Remove($defined)
        }
    }
    # Only a code the ADR index registers is a citation: a fixture code or a placeholder named in prose is not.
    foreach ($code in @($codes)) {
        $isRule = $code -match '^(?<adr>.+)#(?<rule>\d+)$'
        $registered = if ($isRule) {
            $ruleNumber = 0
            [int]::TryParse($Matches['rule'], [ref] $ruleNumber) -and $map.HasRule($Matches['adr'], $ruleNumber)
        }
        else {
            $map.HasCode($code) -or $map.IsDomainCode($code)
        }
        if (-not $registered) {
            [void] $codes.Remove($code)
        }
    }
    $held = [Catzc.Base.QualityGates.FileMetaKind]::InClasses($Kind.ClassSetting('held_classes'), $fileClass)
    if ($held -and $State.PSObject.Properties['DerivedLists'] -and $State.DerivedLists.Contains($Kind.keys[0])) {
        foreach ($token in $State.DerivedLists[$Kind.keys[0]]) {
            try {
                foreach ($code in [Catzc.Base.Docs.AdrCodeForm]::Expand($token)) {
                    [void] $codes.Add($code)
                }
            }
            catch [System.FormatException] {
                continue
            }
        }
    }
    [ordered]@{ $Kind.keys[0] = [string[]] @([Catzc.Base.Docs.AdrCodeForm]::Minimize([string[]] @($codes))) }
}
