<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/private/Get-UncoveredInternalAssetDependency.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: private
    relatives:
      test: automation/Catzc.Base.ModuleSystem/tests/Get-UncoveredInternalAssetDependency.Tests.ps1
    adrs:
      - ADR-AUTO-ASSETDEP#{3,4}
      - ADR-AUTO-TEST#13
      - ADR-PWSH-PESTER#5
  config:
    synopsis: |-
      Lists the functions with an internal asset dependency that no qualifying test covers — the coverage quality gate's
      engine.
    description: |-
      Takes the inventory (Get-InternalAssetDependency) and, for every function in it, looks for a test that
      satisfies [ADR-AUTO-ASSETDEP#3](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep3). The
      function's test files are the ones in its own module's tests/ folder
      named for it: <Function>.Tests.ps1, or <Function>.<suffix>.Tests.ps1 for a cross-cutting test file
      ([ADR-PWSH-PESTER#5](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester5)). Each file is parsed,
      never run: every It block's tags are the union of its own -Tag
      values and those of each enclosing Describe and Context (the block chain,
      [ADR-AUTO-TEST#13](/docs/adr/automation/test-automation.md#rule-adr-auto-test13)/27). A test
      qualifies when its chain carries the citation 'ADR-AUTO-ASSETDEP#3' and does not carry 'source-only' —
      so it runs in both the source run and the build run.

      Returns one record per uncovered function: { Module; Function; ChildPath; TestFile; Reason }, where Module
      is the module that defines the function, ChildPath the child paths its calls read (sorted, unique; '.'
      for a call that names the module folder itself), and
      TestFile the repository-relative test files that were inspected (empty when none exists). Returns nothing
      when every function is covered.
    parameters:
      AutomationRoot: Path to the automation directory. Defaults to <RepositoryRoot>/automation.
      Dependency: The inventory to check. Defaults to Get-InternalAssetDependency over -AutomationRoot.
    outputs: '[pscustomobject] One record per uncovered function.'
---
#>

function Get-UncoveredInternalAssetDependency {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $AutomationRoot = (Join-Path (Get-RepositoryRoot) 'automation'),

        [object[]] $Dependency
    )

    if (-not $PSBoundParameters.ContainsKey('Dependency')) {
        $Dependency = @(Get-InternalAssetDependency -AutomationRoot $AutomationRoot)
    }

    $citation = 'ADR-AUTO-ASSETDEP#3'
    $blockNames = @('Describe', 'Context', 'It')

    # The literal tag values of one Pester block command (-Tag / -Tags, space or colon form).
    $getBlockTags = {
        param($command)
        $elements = $command.CommandElements
        for ($i = 1; $i -lt $elements.Count; $i++) {
            $element = $elements[$i]
            if ($element -isnot [System.Management.Automation.Language.CommandParameterAst] -or
                $element.ParameterName -notin 'Tag', 'Tags') {
                continue
            }
            $value = $element.Argument
            if (-not $value -and ($i + 1) -lt $elements.Count) {
                $value = $elements[$i + 1]
            }
            if ($value) {
                foreach ($constant in $value.FindAll({ param($node) $node -is [System.Management.Automation.Language.StringConstantExpressionAst] }, $true)) {
                    $constant.Value
                }
            }
        }
    }

    # Whether any It block in the file resolves, through its block chain, to the citation without 'source-only'.
    $testFileQualifies = {
        param([string] $Path)
        $tokens = $null
        $parseErrors = $null
        $syntaxTree = [System.Management.Automation.Language.Parser]::ParseFile($Path, [ref] $tokens, [ref] $parseErrors)
        $isItBlock = {
            param($node)
            $node -is [System.Management.Automation.Language.CommandAst] -and $node.GetCommandName() -ieq 'It'
        }
        foreach ($itBlock in $syntaxTree.FindAll($isItBlock, $true)) {
            $chainTags = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
            $node = $itBlock
            while ($node) {
                if ($node -is [System.Management.Automation.Language.CommandAst] -and $node.GetCommandName() -in $blockNames) {
                    foreach ($tag in @(& $getBlockTags $node)) {
                        [void] $chainTags.Add($tag)
                    }
                }
                $node = $node.Parent
            }
            if ($chainTags.Contains($citation) -and -not $chainTags.Contains('source-only')) {
                return $true
            }
        }
        $false
    }

    # The defining module is the folder the calling file sits in (File = automation/<Module>/...).
    $byFunction = $Dependency | Group-Object { "$(($_.File -split '/')[1])|$($_.Function)" }

    $ret = foreach ($group in ($byFunction | Sort-Object Name)) {
        $definingModule, $functionName = $group.Name -split '\|', 2
        $testsDirectory = Join-Path $AutomationRoot "$definingModule/tests"
        $pattern = '^' + [regex]::Escape($functionName) + '(\.[^.]+)?\.Tests\.ps1$'
        $testFiles = @(
            if ([System.IO.Directory]::Exists($testsDirectory)) {
                [System.IO.Directory]::EnumerateFiles($testsDirectory, '*.Tests.ps1') |
                    Where-Object { [System.IO.Path]::GetFileName($_) -match $pattern } |
                    Sort-Object
            }
        )

        $covered = $false
        foreach ($testFile in $testFiles) {
            if (& $testFileQualifies $testFile) {
                $covered = $true
                break
            }
        }
        if ($covered) {
            continue
        }

        # '.' stands for a call that names the module folder itself (no child path).
        $readPaths = foreach ($record in $group.Group) {
            if ($record.ChildPath) {
                $record.ChildPath
            }
            else {
                '.'
            }
        }
        $childPaths = [string[]] @($readPaths | Sort-Object -Unique)
        $reason = if ($testFiles.Count -eq 0) {
            "no test file named $functionName.Tests.ps1 (or $functionName.<suffix>.Tests.ps1) in automation/$definingModule/tests"
        }
        else {
            "no It block tagged '$citation' without 'source-only'"
        }
        [pscustomobject]@{
            Module    = $definingModule
            Function  = $functionName
            ChildPath = $childPaths
            TestFile  = [string[]] @($testFiles | ForEach-Object { "automation/$definingModule/tests/$([System.IO.Path]::GetFileName($_))" })
            Reason    = $reason
        }
    }

    @($ret)
}
