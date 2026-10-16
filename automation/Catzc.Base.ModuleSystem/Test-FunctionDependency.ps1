<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1
    name: test-function-dependency
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
    relatives:
      page: docs/references/automation/catzc-base-modulesystem/Test-FunctionDependency.ps1.md
      test: automation/Catzc.Base.ModuleSystem/tests/Test-FunctionDependency.Tests.ps1
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-DSGN-RUNMODE
      - ADR-PWSH-PESTER#9
  config:
    synopsis: 'The function dependency quality gate: every function-to-function call resolves to a defined command.'
    description: |-
      Parses every .ps1 file (excluding tests) under the automation root using AST,
      then checks each function call against: (a) the definitions map of automation
      functions, and (b) Get-Command for built-ins, vendor modules, and other loaded
      commands.

      An issue is an unresolved call ('<caller> -> <missing> (<module>/<file>:<line>)') or two modules defining the
      same public (module-root) function name — exported names must be globally unique, mirroring the importer's
      Assert-UniqueModuleFunctionName. Duplicate private names across modules are allowed (privates are
      module-scoped and not exported).

      A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)): it ends
      through Write-QualityGateReport, which writes out/test-function-dependency/, prints every issue, and throws
      once listing them all; -PassThru returns the result instead.

      Must run post-import so Get-Command covers all loaded modules. Reads the per-function source files, which
      exist only in the source tree, so it stops with a named error in build mode (Assert-SourceTree,
      [ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)).
    parameters:
      AutomationRoot: Path to the automation directory. Defaults to the loaded code root (Get-CatzcModulesRoot).
      OutputFolder: The report base folder. Defaults to <out>/test-function-dependency.
      PassThru: Return a result object ({ Subject; IssueCount; Issues; ReportPath; FunctionCount }) instead of throwing.
    outputs: Throws on any issue; with -PassThru, returns the result object.
    examples:
      - Test-FunctionDependency
      - (Test-FunctionDependency -PassThru).Issues
---
#>

function Test-FunctionDependency {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $AutomationRoot = (Get-CatzcModulesRoot),

        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    $parsed = [System.Collections.Generic.List[object]]::new()
    $definitions = @{}
    $issues = [System.Collections.Generic.List[string]]::new()

    foreach ($moduleDir in ([System.IO.Directory]::EnumerateDirectories($AutomationRoot) | Sort-Object)) {
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
