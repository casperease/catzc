<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Test-SourceConventions.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: public
---
#>

<#
.SYNOPSIS
    Quality gate: every source and test file under automation/ follows the naming and one-function conventions.
.DESCRIPTION
    Report-mode checks print their work list and never fail the run; only gate-mode findings are issues.
    [ADR-AUTO-ENGINE#1](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine1),
    [ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3),
    [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35),
    [ADR-PWSH-PESTER#5](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester5),
    [ADR-PWSH-PESTER#9](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester9)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/Test-SourceConventions.ps1.md#comment1)
.PARAMETER OutputFolder
    The report base folder. Defaults to out/test-source-conventions/ (Write-QualityGateReport).
.PARAMETER PassThru
    EngineSet and NeutralCodes list each check's findings whatever its mode, so report-mode findings stay visible.
    [comment:2](/docs/references/automation/catzc-base-qualitygates/Test-SourceConventions.ps1.md#comment2)
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
    $repositoryRoot = [System.IO.Path]::GetFullPath((Get-RepositoryRoot))
    $automationRoot = Join-Path $repositoryRoot 'automation'
    $settings = Get-Config -Config source-conventions
    # Every file is parsed once; the source checks below reuse the trees the naming checks parsed.
    $parsed = [System.Collections.Generic.Dictionary[string, System.Management.Automation.Language.Ast]]::new([System.StringComparer]::OrdinalIgnoreCase)
    $parse = {
        param([string] $FullPath)
        $key = [System.IO.Path]::GetFullPath($FullPath)
        if (-not $parsed.ContainsKey($key)) {
            $tokens = $null
            $errors = $null
            $parsed[$key] = [System.Management.Automation.Language.Parser]::ParseFile($key, [ref]$tokens, [ref]$errors)
        }
        $parsed[$key]
    }
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
                $ast = & $parse $path
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

        # Type tests have no verb, so each must name a real type file of its module; misnamed tests cannot collect.
        # [comment:3](/docs/references/automation/catzc-base-qualitygates/Test-SourceConventions.ps1.md#comment3)
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
        $ast = & $parse $testFile
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

    # The source checks read the git-tracked files, less those the content tools leave as written.
    $tracked = @(Get-GitTrackedPath '.')
    $contentExempt = [System.Collections.Generic.HashSet[string]]::new([string[]] @(Get-ContentExemptPath -RepositoryRoot $repositoryRoot -Path $tracked))
    $checked = @($tracked | Where-Object { -not $contentExempt.Contains($_) })

    $engineNames = [string[]] @((Get-ExecutionEngine).Name)
    $engineSet = [System.Collections.Generic.List[string]]::new()
    $engineExtensions = '.md', '.ps1', '.psm1', '.psd1', '.cs', '.yml', '.yaml'
    foreach ($file in $checked) {
        $extension = [Catzc.Base.QualityGates.CommentLexer]::ExtensionOf($file)
        if ($extension -notin $engineExtensions -or $settings.engine_set.IsExempt($file)) {
            continue
        }
        $fullPath = Join-Path $repositoryRoot $file
        if (-not [System.IO.File]::Exists($fullPath)) {
            continue
        }
        $ast = if ([Catzc.Base.QualityGates.CommentLexer]::IsPowerShell($extension)) {
            & $parse $fullPath
        }
        else {
            $null
        }
        $found = Get-EngineSetFinding -Path $file -Text ([System.IO.File]::ReadAllText($fullPath)) -Ast $ast `
            -EngineName $engineNames -Check $settings.engine_set
        $engineSet.AddRange([string[]] @($found))
    }

    $realCodes = [System.Collections.Generic.HashSet[string]]::new([string[]] @((Get-AdrCitationMap -RepositoryRoot $repositoryRoot).Codes))
    $neutralCodes = [System.Collections.Generic.List[string]]::new()
    foreach ($file in $checked) {
        if ($file -notlike '*.Tests.ps1' -or $settings.neutral_codes.IsExempt($file)) {
            continue
        }
        $fullPath = Join-Path $repositoryRoot $file
        if (-not [System.IO.File]::Exists($fullPath)) {
            continue
        }
        $neutralCodes.AddRange([string[]] @(Get-NeutralCodeFinding -Path $file -Ast (& $parse $fullPath) -Code $realCodes))
    }

    # Each check's findings are issues in gate mode and its printed work list in report mode (its config decides).
    $checks = [ordered]@{
        engine_set    = @{ Settings = $settings.engine_set; Findings = $engineSet }
        neutral_codes = @{ Settings = $settings.neutral_codes; Findings = $neutralCodes }
    }
    foreach ($name in $checks.Keys) {
        $check = $checks[$name]
        if ($check.Settings.IsReport) {
            Write-ReportModeFinding -Check $name -Finding $check.Findings.ToArray()
        }
        else {
            $issues.AddRange($check.Findings)
        }
    }

    $facts = [ordered]@{
        SourceFiles      = $sourceCount
        TestFiles        = $testCount
        SkipReasons      = $skipReasonCount
        EngineSetCount   = $engineSet.Count
        NeutralCodeCount = $neutralCodes.Count
    }
    $report = Write-QualityGateReport -Subject 'source-conventions' -Title 'Test-SourceConventions' -Issues $issues `
        -Facts $facts -OutputFolder $OutputFolder -PassThru:$PassThru
    if ($PassThru) {
        $report | Add-Member -NotePropertyName EngineSet -NotePropertyValue $engineSet.ToArray()
        $report | Add-Member -NotePropertyName NeutralCodes -NotePropertyValue $neutralCodes.ToArray()
        $report
    }
}
