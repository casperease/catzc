<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-module-system/Test-FunctionDependency.ps1.md"
  header: "generated"
---
#>

function Test-FunctionDependency {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string] $ModulesRoot = (Get-CatzcModulesRoot),

        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    # Every source .ps1 is parsed once, through [System.IO]: Get-ChildItem -Recurse costs about 20 ms a call in the provider.
    $parsed = [System.Collections.Generic.List[object]]::new()
    $definitions = @{}
    $issues = [System.Collections.Generic.List[string]]::new()

    foreach ($moduleDir in (Get-ChildPath $ModulesRoot -Depth 1 -Directory)) {
        $module = [System.IO.Path]::GetFileName($moduleDir)
        if ($module -match '^\.') {
            continue
        }

        # A module's scripts sit at most three levels below its folder (tests/types/ is the deepest).
        $files = Get-ChildPath $moduleDir -File -Filter '*.ps1' -Depth 3 | Sort-Object
        foreach ($path in $files) {
            $name = [System.IO.Path]::GetFileName($path)
            # Matched on the module-relative path: an absolute temp path can itself sit under /private/ (macOS $TestDrive does).
            $rel = $path.Substring($moduleDir.Length)
            if ($name -like '*.Tests.ps1' -or $rel -match '[/\\]assets[/\\]') {
                continue
            }

            $tokens = $null
            $errors = $null
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$tokens, [ref]$errors)
            $collectors = [Catzc.Base.ModuleSystem.FunctionCallCollector]::Collect($ast)
            $isPrivate = $rel -match '^[/\\]private[/\\]'

            $parsed.Add([pscustomobject]@{ Module = $module; FileName = $name; Functions = $collectors })

            foreach ($collector in $collectors) {
                $fn = $collector.Function
                $info = @{ Module = $module; File = $name; Line = $fn.Extent.StartLineNumber; Private = $isPrivate }

                if (-not $definitions.ContainsKey($fn.Name)) {
                    $definitions[$fn.Name] = $info
                    continue
                }

                # Two public definitions of one name collide, the last import shadowing the other; private ones are each module's own.
                $existing = $definitions[$fn.Name]
                if (-not $isPrivate -and -not $existing.Private) {
                    $issues.Add("Duplicate public function '$($fn.Name)' in $($existing.Module)/$($existing.File) and $module/$name (exported names must be unique).")
                    continue
                }
                if ($existing.Private -and -not $isPrivate) {
                    $definitions[$fn.Name] = $info
                }
            }
        }
    }

    # One Get-Command per distinct external name, memoised: a whole-session snapshot measures slower than these few dozen lookups.
    $isLoadedCommand = [System.Collections.Generic.Dictionary[string, bool]]::new([System.StringComparer]::OrdinalIgnoreCase)

    foreach ($entry in $parsed) {
        foreach ($collector in $entry.Functions) {
            $localDefs = [System.Collections.Generic.HashSet[string]]::new(
                $collector.NestedFunctionNames,
                [System.StringComparer]::OrdinalIgnoreCase
            )

            foreach ($call in $collector.Calls) {
                $cmdName = $call.Name
                if (-not $cmdName.Contains('-')) {
                    continue
                }
                if ($definitions.ContainsKey($cmdName)) {
                    continue
                }
                if ($localDefs.Contains($cmdName)) {
                    continue
                }
                if (-not $isLoadedCommand.ContainsKey($cmdName)) {
                    $isLoadedCommand[$cmdName] = [bool](Get-Command $cmdName -ErrorAction Ignore)
                }
                if ($isLoadedCommand[$cmdName]) {
                    continue
                }

                $issues.Add("$($collector.Function.Name) -> $cmdName ($($entry.Module)/$($entry.FileName):$($call.Line)) does not resolve to a command.")
            }
        }
    }

    Write-QualityGateReport -Subject function-dependency -Title Test-FunctionDependency -Issues $issues.ToArray() `
        -Facts ([ordered]@{ FunctionCount = $definitions.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
