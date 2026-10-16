<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Get-HelpHeadFinding.ps1
    folder: private
    name: get-help-head-finding
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.QualityGates/tests/Get-HelpHeadFinding.Tests.ps1
    cites:
      - ADR-REPO-HELP#4
  config:
    synopsis: Lists what is wrong with the help a PowerShell file keeps in the config part of its meta head.
    description: 'The help is data, so nothing is rewritten: every finding is for a person to settle (ADR-REPO-HELP#4).'
    parameters:
      Text: The text of one PowerShell function file or script.
      Form: 'The head''s comment syntax: a Catzc.Base.CodeMeta.HeadForm.'
    outputs: '[string[]] One message per finding; empty when the help is in order.'
---
#>

function Get-HelpHeadFinding {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $Text,

        [Parameter(Mandatory)]
        [Catzc.Base.CodeMeta.HeadForm] $Form
    )

    $source = $Text.Replace("`r`n", "`n")
    $findings = [System.Collections.Generic.List[string]]::new()
    $tokens = $null
    $errors = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseInput($source, [ref] $tokens, [ref] $errors)
    if ($errors.Count -gt 0) {
        return [string[]] @()
    }

    $legacy = @($tokens | Where-Object {
            $_.Kind -eq [System.Management.Automation.Language.TokenKind]::Comment -and
            $_.Text.StartsWith('<#', [System.StringComparison]::Ordinal) -and
            $_.Text -cmatch '(?m)^\.(SYNOPSIS|DESCRIPTION|PARAMETER|INPUTS|OUTPUTS|EXAMPLE|NOTES)\b'
        })
    if ($legacy.Count -gt 0) {
        $findings.Add('comment-based help is not used: write the synopsis, description, parameters, outputs and examples as keys of the head''s config')
    }

    $state = Get-CodeMetaState -Text $source -Form $Form
    if (-not $state.HasHead) {
        return [string[]] $findings.ToArray()
    }
    $yaml = (@($state.ConfigLines | ForEach-Object { if ($_.Length -ge 4) {
                    $_.Substring(4)
                }
                else {
                    $_
                } }) -join "`n")
    $config = if ($yaml.Trim().Length -gt 0) {
        ConvertFrom-Yaml -Yaml $yaml -Ordered
    }
    else {
        [ordered]@{}
    }
    if ($config -isnot [System.Collections.IDictionary]) {
        $findings.Add('the head''s config part is not a map')
        return [string[]] $findings.ToArray()
    }

    $order = 'synopsis', 'description', 'parameters', 'inputs', 'outputs', 'examples', 'notes'
    $helpKeys = @($config.Keys | Where-Object { $_ -in $order })
    if ($helpKeys.Count -eq 0) {
        $findings.Add('the head''s config has no synopsis')
        return [string[]] $findings.ToArray()
    }
    $expected = @($order | Where-Object { $_ -in $helpKeys })
    if (($helpKeys -join ',') -cne ($expected -join ',')) {
        $findings.Add("the help keys are out of order: $($helpKeys -join ', '), expected $($expected -join ', ')")
    }
    if (-not $config.Contains('synopsis')) {
        $findings.Add('the head''s config has no synopsis')
    }

    foreach ($key in $helpKeys) {
        $values = if ($config[$key] -is [System.Collections.IDictionary]) {
            @($config[$key].Values)
        }
        elseif ($config[$key] -is [System.Collections.IEnumerable] -and $config[$key] -isnot [string]) {
            @($config[$key])
        }
        else {
            @($config[$key])
        }
        foreach ($value in $values) {
            foreach ($line in ("$value" -split "`n")) {
                if ($line.Trim() -cmatch '^\[(ADR-[A-Z0-9-]+(#\d+)?|comment:\d+)\]\([^)]*\)$') {
                    $findings.Add("the help text $key holds a line made of a citation or a page link, which the head derives")
                    break
                }
            }
        }
    }

    # The function the file is about: its first statement, else the script's own param block.
    $function = $null
    if ($null -eq $ast.ParamBlock -and $ast.EndBlock.Statements.Count -gt 0 -and $ast.EndBlock.Statements[0] -is [System.Management.Automation.Language.FunctionDefinitionAst]) {
        $function = $ast.EndBlock.Statements[0]
    }
    $paramBlock = if ($null -ne $function) {
        $function.Body.ParamBlock
    }
    else {
        $ast.ParamBlock
    }
    if ($null -ne $function -or $null -ne $paramBlock) {
        $declared = @()
        if ($null -ne $paramBlock) {
            $declared = @($paramBlock.Parameters | ForEach-Object { $_.Name.VariablePath.UserPath })
        }
        $documented = @()
        if ($config.Contains('parameters') -and $config['parameters'] -is [System.Collections.IDictionary]) {
            $documented = @($config['parameters'].Keys)
        }
        foreach ($name in $documented) {
            if ($name -notin $declared) {
                $findings.Add("the parameter $name is documented but the function declares no such parameter")
            }
        }
        foreach ($name in $declared) {
            if ($name -notin $documented) {
                $findings.Add("the parameter $name is declared but has no entry in parameters")
            }
        }
        if (($declared | Where-Object { $_ -in $documented }) -join ',' -cne (($documented | Where-Object { $_ -in $declared }) -join ',')) {
            $findings.Add("the parameters entries are not in the order of the param block: $($documented -join ', ')")
        }

        if ($null -ne $function -and $config.Contains('outputs') -and $null -ne $paramBlock) {
            $outputType = $paramBlock.Attributes | Where-Object { $_.TypeName.Name -ceq 'OutputType' } | Select-Object -First 1
            $documentedType = [regex]::Match("$($config['outputs'])", '\[([A-Za-z0-9_.]+(?:\[[A-Za-z0-9_.,\[\] ]*\])*)\]')
            if ($null -ne $outputType -and $documentedType.Success) {
                $declaredType = $outputType.PositionalArguments | Select-Object -First 1
                $short = {
                    param([string] $Value)
                    $name = $Value.Trim().Trim("'", '"')
                    if ($name.StartsWith('[', [System.StringComparison]::Ordinal) -and $name.EndsWith(']', [System.StringComparison]::Ordinal)) {
                        $name = $name.Substring(1, $name.Length - 2)
                    }
                    (($name -replace '\s+', '') -replace '(?:[A-Za-z0-9_]+\.)+', '').ToLowerInvariant()
                }
                if ($null -ne $declaredType -and (& $short $documentedType.Groups[1].Value) -ne (& $short $declaredType.Extent.Text)) {
                    $findings.Add("outputs documents [$($documentedType.Groups[1].Value)] but [OutputType] declares $($declaredType.Extent.Text)")
                }
            }
        }
    }
    [string[]] $findings.ToArray()
}
