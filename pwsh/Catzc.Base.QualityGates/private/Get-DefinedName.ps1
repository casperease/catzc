<#
---
catzc:
  immutable:
    with_body_sha: cd6e8e1c7488
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-DefinedName.Tests.ps1
    docs: "[Get-DefinedName.ps1.md](../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-DefinedName.ps1.md)"
---
#>

function Get-DefinedName {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $Path,

        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    $patterns = @{
        python = @{ function = '(?m)^[ \t]*(?:async[ \t]+)?def[ \t]+([A-Za-z_][A-Za-z0-9_]*)'; type = '(?m)^[ \t]*class[ \t]+([A-Za-z_][A-Za-z0-9_]*)' }
        go     = @{ function = '(?m)^func[ \t]+(?:\([^)]*\)[ \t]*)?([A-Za-z_][A-Za-z0-9_]*)'; type = '(?m)^type[ \t]+([A-Za-z_][A-Za-z0-9_]*)' }
    }
    $config = Get-Config -Config languages
    foreach ($relative in $Path) {
        $language = $config.ForPath($relative)
        if ($null -eq $language -or $null -eq $language.naming -or ($language.naming.function.Count -eq 0 -and $language.naming.type.Count -eq 0)) {
            continue
        }
        $full = Join-Path $RepositoryRoot $relative
        if (-not [System.IO.File]::Exists($full)) {
            continue
        }
        if ($language.name -ceq 'powershell') {
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($full, [ref] $null, [ref] $null)
            foreach ($definition in $ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $true)) {
                # A scope qualifier sits outside the case, as a hidden folder's dot does: script:New-Widget is a verb-noun name.
                [pscustomobject]@{ Path = $relative; Kind = 'function'; Name = $definition.Name -creplace '^(?:script|global|local|private):', '' }
            }
            foreach ($definition in $ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.TypeDefinitionAst] }, $true)) {
                [pscustomobject]@{ Path = $relative; Kind = 'type'; Name = $definition.Name }
            }
            continue
        }
        $reader = $patterns[$language.name]
        if ($null -eq $reader) {
            continue
        }
        $text = [System.IO.File]::ReadAllText($full)
        foreach ($kind in 'function', 'type') {
            foreach ($match in [regex]::Matches($text, $reader[$kind])) {
                [pscustomobject]@{ Path = $relative; Kind = $kind; Name = $match.Groups[1].Value }
            }
        }
    }
}
