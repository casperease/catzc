Describe 'Invoke-ScriptAnalyzerShards (real vendored analyzer)' -Tag 'L2', 'integrity', 'ADR-AUTO-ASSETDEP-COVEREDBYREALTEST', 'ADR-AUTO-CONSUMER-CATZCGATES' {
    BeforeAll {
        # The built shape: settings under a working root with relative rule paths, the rules and the analyzer under a separate code root.
        $script:work = Join-Path $TestDrive 'work'
        $script:code = Join-Path $TestDrive 'code'
        [void][System.IO.Directory]::CreateDirectory($script:work)
        [void][System.IO.Directory]::CreateDirectory((Join-Path $script:code '.scriptanalyzer'))
        $rule = @'
function Measure-WidgetRule {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
        Message  = 'widget rule ran'
        Extent   = $ScriptBlockAst.Extent
        RuleName = 'Measure-WidgetRule'
        Severity = 'Warning'
    }
}

Export-ModuleMember -Function Measure-*
'@
        [System.IO.File]::WriteAllText((Join-Path $script:code '.scriptanalyzer/WidgetRule.psm1'), $rule)
        New-Item -ItemType Junction -Path (Join-Path $script:code '.vendor') -Target (Join-Path (Get-CatzcModulesRoot) '.vendor') | Out-Null
        $script:settings = Join-Path $script:work ([System.IO.Path]::GetFileName([Catzc.Base.QualityGates.AnalyzerDrsMapConfig]::SettingsPath((Get-CatzcModulesRoot))))
        [System.IO.File]::WriteAllText($script:settings, "@{ IncludeDefaultRules = `$false; CustomRulePath = @('pwsh/.scriptanalyzer/WidgetRule.psm1') }`n")
        $script:target = Join-Path $script:work 'Get-Gadget.ps1'
        [System.IO.File]::WriteAllText($script:target, "function Get-Gadget { 1 }`n")
    }

    AfterAll {
        # A junction is removed itself, never its target's content.
        [System.IO.Directory]::Delete((Join-Path $script:code '.vendor'))
    }

    It 'resolves each relative rule path to the code root''s rule folder, so the shipped rule runs and the working root holds none' {
        $run = InModuleScope Catzc.Base.QualityGates -Parameters @{ W = $script:work; C = $script:code; S = $script:settings; T = $script:target } {
            param($W, $C, $S, $T)
            Mock Write-Message { }
            $batch = [pscustomobject]@{
                Label        = 'rules'
                Files        = [string[]] @($T)
                SettingsPath = $S
                IncludeRule  = @()
                ExcludeRule  = @()
            }
            $ended = [System.Collections.Generic.List[object]]::new()
            $found = (Invoke-ScriptAnalyzerShards -Batch @($batch) -RepositoryRoot $W -CodeRoot $C -OnShardComplete {
                    param($Label, $File, $Diagnostic)
                    $ended.Add([pscustomobject]@{ Label = $Label; Files = @($File); Count = @($Diagnostic).Count })
                }.GetNewClosure())['rules']
            [pscustomobject]@{ Found = @($found); Ended = @($ended) }
        }
        Test-Path -LiteralPath (Join-Path $script:work 'pwsh/.scriptanalyzer/WidgetRule.psm1') | Should -BeFalse
        @($run.Found).Count | Should -BeGreaterThan 0
        @($run.Found).RuleName | Should -Contain 'Measure-WidgetRule'
        # The shard reported its end with its files and its diagnostics, before the call returned them.
        @($run.Ended) | Should -HaveCount 1
        $run.Ended[0].Label | Should -Be 'rules'
        @($run.Ended[0].Files) | Should -Be @($script:target)
        $run.Ended[0].Count | Should -Be @($run.Found).Count
    }
}
