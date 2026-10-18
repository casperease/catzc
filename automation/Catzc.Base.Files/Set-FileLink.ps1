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
