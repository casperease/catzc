<#
---
catzc:
  immutable:
    with_body_sha: d20e0c1278d1
  edges:
    test: pwsh/Catzc.Base.Overlay/tests/Assert-CatzcOverlay.Tests.ps1
    docs: "[Assert-CatzcOverlay.ps1.md](../../docs/references/pwsh/catzc-base-overlay/Assert-CatzcOverlay.ps1.md)"
    cites:
      - ADR-AUTO-OVERLAY
---
#>

function Assert-CatzcOverlay {
    [CmdletBinding()]
    param(
        [object[]] $Entry = @(Get-CatzcOverlay)
    )

    $violations = [System.Collections.Generic.List[string]]::new()
    $sealed = @((Get-Config -Config configs).sealedConfigs)

    foreach ($item in $Entry) {
        switch ($item.Kind) {
            'Unknown' {
                $violations.Add("$($item.RelativePath): not an override point; under a bundled module's folder the overlay holds <Function>.ps1, private/<Function>.ps1, configs/<config>.yml, assets/<path> and tests/<path>")
            }
            'FunctionOverride' {
                $shape = @(Get-FunctionFileViolation -Path $item.File -RelativePath $item.RelativePath)
                foreach ($violation in $shape) {
                    $violations.Add($violation)
                }
                if ($shape.Count -gt 0) {
                    break
                }
                $module = Get-Module $item.Module
                $original = if ($module) {
                    $module.Invoke({ param($name) Get-Command -Name $name -CommandType Function -ErrorAction Ignore }, $item.Target)
                }
                if ($null -eq $original -or $original.ModuleName -ne $item.Module) {
                    $violations.Add("$($item.RelativePath): $($item.Module) has no function $($item.Target) to override; a new function belongs in a local module")
                    break
                }
                $isExported = $module.ExportedFunctions.ContainsKey($item.Target)
                if ($item.Visibility -eq 'public' -and -not $isExported) {
                    $violations.Add("$($item.RelativePath): $($item.Target) is private in $($item.Module); override it under private/")
                    break
                }
                if ($item.Visibility -eq 'private' -and $isExported) {
                    $violations.Add("$($item.RelativePath): $($item.Target) is public in $($item.Module); override it at the module folder's root, not under private/")
                    break
                }
                foreach ($violation in @(Get-OverlayContractViolation -Original $original -Path $item.File -RelativePath $item.RelativePath)) {
                    $violations.Add($violation)
                }
            }
            'ConfigFragment' {
                if ($item.Target -in $sealed) {
                    $violations.Add("$($item.RelativePath): config '$($item.Target)' is sealed (configs.yml overridable: false); the overlay may not change it")
                }
                elseif (-not [System.IO.File]::Exists([System.IO.Path]::Combine((Get-CatzcModulesRoot), $item.Module, 'configs', "$($item.Target).yml"))) {
                    $violations.Add("$($item.RelativePath): $($item.Module) ships no config '$($item.Target)' to merge onto; a new config belongs in a local module")
                }
            }
            'AssetOverride' {
                $marker = "/$($item.Module)/"
                $relative = $item.RelativePath.Substring($item.RelativePath.IndexOf($marker, [System.StringComparison]::Ordinal) + $marker.Length)
                $bundled = [System.IO.Path]::Combine((Get-CatzcModulesRoot), $item.Module, $relative)
                if (-not [System.IO.File]::Exists($bundled)) {
                    $violations.Add("$($item.RelativePath): $($item.Module) ships no asset $relative to replace; a new asset belongs in a local module")
                }
            }
            'LocalModule' {
                foreach ($violation in @(Get-LocalModuleViolation -Path $item.File -RelativePath $item.RelativePath)) {
                    $violations.Add($violation)
                }
            }
        }
    }

    if ($violations.Count -gt 0) {
        throw ("The consumer overlay breaks $($violations.Count) rule(s) of ADR-AUTO-OVERLAY:`n  " + ($violations -join "`n  "))
    }
}
