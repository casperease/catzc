<#
.SYNOPSIS
    Materialises a file as a filesystem link to a source of truth — the link sibling of Write-FileIfChanged.
.DESCRIPTION
    Ensures the file at -Path is a link to the file at -Target, so the two are one file by construction and drift is...
    [ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md)
    [comment:1](/docs/references/automation/catzc-base-files/Set-FileLink.ps1.md#comment1)
.PARAMETER Path
    Path of the link file to create or verify.
.PARAMETER Target
    Path of the source file, which must exist, that the link must resolve to.
.PARAMETER DryRun
    Report whether the link would change without touching the filesystem.
    [ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md)
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

    # The no-op path: current means "is a link to the target" — a plain file with identical content is stale, because...
    # [comment:3](/docs/references/automation/catzc-base-files/Set-FileLink.ps1.md#comment3)
    $item = Get-Item -LiteralPath $Path -Force -ErrorAction Ignore
    if ($item -and $item.LinkType -eq 'SymbolicLink') {
        $resolved = $item.ResolveLinkTarget($true)
        if ($resolved) {
            $resolvedActual = [System.IO.Path]::GetFullPath($resolved.FullName)
            # Path equality is case-insensitive on Windows, case-sensitive elsewhere.
            # [ADR-AUTO-XPLAT#7](/docs/adr/automation/cross-platform.md#rule-adr-auto-xplat7)
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
        # A hard link has no target to read back; link identity plus CR-insensitive content equality is the honest...
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
            # No symlink privilege — the expected non-admin case.
            # [comment:6](/docs/references/automation/catzc-base-files/Set-FileLink.ps1.md#comment6)
            New-Item -ItemType HardLink -Path $Path -Target $resolvedTarget -ErrorAction Stop | Out-Null
        }
    }
    else {
        New-Item -ItemType SymbolicLink -Path $Path -Target $relativeTarget -ErrorAction Stop | Out-Null
    }

    $true
}
