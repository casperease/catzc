<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-quality-gates/Repair-IdiomaticNames.ps1.md"
  header: "generated"
---
#>

function Repair-IdiomaticNames {
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
