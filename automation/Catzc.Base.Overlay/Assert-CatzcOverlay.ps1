<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Overlay/Assert-CatzcOverlay.ps1
    kind: assert
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Overlay
    visibility: public
    relatives:
      test: automation/Catzc.Base.Overlay/tests/Assert-CatzcOverlay.Tests.ps1
    adrs:
      - ADR-AUTO-OVERLAY
  config:
    synopsis: Checks the consumer overlay against its rules and throws once, listing every violation.
    description: |-
      The overlay is the only place a consumer changes what a built bundle does, so it is checked as a whole before
      any of it is applied ([ADR-AUTO-OVERLAY](/docs/adr/automation/consumer-overlay.md)):

        Unknown           an entry that is no override point
        FunctionOverride  one function named for the file, loadable anywhere (Get-FunctionFileViolation); it replaces
                          a function the bundled module has, with the same visibility (a public override replaces an
                          exported function, a private one a function the module keeps to itself); it keeps the
                          original's contract (every parameter, with its type; no new mandatory parameter; the same
                          [OutputType]). A new function belongs in a local module.
        ConfigFragment    merges onto a config the module ships, and never onto a sealed one (configs.yml
                          overridable: false)
        AssetOverride     replaces an asset the module ships; a new asset belongs in a local module
        LocalModule       follows catzc's module conventions (Get-LocalModuleViolation): never the reserved Catzc.
                          prefix, no types/, only function files, configs/, assets/ and tests/, every function file
                          well-shaped, and no public function that takes the name of a command already loaded.

      A consumer's CI runs it on its own to fail early; Import-CatzcOverlay runs it before it applies anything.
    parameters:
      Entry: The overlay entries to check (Get-CatzcOverlay). Defaults to the current overlay.
    examples:
      - Assert-CatzcOverlay
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
                $relative = $item.RelativePath.Substring(".catzc/automation/$($item.Module)/".Length)
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
