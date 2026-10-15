<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Files/Set-FileLink.ps1
    kind: function
    module: Catzc.Base.Files
    visibility: public
    adrs:
      - ADR-AUTO-DRYRUN
      - ADR-AUTO-XPLAT#7
      - ADR-REPO-ROOTCFG
---
#>

<#
.SYNOPSIS
    Materialises a file as a filesystem link to a source of truth — the link sibling of Write-FileIfChanged.
.DESCRIPTION
    Never degrades to a content copy, which would silently reintroduce the drift the link exists to remove.
    [comment:1](/docs/references/automation/catzc-base-files/Set-FileLink.ps1.md#comment1)
.PARAMETER Path
    Path of the link file to create or verify.
.PARAMETER Target
    Path of the source file, which must exist, that the link must resolve to.
.PARAMETER DryRun
    A plain file with identical content still reports true, since only a link counts as current.
    [comment:2](/docs/references/automation/catzc-base-files/Set-FileLink.ps1.md#comment2)
.OUTPUTS
    [bool] $true when the link was (re)created (or would be, under -DryRun); $false when already current.
.EXAMPLE
    Set-FileLink -Path $rootSettingsPath -Target $sourceSettingsPath
.EXAMPLE
    Set-FileLink -Path $rootSettingsPath -Target $sourceSettingsPath -DryRun
#>
function Set-FileLink {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,

        [Parameter(Mandatory, Position = 1)]
        [string] $Target,

        [switch] $DryRun
    )

    Assert-PathExist $Target
    $resolvedTarget = [System.IO.Path]::GetFullPath($Target)

    # Only a link is current: a plain file with identical content is stale, since replacing that copy is this job.
    # [comment:3](/docs/references/automation/catzc-base-files/Set-FileLink.ps1.md#comment3)
    $item = Get-Item -LiteralPath $Path -Force -ErrorAction Ignore
    if ($item -and $item.LinkType -eq 'SymbolicLink') {
        $resolved = $item.ResolveLinkTarget($true)
        if ($resolved) {
            $resolvedActual = [System.IO.Path]::GetFullPath($resolved.FullName)
            # The same file may differ only by case on Windows, while Unix treats such paths as two files.
            # [comment:4](/docs/references/automation/catzc-base-files/Set-FileLink.ps1.md#comment4)
            $current = if ($IsWindows) {
                $resolvedActual -ieq $resolvedTarget
            }
            else {
                $resolvedActual -ceq $resolvedTarget
            }
            if ($current) {
                return $false
            }
        }
    }
    elseif ($item -and $item.LinkType -eq 'HardLink') {
        # No target to read back, so a source rewritten by git (old bytes left behind) fails this and re-links.
        # [comment:5](/docs/references/automation/catzc-base-files/Set-FileLink.ps1.md#comment5)
        $existing = [System.IO.File]::ReadAllText($Path) -replace "`r", ''
        $source = [System.IO.File]::ReadAllText($resolvedTarget) -replace "`r", ''
        if ($existing -ceq $source) {
            return $false
        }
    }

    if ($DryRun) {
        return $true
    }

    $directory = [System.IO.Path]::GetDirectoryName($Path)
    if ($directory) {
        [System.IO.Directory]::CreateDirectory($directory) | Out-Null
    }
    if ($item) {
        # Deleting a link removes only the link itself; the target file is untouched.
        [System.IO.File]::Delete($Path)
    }

    # Relative link target, computed at the point of binding, so the link survives a repository move.
    $relativeTarget = [System.IO.Path]::GetRelativePath($directory, $resolvedTarget)
    if ($IsWindows) {
        try {
            New-Item -ItemType SymbolicLink -Path $Path -Target $relativeTarget -ErrorAction Stop | Out-Null
        }
        catch {
            # A hard link needs no privilege and the repository is one volume; a failure here propagates, never a copy.
            # [comment:6](/docs/references/automation/catzc-base-files/Set-FileLink.ps1.md#comment6)
            New-Item -ItemType HardLink -Path $Path -Target $resolvedTarget -ErrorAction Stop | Out-Null
        }
    }
    else {
        New-Item -ItemType SymbolicLink -Path $Path -Target $relativeTarget -ErrorAction Stop | Out-Null
    }

    $true
}
