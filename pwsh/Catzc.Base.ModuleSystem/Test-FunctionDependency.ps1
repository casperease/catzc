<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1
    name: test-function-dependency
    filetype: ps1
    role: function
    subkind: gate
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.ModuleSystem/tests/Test-FunctionDependency.Tests.ps1
    docs: "[Test-FunctionDependency.ps1.md](docs/references/pwsh/catzc-base-modulesystem/Test-FunctionDependency.ps1.md)"
    cites:
      - ADR-AUTO-TEST-QUALITYGATE
      - ADR-DSGN-RUNMODE
      - ADR-PWSH-PESTER-SYSTEMIOONHOTPATHS
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

    $parsed = [System.Collections.Generic.List[object]]::new()
    $definitions = @{}
    $issues = [System.Collections.Generic.List[string]]::new()

    foreach ($moduleDir in ([System.IO.Directory]::EnumerateDirectories($ModulesRoot) | Sort-Object)) {
        $module = [System.IO.Path]::GetFileName($moduleDir)
        if ($module -match '^\.') {
            continue
        }

        # A module's scripts sit at most three levels below its folder (tests/types/ is the deepest).
        $files = Get-ChildPath $moduleDir -File -Filter '*.ps1' -Depth 3 | Sort-Object
        foreach ($path in $files) {
            $name = [System.IO.Path]::GetFileName($path)
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
