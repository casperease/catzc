<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-NeutralCodeFinding.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
---
#>

<#
.SYNOPSIS
    Lists every real ADR code one test file uses as fixture data inside an L0 block.
.DESCRIPTION
    Tag values, block titles and comments never count, since they are citations or names, not fixture data.
    [ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-NeutralCodeFinding.ps1.md#comment1)
.PARAMETER Path
    The test file's repository-relative, '/'-separated path, which leads each finding.
.PARAMETER Ast
    The test file's syntax tree (parsed once by the caller).
.PARAMETER Code
    The real ADR codes, from the ADR registry (Get-AdrCitationMap).
.OUTPUTS
    [string[]] One '<path>:<line>: <message>' per real code used, in line order.
#>
function Get-NeutralCodeFinding {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [System.Management.Automation.Language.Ast] $Ast,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [System.Collections.Generic.HashSet[string]] $Code
    )

    $tiers = [Catzc.Base.Timeouts.TestTiers]::Names
    $codePattern = [regex]::new('(?<![\w-])ADR-[A-Z]+(?:-[A-Z]+)*')
    $isBlockCommand = {
        param($node)
        $node -is [System.Management.Automation.Language.CommandAst] -and $node.GetCommandName() -in 'Describe', 'Context', 'It'
    }
    $isString = {
        param($node)
        $node -is [System.Management.Automation.Language.StringConstantExpressionAst] -or
        $node -is [System.Management.Automation.Language.ExpandableStringExpressionAst]
    }

    # The block parameters that take a value; every other parameter of Describe, Context, and It is a switch.
    $valued = 'Name', 'Tag', 'Tags', 'Fixture', 'Test', 'ForEach', 'TestCases'

    # Each tier-tagged block's extent and tier, and the extent of every -Tag argument and every block title.
    $blocks = [System.Collections.Generic.List[object]]::new()
    $skipRanges = [System.Collections.Generic.List[object]]::new()
    foreach ($command in $Ast.FindAll($isBlockCommand, $true)) {
        $elements = $command.CommandElements
        $tier = $null
        $titled = $false
        for ($index = 1; $index -lt $elements.Count; $index++) {
            $element = $elements[$index]
            $parameter = if ($element -is [System.Management.Automation.Language.CommandParameterAst]) {
                $element.ParameterName
            }
            else {
                $null
            }
            # A value belongs to the parameter before it (-Tag 'x', or -Tag:'x'), or is positional: the first is the title.
            $value = $element
            if ($parameter) {
                if ($parameter -notin $valued) {
                    continue
                }
                if ($element.Argument) {
                    $value = $element.Argument
                }
                elseif ($index -lt $elements.Count - 1) {
                    $index++
                    $value = $elements[$index]
                }
                else {
                    continue
                }
            }
            # A script block is the block's body, never its title, even where the title is missing.
            $isBody = $value -is [System.Management.Automation.Language.ScriptBlockExpressionAst]
            $isTitle = -not $isBody -and ($parameter -eq 'Name' -or (-not $parameter -and -not $titled))
            if ($isTitle) {
                $titled = $true
                $skipRanges.Add([pscustomobject]@{ Start = $value.Extent.StartOffset; End = $value.Extent.EndOffset })
            }
            if ($parameter -notin 'Tag', 'Tags') {
                continue
            }
            $skipRanges.Add([pscustomobject]@{ Start = $value.Extent.StartOffset; End = $value.Extent.EndOffset })
            foreach ($tag in $value.FindAll($isString, $true)) {
                foreach ($name in $tiers) {
                    if ($tag.Value -eq $name) {
                        $tier = $name
                    }
                }
            }
        }
        if ($tier) {
            $blocks.Add([pscustomobject]@{ Start = $command.Extent.StartOffset; End = $command.Extent.EndOffset; Tier = $tier })
        }
    }
    $fileTiers = @(foreach ($block in $blocks) {
            $block.Tier
        }) | Select-Object -Unique
    $fileTiers = @($fileTiers)
    $fileTier = if ($fileTiers.Count -eq 1) {
        $fileTiers[0]
    }
    else {
        $null
    }

    $findings = [System.Collections.Generic.List[object]]::new()
    foreach ($literal in $Ast.FindAll($isString, $true)) {
        $text = $literal.Extent.Text
        if (-not $text.Contains('ADR-')) {
            continue
        }
        # A string inside another (a subexpression in an expandable string) is read with its outer string.
        $outer = $false
        for ($parent = $literal.Parent; $parent; $parent = $parent.Parent) {
            if (& $isString $parent) {
                $outer = $true
                break
            }
        }
        $offset = $literal.Extent.StartOffset
        if ($outer -or @($skipRanges | Where-Object { $offset -ge $_.Start -and $offset -lt $_.End }).Count) {
            continue
        }
        $enclosing = $blocks | Where-Object { $offset -ge $_.Start -and $offset -lt $_.End } |
            Sort-Object { $_.End - $_.Start } | Select-Object -First 1
        $tier = if ($enclosing) {
            $enclosing.Tier
        }
        else {
            $fileTier
        }
        if ($tier -ne 'L0') {
            continue
        }
        foreach ($match in $codePattern.Matches($text)) {
            if (-not $Code.Contains($match.Value)) {
                continue
            }
            $line = $literal.Extent.StartLineNumber + ([regex]::Matches($text.Substring(0, $match.Index), "`n")).Count
            $findings.Add([pscustomobject]@{
                    Line    = $line
                    Message = "L0 fixture data uses the real ADR code '$($match.Value)'; use a neutral code (ADR-WIDGET-GADGET), or move the real one into a -Tag"
                })
        }
    }

    [string[]] @(foreach ($finding in ($findings | Sort-Object Line)) {
            "${Path}:$($finding.Line): $($finding.Message)"
        })
}
