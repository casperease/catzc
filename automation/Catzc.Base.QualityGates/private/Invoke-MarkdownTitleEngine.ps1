<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Invoke-MarkdownTitleEngine.ps1
    kind: automation-function
    module: Catzc.Base.QualityGates
    visibility: private
  config:
    synopsis: Checks every in-scope Markdown file's title and headings — the one place Format-MarkdownTitle and Test-MarkdownTitle share.
    description: |-
      Resolves the scope (Get-MarkdownScope), reads each file, checks its title (Get-MarkdownTitleFinding) and
      then its headings on the titled text (Get-MarkdownHeadingFinding), so the formatter and the gate can never
      disagree. When a heading's anchor changes, every in-scope file — the whole scope, even when Path narrows the
      check — has its links to that anchor re-pointed (Get-RepointedMarkdownText) and carries an Anchor finding.
    parameters:
      RepositoryRoot: The repository root titles are relative to.
      Path: Optional files or folders to limit the scope to.
    outputs: |-
      [pscustomobject] @{ FileCount; Files } — Files holds every file with a finding: @{ Path; Findings; Fixed }, each
      finding @{ Path; Line; Kind; Actual; Expected }.
---
#>

function Invoke-MarkdownTitleEngine {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [string[]] $Path
    )

    $files = Get-MarkdownScope -RepositoryRoot $RepositoryRoot -Path $Path
    $citation = Get-AdrCitationPath -RepositoryRoot $RepositoryRoot

    $entries = [ordered]@{}
    $rename = @{}
    foreach ($file in $files) {
        $title = Get-MarkdownTitleFinding -RelativePath $file -Text ([System.IO.File]::ReadAllText((Join-Path $RepositoryRoot $file)))
        $heading = Get-MarkdownHeadingFinding -RelativePath $file -Text $title.Fixed -Citation $citation
        $findings = [System.Collections.Generic.List[pscustomobject]]::new()
        if ($title.Kind -ne 'Ok') {
            $findings.Add([pscustomobject]@{ Path = $file; Line = $title.Line; Kind = $title.Kind; Actual = $title.Actual; Expected = $title.Expected })
        }
        foreach ($finding in $heading.Findings) {
            $findings.Add([pscustomobject]@{ Path = $file; Line = $finding.Line; Kind = $finding.Kind; Actual = $finding.Actual; Expected = $finding.Expected })
            if ($finding.Kind -eq 'Reference' -and $finding.From -ne $finding.To) {
                $rename["$file#$($finding.From)"] = $finding.To
            }
        }
        $entries[$file] = [pscustomobject]@{ Path = $file; Findings = $findings; Fixed = $heading.Fixed }
    }

    if ($rename.Count -gt 0) {
        $linking = if ($Path) {
            Get-MarkdownScope -RepositoryRoot $RepositoryRoot
        }
        else {
            $files
        }
        foreach ($file in $linking) {
            $text = if ($entries.Contains($file)) {
                $entries[$file].Fixed
            }
            else {
                [System.IO.File]::ReadAllText((Join-Path $RepositoryRoot $file))
            }
            $repointed = Get-RepointedMarkdownText -RelativePath $file -Text $text -Rename $rename
            if ($repointed -ceq $text) {
                continue
            }
            if (-not $entries.Contains($file)) {
                $entries[$file] = [pscustomobject]@{ Path = $file; Findings = [System.Collections.Generic.List[pscustomobject]]::new(); Fixed = $text }
            }
            $entries[$file].Findings.Add([pscustomobject]@{
                    Path = $file; Line = 0; Kind = 'Anchor'; Actual = 'a link to a renamed heading anchor'; Expected = 'the link re-pointed'
                })
            $entries[$file].Fixed = $repointed
        }
    }

    [pscustomobject]@{
        FileCount = $files.Count
        Files     = @($entries.Values | Where-Object { $_.Findings.Count -gt 0 })
    }
}
