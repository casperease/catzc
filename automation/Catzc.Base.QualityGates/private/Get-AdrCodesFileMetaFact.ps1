<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/private/Get-AdrCodesFileMetaFact.ps1
    folder: private
    name: get-adr-codes-file-meta-fact
    filetype: ps1
    kind: function
    subkind: fact
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    page: docs/references/automation/catzc-base-qualitygates/private/Get-AdrCodesFileMetaFact.ps1.md
    test: automation/Catzc.Base.QualityGates/tests/Get-AdrCodesFileMetaFact.Tests.ps1
    cites:
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

    $fileClass = (Get-FileKind $Path).Class
    $withDomain = [Catzc.Base.QualityGates.FileMetaKind]::InClasses($Kind.ClassSetting('domain_classes'), $fileClass)
    $map = Get-AdrCitationMap -RepositoryRoot $repositoryRoot
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
    if ($held -and $State.PSObject.Properties['EdgeLists'] -and $State.EdgeLists.Contains($Kind.keys[0])) {
        foreach ($token in $State.EdgeLists[$Kind.keys[0]]) {
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
    [ordered]@{ $Kind.keys[0] = [string[]] @([Catzc.Base.Docs.AdrCodeForm]::Minimize([string[]] @($codes), $map)) }
}
