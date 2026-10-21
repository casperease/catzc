<#
---
catzc:
  immutable:
    with_body_sha: da6715472cde
  edges:
    test: pwsh/Catzc.Base.ModuleSystem/tests/Get-FunctionDependency.Tests.ps1
    docs: "[Get-FunctionDependency.ps1.md](../../docs/references/pwsh/catzc-base-module-system/Get-FunctionDependency.ps1.md)"
    cites:
      - ADR-AUTO-CACHE-FILESYSTEMDERIVED
      - ADR-AUTO-CACHE-KEYEDBYINPUTS
      - ADR-AUTO-CACHE-READONLYVALUES
      - ADR-AUTO-CACHE-IMPORTERINVALIDATES
      - ADR-AUTO-TEST-SAFESEAMSWAPS
      - ADR-PWSH-CACHE-STRICTSAFEPROBE
      - ADR-PWSH-PESTER-SYSTEMIOONHOTPATHS
      - DDR-RUNMODE
---
#>

function Get-FunctionDependency {
    param(
        [string] $ModulesRoot = (Get-CatzcModulesRoot),

        [Catzc.Base.Repository.ParsedScripts] $ParsedScripts = [Catzc.Base.Repository.ParsedScripts]::new()
    )

    Assert-SourceTree

    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:functionDependencyCache')) {
        $script:functionDependencyCache = @{}
    }
    if ($script:functionDependencyCache.ContainsKey($ModulesRoot)) {
        return $script:functionDependencyCache[$ModulesRoot]
    }

    $parsed = [System.Collections.Generic.List[object]]::new()
    $definitions = @{}

    foreach ($moduleDir in ([System.IO.Directory]::EnumerateDirectories($ModulesRoot) | Sort-Object)) {
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

    $script:functionDependencyCache[$ModulesRoot] = $ret
    $ret
}
