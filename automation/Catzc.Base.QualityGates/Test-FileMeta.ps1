<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Test-FileMeta.ps1
    kind: gate-function
    module: Catzc.Base.QualityGates
    visibility: public
    adrs:
      - ADR-AUTO-TEST#35
---
#>

<#
.SYNOPSIS
    The file meta quality gate: fails on any in-scope file whose meta block differs from what Format-FileMeta would write.
.DESCRIPTION
    A key no meta kind owns is reported too: the author decides whether it belongs in `config` or goes.
.PARAMETER Path
    Files or folders to check. Default: every in-scope file.
.PARAMETER RepositoryRoot
    The repository root paths are relative to. Default: the loaded repository root.
.PARAMETER OutputFolder
    The report base folder. Defaults to <out>/test-file-meta.
.PARAMETER PassThru
    Return a result object ({ Subject; IssueCount; Issues; ReportPath; FileCount }) instead of throwing.
.OUTPUTS
    Throws on any violation; with -PassThru, returns the result object.
.EXAMPLE
    Test-FileMeta
.EXAMPLE
    (Test-FileMeta -PassThru).Issues
#>
function Test-FileMeta {
    [CmdletBinding()]
    param(
        [string[]] $Path,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    $result = Invoke-FileMetaEngine -RepositoryRoot $RepositoryRoot -Path $Path
    $issues = @($result.Files | ForEach-Object { $_.Findings } | ForEach-Object {
            $remedy = if ("$($_.Kind)" -eq 'Unowned') {
                'move it under config, or remove it'
            }
            elseif ("$($_.Kind)" -eq 'UnownedHead') {
                'remove it, or declare a meta kind that owns it'
            }
            elseif ("$($_.Kind)" -eq 'MissingSidecar') {
                'write the description beside the file, or list the file under the carrier''s exclude with the reason'
            }
            else {
                'run Format-FileMeta'
            }
            "$($_.Path):$($_.Line) [$($_.Kind)] expected '$($_.Expected)', found '$($_.Actual)' — $remedy"
        })

    Write-QualityGateReport -Subject file-meta -Title Test-FileMeta -Issues $issues `
        -Facts ([ordered]@{ FileCount = $result.FileCount }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
