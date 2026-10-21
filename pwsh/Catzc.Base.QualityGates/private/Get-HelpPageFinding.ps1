<#
---
catzc:
  immutable:
    with_body_sha: e0a91ab4e138
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-HelpPageFinding.Tests.ps1
    docs: "[Get-HelpPageFinding.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-HelpPageFinding.ps1.md)"
    cites:
      - ADR-REPO-HELP-FIVEFAULTSREPORTED
---
#>

function Get-HelpPageFinding {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $Text,

        [AllowEmptyString()]
        [AllowNull()]
        [string] $PageText
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
        $findings.Add('comment-based help is not used: write the help in the ## help section of the comment page')
    }
    if ([string]::IsNullOrEmpty($PageText)) {
        $findings.Add('the file has no comment page: write its help in the page''s ## help section')
        return [string[]] $findings.ToArray()
    }
    $help = [Catzc.Base.QualityGates.FunctionHelp]::Parse($PageText)
    if (-not $help.present) {
        $findings.Add('the comment page has no ## help section')
        return [string[]] $findings.ToArray()
    }
    foreach ($finding in $help.findings) {
        $findings.Add($finding)
    }

    $texts = @($help.synopsis, $help.description, $help.inputs, $help.outputs, $help.notes) + @($help.parameters | ForEach-Object Value)
    foreach ($value in @($texts | Where-Object { $_ })) {
        foreach ($line in ("$value" -split "`n")) {
            if ($line.Trim() -cmatch '^\[(ADR-[A-Z0-9-]+(#\d+)?|comment:\d+)\]\([^)]*\)$') {
                $findings.Add('a help line is made of nothing but a citation or a page link, which the tooling derives')
                break
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
        $documented = @($help.parameters | ForEach-Object Key)
        foreach ($name in $documented) {
            if ($name -notin $declared) {
                $findings.Add("the parameter $name is documented but the function declares no such parameter")
            }
        }
        foreach ($name in $declared) {
            if ($name -notin $documented) {
                $findings.Add("the parameter $name is declared but has no ### parameter subsection")
            }
        }
        if (($declared | Where-Object { $_ -in $documented }) -join ',' -cne (($documented | Where-Object { $_ -in $declared }) -join ',')) {
            $findings.Add("the parameter subsections are not in the order of the param block: $($documented -join ', ')")
        }

        if ($null -ne $function -and $help.outputs -and $null -ne $paramBlock) {
            $outputType = $paramBlock.Attributes | Where-Object { $_.TypeName.Name -ceq 'OutputType' } | Select-Object -First 1
            $documentedType = [regex]::Match("$($help.outputs)", '\[([A-Za-z0-9_.]+(?:\[[A-Za-z0-9_.,\[\] ]*\])*)\]')
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
