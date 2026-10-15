<#
.SYNOPSIS
    Moves the comment-based help of a function file into the `config` part of its meta head and removes the help block.
.DESCRIPTION
    The text of each section is carried over as written, as a plain, quoted or block string, so no prose is rewritten (ADR-REPO-HELP#1).
.PARAMETER Text
    The text of one function file, with its comments in place.
.PARAMETER Form
    The head's comment syntax: a Catzc.Base.CodeMeta.HeadForm.
.OUTPUTS
    [pscustomobject] @{ Text; Problems } — the file text without the help block, and what only a person can settle. A file with no help
    block, or with no head to hold the keys, comes back as it was.
#>
function ConvertTo-HelpHeadConfig {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $Text,

        [Parameter(Mandatory)]
        [Catzc.Base.CodeMeta.HeadForm] $Form
    )

    $crlf = $Text.Contains("`r`n")
    $source = $Text.Replace("`r`n", "`n")
    $unchanged = [pscustomobject]@{ Text = $Text; Problems = [string[]] @() }

    $tokens = $null
    $errors = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseInput($source, [ref] $tokens, [ref] $errors)
    $function = $ast.Find({ param($node) $node -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $false)
    if ($errors.Count -gt 0 -or $null -eq $function) {
        return $unchanged
    }
    $helpToken = $tokens | Where-Object {
        $_.Kind -eq [System.Management.Automation.Language.TokenKind]::Comment -and
        $_.Text.StartsWith('<#', [System.StringComparison]::Ordinal) -and
        $_.Text -cmatch '^<#\n(?:.*\n)*?\.(SYNOPSIS|DESCRIPTION)\b' -and
        $_.Extent.EndOffset -le $function.Extent.StartOffset
    } | Select-Object -Last 1
    if ($null -eq $helpToken) {
        return $unchanged
    }

    $state = Get-CodeMetaState -Text $source -Form $Form
    if (-not $state.HasHead) {
        return [pscustomobject]@{ Text = $Text; Problems = [string[]] @('the file has no meta head to hold the help keys') }
    }

    $problems = [System.Collections.Generic.List[string]]::new()
    $sections = (Get-FunctionHelpSection -HelpText $helpToken.Text).Section

    # The body of a section: edge blank lines dropped, the common indent removed, trailing blanks trimmed.
    $body = {
        param($Section)
        $lines = [System.Collections.Generic.List[string]]::new()
        foreach ($line in $Section.Lines) {
            $lines.Add($line.TrimEnd())
        }
        while ($lines.Count -gt 0 -and $lines[0].Length -eq 0) {
            $lines.RemoveAt(0)
        }
        while ($lines.Count -gt 0 -and $lines[$lines.Count - 1].Length -eq 0) {
            $lines.RemoveAt($lines.Count - 1)
        }
        $indent = ($lines | Where-Object { $_.Length -gt 0 } | ForEach-Object { $_.Length - $_.TrimStart().Length } | Measure-Object -Minimum).Minimum
        if ($null -eq $indent) {
            $indent = 0
        }
        , [string[]] @($lines | ForEach-Object { if ($_.Length -ge $indent) { $_.Substring($indent) } else { $_ } })
    }

    # One value as YAML lines: a single line plain or single-quoted, several lines a literal block.
    $emit = {
        param([string] $Key, [string[]] $Lines, [int] $Indent, [string] $Prefix)
        $pad = ' ' * $Indent
        $lead = "$pad$Prefix"
        if ($Key) {
            $lead += "${Key}: "
        }
        if ($Lines.Count -eq 0) {
            "$lead''"
            return
        }
        if ($Lines.Count -eq 1) {
            $value = $Lines[0]
            $plain = $value -cmatch '^[A-Za-z0-9(][^\r\n]*$' -and $value -cnotmatch ': |\s#|:$' -and $value -cnotmatch '^(?i:true|false|null|yes|no|on|off|y|n)$' -and $value -cnotmatch '^[0-9.+\-eE_]+$'
            if (-not $plain) {
                $value = "'" + $value.Replace("'", "''") + "'"
            }
            "$lead$value"
            return
        }
        "$lead|-"
        foreach ($line in $Lines) {
            if ($line.Length -eq 0) {
                ''
            }
            else {
                "$pad  $line"
            }
        }
    }

    $single = [ordered]@{ '.SYNOPSIS' = 'synopsis'; '.DESCRIPTION' = 'description'; '.INPUTS' = 'inputs'; '.OUTPUTS' = 'outputs'; '.NOTES' = 'notes' }
    $config = [System.Collections.Generic.List[string]]::new()
    foreach ($line in $state.ConfigLines) {
        $config.Add($line)
    }
    if (@($config | Where-Object { $_ -cmatch '^    (synopsis|description|parameters|inputs|outputs|examples|notes):' }).Count -gt 0) {
        return [pscustomobject]@{ Text = $Text; Problems = [string[]] @('the head already holds help keys, so the help block is a second copy') }
    }

    foreach ($keyword in '.SYNOPSIS', '.DESCRIPTION') {
        $found = @($sections | Where-Object { $_.Name -ceq $keyword })
        if ($found.Count -gt 0) {
            foreach ($line in @(& $emit $single[$keyword] (& $body $found[0]) 4 '')) {
                $config.Add($line)
            }
        }
    }
    $parameterSections = @($sections | Where-Object { $_.Name -ceq '.PARAMETER' })
    if ($parameterSections.Count -gt 0) {
        $config.Add('    parameters:')
        foreach ($section in $parameterSections) {
            foreach ($line in @(& $emit $section.Arg (& $body $section) 6 '')) {
                $config.Add($line)
            }
        }
    }
    foreach ($keyword in '.INPUTS', '.OUTPUTS') {
        $found = @($sections | Where-Object { $_.Name -ceq $keyword })
        if ($found.Count -gt 0) {
            $merged = [System.Collections.Generic.List[string]]::new()
            foreach ($section in $found) {
                if ($merged.Count -gt 0) {
                    $merged.Add('')
                }
                $merged.AddRange([string[]] (& $body $section))
            }
            foreach ($line in @(& $emit $single[$keyword] ([string[]] $merged.ToArray()) 4 '')) {
                $config.Add($line)
            }
        }
    }
    $exampleSections = @($sections | Where-Object { $_.Name -ceq '.EXAMPLE' })
    if ($exampleSections.Count -gt 0) {
        $config.Add('    examples:')
        foreach ($section in $exampleSections) {
            foreach ($line in @(& $emit '' (& $body $section) 6 '- ')) {
                $config.Add($line)
            }
        }
    }
    $found = @($sections | Where-Object { $_.Name -ceq '.NOTES' })
    if ($found.Count -gt 0) {
        foreach ($line in @(& $emit 'notes' (& $body $found[0]) 4 '')) {
            $config.Add($line)
        }
    }
    foreach ($section in @($sections | Where-Object { $_.Name -cnotin $single.Keys -and $_.Name -cne '.PARAMETER' -and $_.Name -cne '.EXAMPLE' })) {
        $problems.Add("the help section $($section.Name) has no head key")
    }

    $paramNames = @()
    if ($null -ne $function.Body.ParamBlock) {
        $paramNames = @($function.Body.ParamBlock.Parameters | ForEach-Object { $_.Name.VariablePath.UserPath })
    }
    foreach ($name in @($parameterSections | ForEach-Object Arg)) {
        if ($name -notin $paramNames) {
            $problems.Add("the parameter $name is documented but the function declares no such parameter")
        }
    }
    foreach ($name in $paramNames) {
        if ($name -notin @($parameterSections | ForEach-Object Arg)) {
            $problems.Add("the parameter $name is declared but has no documentation")
        }
    }

    $extent = $helpToken.Extent
    $end = $extent.EndOffset
    if ($end -lt $source.Length -and $source[$end] -eq "`n") {
        $end++
    }
    $without = $source.Remove($extent.StartOffset, $end - $extent.StartOffset)
    $result = Set-CodeMetaConfig -Text $without -Form $Form -Config ([string[]] $config.ToArray())
    if ($crlf) {
        $result = $result.Replace("`n", "`r`n")
    }
    [pscustomobject]@{ Text = $result; Problems = [string[]] $problems.ToArray() }
}
