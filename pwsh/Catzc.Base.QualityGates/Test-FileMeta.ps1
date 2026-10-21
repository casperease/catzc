<#
---
catzc:
  immutable:
    with_body_sha: "6a4033072927"
  edges:
    docs: "[Test-FileMeta.ps1.md](../../docs/references/pwsh/catzc-base-quality-gates/Test-FileMeta.ps1.md)"
    cites:
      - ADR-AUTO-TEST-QUALITYGATE
---
#>

function Test-FileMeta {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
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
            elseif ("$($_.Kind)" -eq 'ForbiddenConfig') {
                'move the authored keys to their home (help to the comment page), then run Format-FileMeta'
            }
            elseif ("$($_.Kind)" -eq 'MissingSidecar') {
                'write the description beside the file, or list the file under the carrier''s exclude with the reason'
            }
            else {
                'run Format-FileMeta'
            }
            "$($_.Path):$($_.Line) [$($_.Kind)] expected '$($_.Expected)', found '$($_.Actual)' — $remedy"
        })
    # A file outside the engine's scope still has a comment page; a page citing rules there lights nothing, so it is a finding too.
    $issues += @(Get-SkippedClassCitationFinding -RepositoryRoot $RepositoryRoot -Path $Path)

    Write-QualityGateReport -Subject file-meta -Title Test-FileMeta -Issues $issues `
        -Facts ([ordered]@{ FileCount = $result.FileCount }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
