<#
---
catzc:
  immutable:
    with_body_sha: f11e2f68c933
  edges:
    docs: "[NoTrackRootLiteral.psm1.md](docs/references/pwsh/scriptanalyzer/NoTrackRootLiteral.psm1.md)"
    cites:
      - ADR-AUTO-LAYERS
---
#>

Set-StrictMode -Version Latest   # this module's scope: the rule runs strict inside the analyzer engine

$script:roots = $null
$script:exempt = $null
$script:repoRoot = $null

function Initialize-TrackRootLiteralData {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '', Justification = 'Runs inside the analyzer engine, whose custom rules may emit only diagnostic records; it binds the vendored YAML reader the importer already loaded and announced, and in a bare analyzer shard process there is no console session to announce to')]
    [CmdletBinding()]
    param()

    if ($null -ne $script:roots) {
        return
    }
    # The rule sits in the modules root, so it reads the registries from there and names no root itself.
    $modulesRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
    $script:repoRoot = [System.IO.Path]::GetFullPath((Join-Path $modulesRoot '..'))
    if (-not (Get-Command ConvertFrom-Yaml -ErrorAction Ignore)) {
        $versions = [System.IO.Directory]::GetDirectories((Join-Path $modulesRoot '.vendor/powershell-yaml'))
        Import-Module (Join-Path ($versions | Sort-Object | Select-Object -Last 1) 'powershell-yaml.psd1')
    }
    $variants = ConvertFrom-Yaml ([System.IO.File]::ReadAllText((Join-Path $modulesRoot 'Catzc.Base.Variants/configs/variants.yml')))
    # The relocatable modules root (Get-CatzcModulesRoot) holds the track whose modules run under this engine, pwsh; its places are the ones no string may spell.
    $script:roots = @(foreach ($track in $variants['tracks'].Values) {
            if (@($track['execution_engines']) -ccontains 'pwsh') {
                @($track['places'])
            }
        })
    $conventions = ConvertFrom-Yaml ([System.IO.File]::ReadAllText((Join-Path $modulesRoot 'Catzc.Base.QualityGates/configs/source-conventions.yml')))
    $section = $conventions['track_root_literal']
    $script:exempt = @(if ($section -and $section['exempt']) {
            @($section['exempt'].Keys | ForEach-Object {
                    '^' + ([regex]::Escape($_) -replace '\\\*\\\*/', '(.*/)?' -replace '\\\*\\\*', '.*' -replace '\\\*', '[^/]*') + '$'
                })
        })
}

function Measure-NoTrackRootLiteral {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    $file = $ScriptBlockAst.Extent.File
    if (-not $file) {
        return @()
    }
    Initialize-TrackRootLiteralData
    $relative = [System.IO.Path]::GetRelativePath($script:repoRoot, $file) -replace '\\', '/'
    foreach ($pattern in $script:exempt) {
        if ($relative -match $pattern) {
            return @()
        }
    }

    $isString = {
        param($node)
        $node -is [System.Management.Automation.Language.StringConstantExpressionAst] -or
        $node -is [System.Management.Automation.Language.ExpandableStringExpressionAst]
    }
    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()
    foreach ($node in $ScriptBlockAst.FindAll($isString, $true)) {
        # A string nested in an expandable string is reported once, by the outer string.
        if ($node.Parent -is [System.Management.Automation.Language.ExpandableStringExpressionAst]) {
            continue
        }
        $value = $node.Value -replace '\\', '/'
        # The bare place is also a word with other senses (an ADR domain, a layer), so alone it counts only where a path is built.
        $parent = $node.Parent
        while ($parent -is [System.Management.Automation.Language.CommandParameterAst] -or $parent -is [System.Management.Automation.Language.ParenExpressionAst] -or $parent -is [System.Management.Automation.Language.PipelineAst] -or $parent -is [System.Management.Automation.Language.CommandExpressionAst]) {
            $parent = $parent.Parent
        }
        $inPath = ($parent -is [System.Management.Automation.Language.CommandAst] -and $parent.GetCommandName() -in 'Join-Path', 'Resolve-RepoPath', 'Get-ChildPath') -or
        ($parent -is [System.Management.Automation.Language.InvokeMemberExpressionAst] -and "$($parent.Member)" -eq 'Combine')
        foreach ($root in $script:roots) {
            if (($value -ceq $root -and $inPath) -or $value.StartsWith("$root/", [System.StringComparison]::Ordinal)) {
                $results.Add([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                        Message  = "The string '$($node.Value)' spells the modules track's place '$root'; resolve it with Get-CatzcModulesRoot or Get-Track (ADR-AUTO-LAYERS), or exempt the file in source-conventions.yml track_root_literal with its reason."
                        Extent   = $node.Extent
                        RuleName = 'Measure-NoTrackRootLiteral'
                        Severity = 'Information'
                    })
                break
            }
        }
    }
    return $results.ToArray()
}

Export-ModuleMember -Function Measure-*
