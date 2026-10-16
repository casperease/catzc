<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Overlay/private/Get-LocalModuleViolation.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Overlay
    visibility: private
    relatives:
      page: docs/references/automation/catzc-base-overlay/private/Get-LocalModuleViolation.ps1.md
    adrs:
      - ADR-AUTO-OVERLAY
      - ADR-PWSH-ENUM#3
  config:
    synopsis: Returns every reason a consumer's local module cannot load.
    description: |-
      A local module is an overlay folder that names no bundled module, and it follows catzc's own module conventions
      ([ADR-AUTO-OVERLAY](/docs/adr/automation/consumer-overlay.md)): it never takes the reserved Catzc. prefix; it
      carries no types/ (a bundle compiles no C#); it holds only function files at its root (public) and under
      private/, and configs/, assets/ and tests/; every function file passes the shape check every function file
      loaded away from its folder passes (Get-FunctionFileViolation); it has at least one function; and none of its
      public functions takes the name of a command already loaded, which would silently replace a bundled one —
      replacing a bundled function is an override, not a local module.
    parameters:
      Path: The local module's folder.
      RelativePath: The folder as the messages show it.
    outputs: '[string] One message per violation; nothing when the module can load.'
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
