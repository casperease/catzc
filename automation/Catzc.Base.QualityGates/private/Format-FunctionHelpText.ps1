# catzc:
#   path: automation/Catzc.Base.QualityGates/private/Format-FunctionHelpText.ps1
#   module: Catzc.Base.QualityGates
#   visibility: private

<#
.SYNOPSIS
    Writes the normal form of a function file's help block and reports what only a person can settle.
.DESCRIPTION
    Sections move and citations are ordered, but no prose is written: text a person authored is left as it is.,,,
    [ADR-REPO-HELP#1](/docs/adr/repository/function-help.md#rule-adr-repo-help1),
    [ADR-REPO-HELP#2](/docs/adr/repository/function-help.md#rule-adr-repo-help2),
    [ADR-REPO-HELP#3](/docs/adr/repository/function-help.md#rule-adr-repo-help3),
    [ADR-REPO-HELP#4](/docs/adr/repository/function-help.md#rule-adr-repo-help4)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Format-FunctionHelpText.ps1.md#comment1)
.PARAMETER Text
    The text of one function file.
.OUTPUTS
    [pscustomobject] @{ Text; Problems } — the file text in normal form, and the problems a person must settle.
#>
function Format-FunctionHelpText {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $Text
    )

    $crlf = $Text.Contains("`r`n")
    $source = $Text.Replace("`r`n", "`n")
    $unchanged = [pscustomobject]@{ Text = $Text; Problems = [string[]] @() }
    $parse = {
        param([string] $Content)
        $tokens = $null
        $errors = $null
        $ast = [System.Management.Automation.Language.Parser]::ParseInput($Content, [ref] $tokens, [ref] $errors)
        $function = $ast.Find({ param($node) $node -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $false)
        $helpToken = $null
        if ($null -ne $function) {
            $helpToken = $tokens | Where-Object {
                $_.Kind -eq [System.Management.Automation.Language.TokenKind]::Comment -and
                $_.Text.StartsWith('<#', [System.StringComparison]::Ordinal) -and
                $_.Text.Contains("`n") -and
                $_.Extent.EndOffset -le $function.Extent.StartOffset
            } | Select-Object -Last 1
        }
        [pscustomobject]@{ Function = $function; Help = $helpToken; Tokens = $tokens; Errors = $errors }
    }

    $first = & $parse $source
    if ($first.Errors.Count -gt 0 -or $null -eq $first.Function -or $null -eq $first.Help -or $first.Help.Text -cnotmatch '^<#\n(?:.*\n)*?\.(SYNOPSIS|DESCRIPTION)\b') {
        return $unchanged
    }

    # Inline comments above parameters: an equal one is dropped, one with no section becomes the section, a differing one is a problem.
    $problems = [System.Collections.Generic.List[string]]::new()
    $added = [System.Collections.Generic.List[object]]::new()
    $current = $source
    $paramBlock = $first.Function.Body.ParamBlock
    if ($null -ne $paramBlock) {
        $existing = Get-FunctionHelpSection -HelpText $first.Help.Text
        $removals = [System.Collections.Generic.List[object]]::new()
        foreach ($inline in @(Get-InlineParameterComment -Text $source -ParamBlock $paramBlock -Token $first.Tokens)) {
            $section = $existing.Section | Where-Object { $_.Name -ceq '.PARAMETER' -and $_.Arg -ieq $inline.Name } | Select-Object -First 1
            $normalise = { param([string] $Value) ([regex]::Replace($Value.Trim(), '\s+', ' ')).TrimEnd('.') }
            if ($inline.Text -match '\[comment:\d+\]') {
                $problems.Add("parameter $($inline.Name): the inline comment carries the link of a moved comment — settle it by hand")
            }
            elseif ($null -eq $section) {
                $added.Add([pscustomobject]@{ Name = '.PARAMETER'; Arg = $inline.Name; Lines = [System.Collections.Generic.List[string]]::new([string[]] @('    ' + $inline.Text)) })
                $removals.Add($inline)
            }
            elseif ((& $normalise ($section.Lines -join ' ')) -ceq (& $normalise $inline.Text)) {
                $removals.Add($inline)
            }
            else {
                $problems.Add("parameter $($inline.Name): the inline comment and the .PARAMETER section differ — settle it by hand")
            }
        }
        foreach ($removal in @($removals | Sort-Object -Property Start -Descending)) {
            $current = $current.Remove($removal.Start, $removal.End - $removal.Start)
        }
    }

    $second = & $parse $current
    $parsed = Get-FunctionHelpSection -HelpText $second.Help.Text
    $sections = [System.Collections.Generic.List[object]]::new()
    foreach ($section in $parsed.Section) {
        $sections.Add($section)
    }
    foreach ($section in $added) {
        $sections.Add($section)
    }
    # Move-FunctionHelpCitation returns its problems as one array: assign it, so foreach walks the problems, not the array.
    $citationProblems = Move-FunctionHelpCitation -Section $sections.ToArray()
    foreach ($problem in $citationProblems) {
        $problems.Add($problem)
    }

    $parameterNames = @()
    if ($null -ne $second.Function.Body.ParamBlock) {
        $parameterNames = @($second.Function.Body.ParamBlock.Parameters | ForEach-Object { $_.Name.VariablePath.UserPath })
    }
    $rank = @{ '.SYNOPSIS' = 0; '.DESCRIPTION' = 1; '.PARAMETER' = 2; '.INPUTS' = 3; '.OUTPUTS' = 4; '.EXAMPLE' = 5; '.NOTES' = 6 }
    $indexed = for ($index = 0; $index -lt $sections.Count; $index++) {
        $section = $sections[$index]
        $position = -1
        for ($slot = 0; $slot -lt $parameterNames.Count; $slot++) {
            if ($parameterNames[$slot] -ieq $section.Arg) {
                $position = $slot
                break
            }
        }
        $rankValue = 7
        if ($rank.ContainsKey($section.Name)) {
            $rankValue = $rank[$section.Name]
        }
        $positionValue = 0
        if ($section.Name -ceq '.PARAMETER') {
            $positionValue = 1000 + $index
            if ($position -ge 0) {
                $positionValue = $position
            }
        }
        [pscustomobject]@{ Section = $section; Rank = $rankValue; Position = $positionValue; Index = $index }
    }
    $ordered = @($indexed | Sort-Object -Property Rank, Position, Index)

    foreach ($name in @($sections | Where-Object { $_.Name -ceq '.PARAMETER' } | ForEach-Object Arg)) {
        if ($name -notin $parameterNames) {
            $problems.Add("the .PARAMETER section $name names no parameter of the function")
        }
    }
    $described = @($sections | Where-Object { $_.Name -ceq '.PARAMETER' } | ForEach-Object Arg)
    foreach ($name in $parameterNames) {
        if ($name -notin $described) {
            $problems.Add("parameter $name has no .PARAMETER section")
        }
    }
    $outputs = $sections | Where-Object { $_.Name -ceq '.OUTPUTS' } | Select-Object -First 1
    $outputType = $null
    if ($null -ne $second.Function.Body.ParamBlock) {
        $outputType = $second.Function.Body.ParamBlock.Attributes | Where-Object { $_.TypeName.Name -ceq 'OutputType' } | Select-Object -First 1
    }
    if ($null -ne $outputs -and $null -ne $outputType) {
        $documented = [regex]::Match(($outputs.Lines -join "`n"), '\[([A-Za-z0-9_.]+(?:\[\])*)\]')
        $declared = $outputType.PositionalArguments | Select-Object -First 1
        if ($documented.Success -and $null -ne $declared) {
            $short = { param([string] $Value) ($Value.Trim().Trim('[', ']', "'", '"') -split '\.' | Select-Object -Last 1).ToLowerInvariant() }
            if ((& $short $documented.Groups[1].Value) -ne (& $short $declared.Extent.Text)) {
                $problems.Add(".OUTPUTS documents [$($documented.Groups[1].Value)] but [OutputType] declares $($declared.Extent.Text)")
            }
        }
    }

    $lines = [System.Collections.Generic.List[string]]::new()
    foreach ($line in $parsed.Preamble) {
        $lines.Add($line)
    }
    foreach ($entry in $ordered) {
        $heading = if ($entry.Section.Arg) {
            "$($entry.Section.Name) $($entry.Section.Arg)"
        }
        else {
            $entry.Section.Name
        }
        $lines.Add($heading)
        foreach ($line in $entry.Section.Lines) {
            $lines.Add($line)
        }
    }
    $rendered = '<#' + "`n" + ($lines -join "`n") + "`n" + '#>'
    $result = $current.Remove($second.Help.Extent.StartOffset, $second.Help.Extent.EndOffset - $second.Help.Extent.StartOffset).Insert($second.Help.Extent.StartOffset, $rendered)
    if ($crlf) {
        $result = $result.Replace("`n", "`r`n")
    }
    [pscustomobject]@{ Text = $result; Problems = [string[]] $problems.ToArray() }
}
