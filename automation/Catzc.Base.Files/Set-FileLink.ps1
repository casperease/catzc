<#
.SYNOPSIS
    Materialises a file as a filesystem link to a source of truth — the link sibling of Write-FileIfChanged.
.DESCRIPTION
    Ensures the file at -Path is a link to the file at -Target, so the two are one file by construction and
    drift is impossible. Idempotent (check before acting): an existing artifact counts as current only when it
    is a symbolic link resolving to the target, or a hard link whose bytes are CR-insensitively identical to
    the target. Anything else — a plain file (an old generated copy, even with identical content), a symbolic
    link to the wrong place, a hard link orphaned by a git rewrite of the source — is deleted and recreated.

    Creation is platform-gated: a relative symbolic link everywhere it is permitted; on Windows without the
    symlink privilege (the enterprise default — no admin, no Developer Mode) a hard link, which needs no
    privilege since the repository is one volume. When neither works the function throws — it never degrades
    to a content copy, which would silently reintroduce the drift the link exists to remove.

    A pure primitive like Write-FileIfChanged: no console output — callers own their reporting. See
    docs/adr/repository/generated-root-configs.md.
.PARAMETER Path
    Path of the link file to create or verify.
.PARAMETER Target
    Path of the existing source file the link must resolve to.
.PARAMETER DryRun
    Report whether the link would change without touching the filesystem. See
    docs/adr/automation/prefer-dryrun-over-shouldprocess.md.
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

    # The no-op path: current means "is a link to the target" — a plain file with identical content is stale,
    # because replacing the old generated copy with a link is exactly this function's job.
    $item = Get-Item -LiteralPath $Path -Force -ErrorAction Ignore
    if ($item -and $item.LinkType -eq 'SymbolicLink') {
        $resolved = $item.ResolveLinkTarget($true)
        if ($resolved) {
            $resolvedActual = [System.IO.Path]::GetFullPath($resolved.FullName)
            $current = if ($IsWindows) { $resolvedActual -ieq $resolvedTarget } else { $resolvedActual -ceq $resolvedTarget }
            if ($current) {
                return $false
            }
        }
    }
    elseif ($item -and $item.LinkType -eq 'HardLink') {
        # A hard link has no target to read back; link identity plus CR-insensitive content equality is the
        # honest proxy. A source rewritten by git (new file, old bytes left behind) fails this and re-links.
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
            # No symlink privilege — the expected non-admin case. A hard link needs none and the repository
            # is one volume; a failure here propagates rather than degrading to a copy.
            New-Item -ItemType HardLink -Path $Path -Target $resolvedTarget -ErrorAction Stop | Out-Null
        }
    }
    else {
        New-Item -ItemType SymbolicLink -Path $Path -Target $relativeTarget -ErrorAction Stop | Out-Null
    }

    $true
}
