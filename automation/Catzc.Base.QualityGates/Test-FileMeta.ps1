<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/Test-FileMeta.ps1
    name: test-file-meta
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    cites:
      - ADR-AUTO-TEST#35
  config:
    synopsis: 'The file meta quality gate: fails on any in-scope file whose meta block differs from what Format-FileMeta would write.'
    description: 'A key no meta kind owns is reported too: the author decides whether it belongs in `config` or goes.'
    parameters:
      Path: 'Files or folders to check. Default: every in-scope file.'
      RepositoryRoot: 'The repository root paths are relative to. Default: the loaded repository root.'
      OutputFolder: The report base folder. Defaults to <out>/test-file-meta.
      PassThru: Return a result object ({ Subject; IssueCount; Issues; ReportPath; FileCount }) instead of throwing.
    outputs: Throws on any violation; with -PassThru, returns the result object.
    examples:
      - Test-FileMeta
      - (Test-FileMeta -PassThru).Issues
---
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

    Write-QualityGateReport -Subject file-meta -Title Test-FileMeta -Issues $issues `
        -Facts ([ordered]@{ FileCount = $result.FileCount }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
