<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Files/Set-FileLink.ps1
    name: set-file-link
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.Files
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
    relatives:
      page: docs/references/automation/catzc-base-files/Set-FileLink.ps1.md
      test: automation/Catzc.Base.Files/tests/Set-FileLink.Tests.ps1
    adrs:
      - ADR-AUTO-DRYRUN
      - ADR-AUTO-XPLAT#7
      - ADR-REPO-ROOTCFG
  config:
    synopsis: Materialises a file as a filesystem link to a source of truth — the link sibling of Write-FileIfChanged.
    description: |-
      Ensures the file at -Path is a link to the file at -Target, so the two are one file by construction and
      drift is impossible. Idempotent (check before acting): an existing artifact counts as current only when it
      is a symbolic link resolving to the target, or a hard link whose bytes are CR-insensitively identical to
      the target. Anything else — a plain file (an old generated copy, even with identical content), a symbolic
      link to the wrong place, a hard link orphaned by a git rewrite of the source — is deleted and recreated.

      Creation depends on the platform: a relative symbolic link everywhere it is permitted; on Windows without the
      symlink privilege (the enterprise default — no admin, no Developer Mode) a hard link, which needs no
      privilege since the repository is one volume. When neither works the function throws — it never degrades
      to a content copy, which would silently reintroduce the drift the link exists to remove.

      A pure primitive like Write-FileIfChanged: no console output — callers own their reporting. See
      [ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md).
    parameters:
      Path: Path of the link file to create or verify.
      Target: Path of the source file, which must exist, that the link must resolve to.
      DryRun: |-
        Report whether the link would change without touching the filesystem. See
        [ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md).
    outputs: '[bool] $true when the link was (re)created (or would be, under -DryRun); $false when already current.'
    examples:
      - Set-FileLink -Path $rootSettingsPath -Target $sourceSettingsPath
      - Set-FileLink -Path $rootSettingsPath -Target $sourceSettingsPath -DryRun
---
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

    $item = Get-Item -LiteralPath $Path -Force -ErrorAction Ignore
    if ($item -and $item.LinkType -eq 'SymbolicLink') {
        $resolved = $item.ResolveLinkTarget($true)
        if ($resolved) {
            $resolvedActual = [System.IO.Path]::GetFullPath($resolved.FullName)
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
            New-Item -ItemType HardLink -Path $Path -Target $resolvedTarget -ErrorAction Stop | Out-Null
        }
    }
    else {
        New-Item -ItemType SymbolicLink -Path $Path -Target $relativeTarget -ErrorAction Stop | Out-Null
    }

    $true
}
