<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/Format-FileMeta.ps1
    name: format-file-meta
    filetype: ps1
    role: function
    subkind: formatter
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Format-FileMeta.Tests.ps1
    docs: "[Format-FileMeta.ps1.md](docs/references/pwsh/catzc-base-qualitygates/Format-FileMeta.ps1.md)"
    cites:
      - ADR-AUTO-CACHE
      - ADR-AUTO-DRYRUN-BRANCHBEFORESIDEEFFECT
      - ADR-REPO-FILEMETA-IMPRINTEDPARTS
      - ADR-REPO-FORMAT-METAIMPRINT
---
#>

function Format-FileMeta {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [string[]] $Path,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [switch] $DryRun,

        [switch] $NoCache,

        [switch] $PassThru
    )

    Assert-SourceTree
    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    $config = Get-Config -Config file-meta
    $scope = @(Get-FileMetaScope -RepositoryRoot $root -Path $Path -Config $config)

    # The cache is Format-Code's own for its file-meta step: one verdict, one cache, so either command skips what the other found clean.
    $stamp = Get-FormatEngineStamp -Engine 'imprint:file-meta' -Settings @((Get-Config -Config languages).steps['file-meta'].settings) -RepositoryRoot $root
    $cachePath = Join-Path (Get-OutputRoot) 'cache/format-code-file-meta.json'
    $cache = if ($NoCache) {
        @{}
    }
    else {
        Get-ResultCache -Path $cachePath
    }
    $byFullPath = [ordered]@{}
    foreach ($entry in $scope) {
        $byFullPath[[System.IO.Path]::GetFullPath((Join-Path $root $entry.Path))] = $entry
    }
    $split = Split-CachedFile -File ([string[]] @($byFullPath.Keys)) -Cache $cache -Stamp $stamp -RepositoryRoot $root
    $pending = @($split.Pending)
    $verb = $DryRun ? 'Checking' : 'Formatting'
    Write-Message "$verb the meta block of $($pending.Count) file(s) ($($split.CachedCount) unchanged since their last check)..."

    $result = Invoke-FileMetaEngine -RepositoryRoot $root -Config $config -Entry @($pending | ForEach-Object { $byFullPath[$_] })
    $saved = Save-FileMetaResult -Result $result -RepositoryRoot $root -DryRun:$DryRun
    $toFix = @($saved.Fixed)

    # A file a person must still repair, or one the run would change, is never recorded as clean, so the next run reports it again.
    $unfixable = @($saved.Unowned | ForEach-Object { [System.IO.Path]::GetFullPath((Join-Path $root $_.Path)) })
    if ($DryRun) {
        $flagged = @($toFix | ForEach-Object { [System.IO.Path]::GetFullPath((Join-Path $root $_.Path)) }) + $unfixable
        Update-ResultCache -Cache $cache -Key $split.Key -Checked $pending -Flagged $flagged
    }
    else {
        Update-ResultCache -Cache $cache -Key $split.Key -Checked @($pending | Where-Object { $_ -notin $unfixable }) -Stamp $stamp -RekeyFromDisk
    }
    Save-ResultCache -Path $cachePath -Cache $cache

    foreach ($file in $toFix) {
        if ($DryRun) {
            Write-Message "Would format $($file.Path) (meta block)."
        }
        else {
            Write-Message "Formatted $($file.Path) (meta block)."
        }
    }
    foreach ($unowned in $saved.Unowned) {
        if ("$($unowned.Kind)" -eq 'ForbiddenConfig') {
            Write-Message "$($unowned.Path) needs a decision by hand: its block holds $($unowned.Actual), but its head policy forbids a block — move the authored keys to their home." -Warning
        }
        else {
            Write-Message "$($unowned.Path) needs a decision by hand: '$($unowned.Actual)' is a key no meta kind owns — expected $($unowned.Expected)." -Warning
        }
    }

    Write-Message "File meta: $($DryRun ? 'would format' : 'formatted') $($toFix.Count) of $($scope.Count) file(s)."

    $changedFiles = [string[]] @($toFix | ForEach-Object { $_.Path } | Sort-Object)
    if ($PassThru) {
        return [pscustomobject]@{
            ChangedCount = $changedFiles.Count
            ChangedFiles = $changedFiles
            FileCount    = $scope.Count
            DryRun       = [bool] $DryRun
        }
    }
    $changedFiles
}
