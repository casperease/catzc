<#
---
catzc:
  immutable:
    with_body_sha: "6b6889302c67"
  edges:
    docs: "[Get-LocalModuleViolation.ps1.md](../../../docs/references/pwsh/catzc-base-overlay/private/Get-LocalModuleViolation.ps1.md)"
    cites:
      - ADR-AUTO-OVERLAY
      - ADR-PWSH-ENUM-ALWAYSBOUNDED
---
#>

function Get-LocalModuleViolation {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [string] $RelativePath
    )

    $name = [System.IO.Path]::GetFileName($Path)
    if ($name.StartsWith('Catzc.', [System.StringComparison]::OrdinalIgnoreCase)) {
        "${RelativePath}: the Catzc. prefix is reserved, and the bundle has no module $name; is it a missing bundle module, or a typo?"
        return
    }

    $functionFiles = [System.Collections.Generic.List[string]]::new()
    $files = [string[]] @(Get-ChildPath $Path -File -Depth 64 -Exclude @() -PruneVendor $false)
    [System.Array]::Sort($files, [System.StringComparer]::Ordinal)
    foreach ($file in $files) {
        $relative = [System.IO.Path]::GetRelativePath($Path, $file).Replace('\', '/')
        $segments = $relative.Split('/')
        $isFolderFunction = $segments.Count -eq 1 -or ($segments.Count -eq 2 -and $segments[0] -ceq 'private')
        $isFunctionFile = $isFolderFunction -and $relative.EndsWith('.ps1', [System.StringComparison]::OrdinalIgnoreCase)
        if ($isFunctionFile) {
            $functionFiles.Add($file)
            foreach ($violation in @(Get-FunctionFileViolation -Path $file -RelativePath "$RelativePath/$relative")) {
                $violation
            }
        }
        elseif ($segments[0] -ceq 'types') {
            "${RelativePath}/${relative}: a local module carries no types/; a bundle compiles no C#"
        }
        elseif (-not (($segments.Count -eq 2 -and $segments[0] -ceq 'configs' -and $relative.EndsWith('.yml', [System.StringComparison]::Ordinal)) -or
                ($segments.Count -ge 2 -and $segments[0] -cin 'assets', 'tests'))) {
            "${RelativePath}/${relative}: not part of a module; a local module holds <Function>.ps1, private/<Function>.ps1, configs/<config>.yml, assets/<path> and tests/<path>"
        }
    }
    if ($functionFiles.Count -eq 0) {
        "${RelativePath}: a local module has at least one function file"
    }

    foreach ($file in $functionFiles) {
        if ([System.IO.Path]::GetFileName([System.IO.Path]::GetDirectoryName($file)) -ceq 'private') {
            continue
        }
        $public = [System.IO.Path]::GetFileNameWithoutExtension($file)
        $existing = Get-Command -Name $public -ErrorAction Ignore | Where-Object { $_.ModuleName -ne $name } | Select-Object -First 1
        if ($existing) {
            "${RelativePath}: public function $public takes the name of a command already loaded$(if ($existing.ModuleName) { " from $($existing.ModuleName)" }); to replace a bundled function, override it in its module's folder"
        }
    }
}
