<#
---
catzc:
  derived:
    path: automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.TypesSystem
    visibility: public
    relatives:
      page: docs/references/automation/catzc-base-typessystem/Get-AutomationModules.ps1.md
      test: automation/Catzc.Base.TypesSystem/tests/Get-AutomationModules.Tests.ps1
    adrs:
      - ADR-DSGN-RUNMODE
      - ADR-PWSH-PESTER#9
  config:
    synopsis: Returns the names of all automation modules (the non-dot directories under the loaded code root).
    description: |-
      Enumerates the code root (Get-CatzcModulesRoot) and returns each module folder name — the same set
      Import-AllModules discovers and imports. The code root is <RepositoryRoot>/automation in source mode and the
      built package in build mode
      ([ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)); both hold one folder per module under the same name, so the
      list describes the loaded modules in either mode. A non-dot directory is a module; dot-prefixed folders (.internal, .vendor,
      .scriptanalyzer, .compiled) are infrastructure and are excluded (see conventional-folders).

      This is the platform's single source of the automation-module name list: the module- and
      function-dependency analysis validates its declarations against it, the cross-module C# type scan maps
      references against it, and the `-Modules` ArgumentCompleter / ValidateScript on Test-Automation derive
      their values from it — so the list is always the filesystem, never hand-maintained.

      Names are returned sorted ordinally (culture-independent — see cross-platform).
    parameters:
      AutomationRoot: |-
        Path to the automation directory. Defaults to the loaded code root (Get-CatzcModulesRoot); pass a
        fixture tree to isolate a logic test from the real module set.
    examples:
      - Get-AutomationModules
      - Get-AutomationModules -AutomationRoot (Join-Path $fixtureRoot 'automation')
---
#>

function Get-AutomationModules {
    [OutputType([string[]])]
    param(
        [string] $AutomationRoot = (Get-CatzcModulesRoot)
    )

    Assert-PathExist $AutomationRoot -PathType Container

    $names = [System.Collections.Generic.List[string]]::new()
    foreach ($dir in [System.IO.Directory]::EnumerateDirectories($AutomationRoot)) {
        $name = [System.IO.Path]::GetFileName($dir)
        if (-not $name.StartsWith('.')) {
            $names.Add($name)
        }
    }

    $arr = [string[]]$names.ToArray()
    [System.Array]::Sort($arr, [System.StringComparer]::Ordinal)
    @($arr)
}
