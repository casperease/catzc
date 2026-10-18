<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Get-AdrCodesFileMetaFact.ps1
    folder: private
    name: get-adr-codes-file-meta-fact
    filetype: ps1
    kind: function
    subkind: fact
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    page: docs/references/automation/catzc-base-qualitygates/private/Get-AdrCodesFileMetaFact.ps1.md
    test: automation/Catzc.Base.QualityGates/tests/Get-AdrCodesFileMetaFact.Tests.ps1
    cites:
      - ADR-REPO-LINK#5
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
    [ordered]@{ $Kind.keys[0] = [string[]] @([Catzc.Base.Docs.AdrCodeForm]::Minimize([string[]] @($codes), $map)) }
}
