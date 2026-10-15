<#
.SYNOPSIS
    The function dependency quality gate: every function-to-function call resolves to a defined command.
.DESCRIPTION
    Parses every.ps1 file (excluding tests) under the automation root using AST, then checks each function call...
    [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35),
    [ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)
    [comment:1](/docs/references/automation/catzc-base-modulesystem/Test-FunctionDependency.ps1.md#comment1)
.PARAMETER AutomationRoot
    Path to the automation directory. Defaults to the loaded code root (Get-CatzcModulesRoot).
.PARAMETER OutputFolder
    The report base folder. Defaults to <out>/test-function-dependency.
.PARAMETER PassThru
    Return a result object ({ Subject; IssueCount; Issues; ReportPath; FunctionCount }) instead of throwing.
.OUTPUTS
    Throws on any issue; with -PassThru, returns the result object.
.EXAMPLE
    Test-FunctionDependency
.EXAMPLE
    (Test-FunctionDependency -PassThru).Issues
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

    # Parse every source.ps1 ONCE ([System.IO] recursive — Get-ChildItem -Recurse carries ~20ms/call provider...
    # [ADR-PWSH-PESTER#9](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester9)
    # [comment:2](/docs/references/automation/catzc-base-modulesystem/Test-FunctionDependency.ps1.md#comment2)
    $parsed = [System.Collections.Generic.List[object]]::new()
    $definitions = @{}
    $issues = [System.Collections.Generic.List[string]]::new()

    foreach ($moduleDir in ([System.IO.Directory]::EnumerateDirectories($AutomationRoot) | Sort-Object)) {
        $module = [System.IO.Path]::GetFileName($moduleDir)
        if ($module -match '^\.') {
            continue
        }

        $files = [System.IO.Directory]::EnumerateFiles($moduleDir, '*.ps1', [System.IO.SearchOption]::AllDirectories) | Sort-Object
        foreach ($path in $files) {
            $name = [System.IO.Path]::GetFileName($path)
            # Match assets/private against the MODULE-RELATIVE path, not the absolute one: an absolute temp/CI path...
            # [comment:3](/docs/references/automation/catzc-base-modulesystem/Test-FunctionDependency.ps1.md#comment3)
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

                # Two PUBLIC (module-root) definitions of one name is a real collision — the module imported last...
                # [comment:4](/docs/references/automation/catzc-base-modulesystem/Test-FunctionDependency.ps1.md#comment4)
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

    # Check each collected call → flag any that resolve to nothing.
    # [comment:5](/docs/references/automation/catzc-base-modulesystem/Test-FunctionDependency.ps1.md#comment5)
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
