<#
---
catzc:
  immutable:
    with_body_sha: "0c819846975e"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Repair-IdiomaticNames.Tests.ps1
    cites:
      - ADR-AUTO-IDIOM-HELDBYGATE
      - ADR-PWSH-DRYRUN
---
#>

function Repair-IdiomaticNames {
    <#
    .SYNOPSIS
        Moves each misnamed folder and file on disk to the name its language's idiom gives it, and lists every tracked file that names the
        old path.

    .DESCRIPTION
        The repair half of the naming gate (ADR-AUTO-IDIOM-HELDBYGATE): Test-IdiomaticNames reports a folder or a file whose name breaks
        its language's case, and this moves it to the rendering the languages config gives (LanguagesConfig.MisnamedPathRenames). Files
        move first and folders deepest first, so no move invalidates another; each move goes through a temporary name, so a case-only
        rename lands on a case-insensitive file system. It edits no file's text: each result lists the tracked files whose text names the
        old path, for one-file-at-a-time edits, and git records the moves when the user commits them.

    .PARAMETER DryRun
        Return the planned moves and the files that name each old path, and move nothing (ADR-PWSH-DRYRUN).

    .OUTPUTS
        [pscustomobject] { Kind, Path, Target, Language, NamedBy, Moved }, one per move, in the order they run.

    .EXAMPLE
        Repair-IdiomaticNames -DryRun
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [switch] $DryRun
    )

    Assert-SourceTree

    $root = Get-RepositoryRoot
    $tracked = @(Get-GitTrackedPath '.')
    $renames = @((Get-Config -Config languages).MisnamedPathRenames([string[]] $tracked))
    $ordered = @($renames | Where-Object kind -eq 'file') + @($renames | Where-Object kind -eq 'folder' |
            Sort-Object -Property { ($_.path -split '/').Count } -Descending)

    # Who names each old path is read before anything moves, while every tracked path is still where the index says.
    $texts = @{}
    foreach ($path in $tracked) {
        $full = Join-Path $root $path
        if ([System.IO.File]::Exists($full)) {
            $texts[$path] = [System.IO.File]::ReadAllText($full)
        }
    }
    $plan = foreach ($rename in $ordered) {
        $namedBy = @(foreach ($path in $texts.Keys | Sort-Object) {
                if ($path -cne $rename.path -and $texts[$path].Contains($rename.path)) {
                    $path
                }
            })
        [pscustomobject]@{ Rename = $rename; NamedBy = $namedBy }
    }

    foreach ($step in $plan) {
        $rename = $step.Rename
        $namedBy = $step.NamedBy
        $moved = $false
        if ($null -eq $rename.target) {
            Write-Message "$($rename.path): the $($rename.language) case has no rendering for its name — rename it by hand."
        }
        elseif (-not $DryRun) {
            $from = Join-Path $root $rename.path
            $to = Join-Path $root $rename.target
            $temporary = "$from.rename-$([guid]::NewGuid().ToString('N').Substring(0, 8))"
            if ($rename.kind -eq 'folder') {
                [System.IO.Directory]::Move($from, $temporary)
                [System.IO.Directory]::Move($temporary, $to)
            }
            else {
                [System.IO.File]::Move($from, $temporary)
                [System.IO.File]::Move($temporary, $to)
            }
            Write-Message "Moved $($rename.path) to $($rename.target); $($namedBy.Count) tracked file(s) name the old path."
            $moved = $true
        }
        [pscustomobject]@{
            Kind     = $rename.kind
            Path     = $rename.path
            Target   = $rename.target
            Language = $rename.language
            NamedBy  = $namedBy
            Moved    = $moved
        }
    }
}
