<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Test-Comments.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: public
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-PRIN-CONFIG#1
      - ADR-PRIN-ONELIVE#1
---
#>

<#
.SYNOPSIS
    Quality gate: every long comment lives in its file's comment page, and every residue and page section pair up.
.DESCRIPTION
    The shape of the insight line is Format-Comments' to fix, not this gate's.
    [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35),
    [ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1),
    [ADR-PRIN-ONELIVE#1](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive1)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/Test-Comments.ps1.md#comment1)
.PARAMETER Path
    Files or folders to check. Default: every file in scope.
.PARAMETER RepositoryRoot
    The repository root paths and pages resolve against. Default: the loaded repository root.
.PARAMETER OutputFolder
    The report base folder. Default: the reports.yml folder for this gate.
.PARAMETER PassThru
    Return the report object instead of throwing on issues.
.OUTPUTS
    [pscustomobject] With -PassThru only.
.EXAMPLE
    Test-Comments
.EXAMPLE
    Test-Comments -Path automation/Catzc.Base.Files -PassThru
#>
function Test-Comments {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string[]] $Path,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    $config = Get-Config -Config comments
    $issues = [System.Collections.Generic.List[string]]::new()
    $residueCount = 0
    $scope = @(Get-CommentScope -RepositoryRoot $RepositoryRoot -Path $Path)
    foreach ($entry in $scope) {
        $text = [System.IO.File]::ReadAllText((Join-Path $RepositoryRoot $entry.File))
        foreach ($block in [Catzc.Base.QualityGates.CommentEngine]::FindBlocks($text, $entry.Extension, $entry.Language, $config)) {
            $issues.Add("$($entry.File):$($block.StartLine + 1): a $($block.ProseLineCount)-line comment is still in the file — run Export-Comments")
        }

        $residues = @([Catzc.Base.QualityGates.CommentEngine]::FindResidues($text, $entry.Extension))
        $pagePath = Join-Path $RepositoryRoot $entry.Page
        $pageExists = Test-Path -LiteralPath $pagePath -PathType Leaf
        if ($residues.Count -eq 0 -and -not $pageExists) {
            continue
        }
        $residueCount += $residues.Count
        $sections = [System.Collections.Generic.HashSet[int]]::new()
        if ($pageExists) {
            foreach ($number in [Catzc.Base.QualityGates.CommentEngine]::SectionNumbers([System.IO.File]::ReadAllText($pagePath))) {
                $sections.Add($number) | Out-Null
            }
        }

        $linked = [System.Collections.Generic.HashSet[int]]::new()
        foreach ($residue in $residues) {
            $at = "$($entry.File):$($residue.StartLine + 1)"
            if ($residue.Page -ne $entry.Page) {
                $issues.Add("${at}: comment:$($residue.Number) links $($residue.Page), not the file's page $($entry.Page)")
                continue
            }
            if (-not $linked.Add($residue.Number)) {
                $issues.Add("${at}: comment:$($residue.Number) is used twice in the file")
                continue
            }
            if (-not $sections.Contains($residue.Number)) {
                $issues.Add("${at}: comment:$($residue.Number) has no section in $($entry.Page)")
            }
        }
        foreach ($number in $sections) {
            if (-not $linked.Contains($number)) {
                $issues.Add("$($entry.Page): section comment:$number is linked by no residue in $($entry.File)")
            }
        }
    }

    $facts = [ordered]@{
        FileCount    = $scope.Count
        ResidueCount = $residueCount
    }
    Write-QualityGateReport -Subject comments -Title Test-Comments -Issues $issues.ToArray() -Facts $facts `
        -OutputFolder $OutputFolder -PassThru:$PassThru
}
