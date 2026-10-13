<#
.SYNOPSIS
    Quality gate: every source and test file under automation/ follows the naming and one-function conventions.
.DESCRIPTION
    A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over the per-function
    source files and the test files. It enumerates the tree once with [System.IO]
    ([ADR-AUTO-TEST#18](/docs/adr/automation/test-automation.md#rule-adr-auto-test18)), parses each source file once, and
    collects every issue:

      - every source file (a module-root .ps1, or a private/*.ps1 not starting with '_') is named Verb-Noun, holds
        exactly one top-level function, and that function is named for the file;
      - every function name (public and private) is defined in exactly one file;
      - every test file directly under a tests/ folder is named Verb-Noun.Tests.ps1
        ([ADR-AUTO-PESTER#5](/docs/adr/automation/powershell/pester-testing.md#rule-adr-auto-pester5));
      - every test file under tests/types/ is named for a C# type (a types/*.cs) of its module;
      - every literal Set-ItResult -Because reason is a constrained skip key (lowercase alnum segments joined by
        '_', e.g. windows_only_<detail> or tool_<name>_missing), never prose, so the skip report groups by a stable
        vocabulary. A computed reason cannot be checked statically and is left out.

    Dot-prefixed folders hold no source files; their tests/ folders are scanned (except .vendor and
    .scriptanalyzer). It reads the per-function source files, which exist only in the source tree (Assert-SourceTree).
.PARAMETER OutputFolder
    The report base folder. Defaults to out/test-source-conventions/ (Write-QualityGateReport).
.PARAMETER PassThru
    Return the result ({ Subject; IssueCount; Issues; ReportPath; SourceFiles; TestFiles; SkipReasons }) instead of
    throwing on issues.
.OUTPUTS
    [pscustomobject] With -PassThru only.
.EXAMPLE
    Test-SourceConventions
#>
function Test-SourceConventions {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree
    $automationRoot = Join-Path (Get-RepositoryRoot) 'automation'
    $isFunctionAst = { param($node) $node -is [System.Management.Automation.Language.FunctionDefinitionAst] }
    $isSetItResult = {
        param($node)
        $node -is [System.Management.Automation.Language.CommandAst] -and $node.GetCommandName() -eq 'Set-ItResult'
    }
    $skipKey = '^[a-z][a-z0-9]*(_[a-z0-9]+)+$'

    $issues = [System.Collections.Generic.List[string]]::new()
    $definitions = @{}
    $sourceCount = 0
    $testCount = 0
    $skipReasonCount = 0

    foreach ($moduleDirectory in ([System.IO.Directory]::EnumerateDirectories($automationRoot) | Sort-Object)) {
        $module = [System.IO.Path]::GetFileName($moduleDirectory)

        if ($module -notmatch '^\.') {
            $paths = [System.Collections.Generic.List[string]]::new()
            foreach ($path in ([System.IO.Directory]::EnumerateFiles($moduleDirectory, '*.ps1') | Sort-Object)) {
                if ($path -notlike '*.Tests.ps1') {
                    $paths.Add($path)
                }
            }
            $privateDirectory = Join-Path $moduleDirectory 'private'
            if ([System.IO.Directory]::Exists($privateDirectory)) {
                foreach ($path in ([System.IO.Directory]::EnumerateFiles($privateDirectory, '*.ps1') | Sort-Object)) {
                    if ([System.IO.Path]::GetFileName($path) -notlike '_*') {
                        $paths.Add($path)
                    }
                }
            }

            foreach ($path in $paths) {
                $sourceCount++
                $relative = "$module/" + ($path.Substring($moduleDirectory.Length + 1) -replace '\\', '/')
                $baseName = [System.IO.Path]::GetFileNameWithoutExtension($path)
                $tokens = $null; $errors = $null
                $ast = [System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$tokens, [ref]$errors)
                $functions = @($ast.FindAll($isFunctionAst, $false) | Where-Object { $_.Parent.Parent -eq $ast })

                if ($baseName -notmatch '-') {
                    $issues.Add("${relative}: the source file is not named Verb-Noun")
                }
                if ($functions.Count -ne 1) {
                    $issues.Add("${relative}: holds $($functions.Count) top-level functions, not exactly one")
                }
                elseif ($functions[0].Name -ne $baseName) {
                    $issues.Add("${relative}: defines '$($functions[0].Name)', not a function named for the file")
                }
                foreach ($function in $functions) {
                    if (-not $definitions.ContainsKey($function.Name)) {
                        $definitions[$function.Name] = [System.Collections.Generic.List[string]]::new()
                    }
                    $definitions[$function.Name].Add($relative)
                }
            }
        }

        if ($module -in '.vendor', '.scriptanalyzer') {
            continue
        }
        $testsDirectory = Join-Path $moduleDirectory 'tests'
        if (-not [System.IO.Directory]::Exists($testsDirectory)) {
            continue
        }
        foreach ($path in ([System.IO.Directory]::EnumerateFiles($testsDirectory, '*.Tests.ps1') | Sort-Object)) {
            $testCount++
            $name = [System.IO.Path]::GetFileName($path)
            if (($name -replace '\.Tests\.ps1$') -notmatch '-') {
                $issues.Add("$module/tests/${name}: the test file is not named Verb-Noun.Tests.ps1")
            }
        }

        # tests/types/ holds the native-type tests, named for their type (which has no verb) — so each must name a
        # real types/*.cs of the module, and the folder cannot collect misplaced or misnamed tests.
        $typesTestDirectory = Join-Path $testsDirectory 'types'
        if ([System.IO.Directory]::Exists($typesTestDirectory)) {
            foreach ($path in ([System.IO.Directory]::EnumerateFiles($typesTestDirectory, '*.Tests.ps1') | Sort-Object)) {
                $testCount++
                $name = [System.IO.Path]::GetFileName($path)
                $typeFile = Join-Path $moduleDirectory "types/$($name -replace '\.Tests\.ps1$').cs"
                if (-not [System.IO.File]::Exists($typeFile)) {
                    $issues.Add("$module/tests/types/${name}: names no C# type (types/*.cs) of the module")
                }
            }
        }
    }

    foreach ($name in ($definitions.Keys | Sort-Object)) {
        if ($definitions[$name].Count -gt 1) {
            $issues.Add("${name}: defined in more than one file ($($definitions[$name] -join ', '))")
        }
    }

    $allTestFiles = [System.IO.Directory]::EnumerateFiles($automationRoot, '*.Tests.ps1', [System.IO.SearchOption]::AllDirectories) |
        Where-Object { $_ -notmatch '[\\/]\.vendor[\\/]' } |
        Sort-Object
    foreach ($testFile in $allTestFiles) {
        $relative = $testFile.Substring($automationRoot.Length + 1) -replace '\\', '/'
        $tokens = $null; $errors = $null
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($testFile, [ref]$tokens, [ref]$errors)
        foreach ($call in $ast.FindAll($isSetItResult, $true)) {
            $elements = $call.CommandElements
            for ($i = 1; $i -lt $elements.Count; $i++) {
                $element = $elements[$i]
                if ($element -isnot [System.Management.Automation.Language.CommandParameterAst] -or $element.ParameterName -ine 'Because') {
                    continue
                }
                $argument = $element.Argument
                if (-not $argument -and $i + 1 -lt $elements.Count) {
                    $argument = $elements[$i + 1]
                }
                if ($argument -is [System.Management.Automation.Language.StringConstantExpressionAst]) {
                    $skipReasonCount++
                    if ($argument.Value -cnotmatch $skipKey) {
                        $issues.Add("${relative}: Set-ItResult -Because '$($argument.Value)' is not a constrained skip key")
                    }
                }
                break
            }
        }
    }

    Write-QualityGateReport -Subject 'source-conventions' -Title 'Test-SourceConventions' -Issues $issues `
        -Facts ([ordered]@{ SourceFiles = $sourceCount; TestFiles = $testCount; SkipReasons = $skipReasonCount }) `
        -OutputFolder $OutputFolder -PassThru:$PassThru
}
