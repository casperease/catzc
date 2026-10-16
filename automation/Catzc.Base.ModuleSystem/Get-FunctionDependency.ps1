<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: public
    relatives:
      page: docs/references/automation/catzc-base-modulesystem/Get-FunctionDependency.ps1.md
      test: automation/Catzc.Base.ModuleSystem/tests/Get-FunctionDependency.Tests.ps1
    adrs:
      - ADR-AUTO-CACHE#{2,4-6}
      - ADR-AUTO-TEST#4
      - ADR-DSGN-RUNMODE
      - ADR-PWSH-CACHE#4
      - ADR-PWSH-PESTER#9
  config:
    synopsis: Compiles a list of function-to-function calls across all automation modules using AST.
    description: |-
      Parses every .ps1 file (excluding tests) under the automation root, builds a
      definition map of all functions, then walks each function body for CommandAst
      nodes and cross-references them against the map.

      Reads the per-function source files, which exist only in the source tree, so it stops with a named error
      in build mode (Assert-SourceTree, [ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)).
    parameters:
      AutomationRoot: Path to the automation directory. Defaults to the loaded code root (Get-CatzcModulesRoot).
      ParsedScripts: |-
        The call's shared parse of each script; the session cache of the result stays, this only spares a second
        parse of a file within one build.
    examples:
      - Get-FunctionDependency
      - Get-FunctionDependency | Where-Object CrossModule
      - Get-FunctionDependency | Get-ModuleDependency
---
#>

function Get-FunctionDependency {
    param(
        [string] $AutomationRoot = (Get-CatzcModulesRoot),

        [Catzc.Base.Repository.ParsedScripts] $ParsedScripts = [Catzc.Base.Repository.ParsedScripts]::new()
    )

    Assert-SourceTree

    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:functionDependencyCache')) {
        $script:functionDependencyCache = @{}
    }
    if ($script:functionDependencyCache.ContainsKey($AutomationRoot)) {
        return $script:functionDependencyCache[$AutomationRoot]
    }

    $parsed = [System.Collections.Generic.List[object]]::new()
    $definitions = @{}

    foreach ($moduleDir in ([System.IO.Directory]::EnumerateDirectories($AutomationRoot) | Sort-Object)) {
        $module = [System.IO.Path]::GetFileName($moduleDir)
        if ($module -match '^\.') {
            continue
        }

        # A module's scripts sit at most three levels below its folder (tests/types/ is the deepest).
        $files = Get-ChildPath $moduleDir -File -Filter '*.ps1' -Depth 3 | Sort-Object
        foreach ($path in $files) {
            $name = [System.IO.Path]::GetFileName($path)
            if ($name -like '*.Tests.ps1' -or $path -match '[/\\]assets[/\\]') {
                continue
            }

            $ast = $ParsedScripts.Get($path).Ast
            $fns = @([Catzc.Base.Repository.SyntaxSearch]::TopLevelFunctions($ast))

            $parsed.Add([pscustomobject]@{ Module = $module; FileName = $name; Functions = $fns })
            foreach ($fn in $fns) {
                $definitions[$fn.Name] = @{ Module = $module; File = $name; Line = $fn.Extent.StartLineNumber }
            }
        }
    }

    # Walk each already-parsed function body for calls → cross-reference against the full definition map.
    $ret = [System.Collections.Generic.List[PSObject]]::new()
    foreach ($entry in $parsed) {
        foreach ($fn in $entry.Functions) {
            foreach ($call in [Catzc.Base.Repository.SyntaxSearch]::Commands($fn.Body)) {
                $cmdName = $call.GetCommandName()
                if (-not $cmdName -or -not $definitions.ContainsKey($cmdName)) {
                    continue
                }

                $target = $definitions[$cmdName]
                $ret.Add([PSCustomObject]@{
                        CallerModule   = $entry.Module
                        CallerFunction = $fn.Name
                        CallerFile     = $entry.FileName
                        CallerLine     = $call.Extent.StartLineNumber
                        TargetModule   = $target.Module
                        TargetFunction = $cmdName
                        CrossModule    = $entry.Module -ne $target.Module
                    })
            }
        }
    }

    $script:functionDependencyCache[$AutomationRoot] = $ret
    $ret
}
