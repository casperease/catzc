function Format-FileMeta {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [string[]] $Path,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [switch] $DryRun,

        [switch] $PassThru
    )

    Assert-SourceTree

    $result = Invoke-FileMetaEngine -RepositoryRoot $RepositoryRoot -Path $Path
    $saved = Save-FileMetaResult -Result $result -RepositoryRoot $RepositoryRoot -DryRun:$DryRun
    $toFix = @($saved.Fixed)
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

    $verb = if ($DryRun) {
        'would format'
    }
    else {
        'formatted'
    }
    Write-Message "File meta: $verb $($toFix.Count) of $($result.FileCount) file(s)."

    $changedFiles = [string[]] @($toFix | ForEach-Object { $_.Path } | Sort-Object)
    if ($PassThru) {
        return [pscustomobject]@{
            ChangedCount = $changedFiles.Count
            ChangedFiles = $changedFiles
            FileCount    = $result.FileCount
            DryRun       = [bool] $DryRun
        }
    }
    $changedFiles
}
