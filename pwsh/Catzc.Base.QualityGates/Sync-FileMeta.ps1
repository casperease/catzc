function Sync-FileMeta {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,

        [switch] $DryRun,

        [switch] $PassThru
    )

    $root = [System.IO.Path]::GetFullPath((Get-RepositoryRoot))
    Assert-PathExist $Path
    $full = [System.IO.Path]::GetFullPath((Resolve-Path -LiteralPath $Path).ProviderPath)
    Assert-True ([System.IO.File]::Exists($full)) -ErrorText "Sync-FileMeta: '$Path' is a folder; it brings one file up to date (Format-Code and Format-FileMeta take folders)."
    $relative = [System.IO.Path]::GetRelativePath($root, $full) -replace '\\', '/'
    Assert-False ($relative -eq '..' -or $relative.StartsWith('../')) -ErrorText "Sync-FileMeta: '$Path' lies outside the repository '$root'."

    $formatted = @(Format-Code -Path $full -NoCache -DryRun:$DryRun -PassThru)
    $meta = Format-FileMeta -Path $full -DryRun:$DryRun -PassThru

    $changed = @($formatted | ForEach-Object { $_.ChangedFiles }).Count -gt 0 -or $meta.ChangedCount -gt 0
    $unfixable = [string[]] @($formatted | ForEach-Object { $_.Unfixable.Values })
    if ($PassThru) {
        return [pscustomobject]@{
            Path      = $relative
            Changed   = $changed
            Unfixable = $unfixable
            DryRun    = [bool] $DryRun
        }
    }
    if ($changed) {
        $relative
    }
}
