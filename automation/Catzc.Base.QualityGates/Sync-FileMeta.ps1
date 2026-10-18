<#
---
catzc:
  config:
    synopsis: Brings one file up to date with the meta head its head policy says it has, formatted as Format-Code leaves it.
    description: |-
      A one-shot for the file at hand, after an edit, a move or a rename: it formats the file with its language's formatter and imprint
      steps (Format-Code, cache off), then imprints, replaces or strips its meta block as the head policy of its class says
      (Format-FileMeta), so a file whose language has no formatter is brought up to date too. A file git does not track yet is taken as
      given; a file git ignores is left alone. The facts come from the registries, git, the disk and the file's text, never from its head
      ([ADR-REPO-FILEMETA#14](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta14)).

      It loads the registries on every call, so it is no loop primitive: a loop asks an Assert- or Test- guard the one question it needs.
      It writes and never judges; Test-FileMeta and Test-Formatting give the verdict.
    parameters:
      Path: The one file to bring up to date, absolute or relative to the current folder, inside the repository.
      DryRun: Report what would change without writing the file.
      PassThru: Return a result object ({ Path; Changed; Unfixable; DryRun }) instead of only the changed path.
    outputs: |-
      [string] the repository-relative path when the file changed (or, under -DryRun, would change); with -PassThru, the result
      object.
    examples:
      - Sync-FileMeta docs/explanation/file-meta.md
      - Sync-FileMeta automation/Catzc.Widget/Get-Widget.ps1 -DryRun -PassThru
---
#>

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
