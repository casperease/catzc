# pwsh/Base.QualityGates/tests/Measure-NoForEachObjectControlFlow.Tests.ps1

The L0 logic test of the custom analyzer rule `Measure-NoForEachObjectControlFlow`. Each case runs the analyzer with empty settings, which
stops PSScriptAnalyzer from auto-discovering `PSScriptAnalyzerSettings.psd1`. That file already lists this rule in `CustomRulePath`, so
discovery would invoke the rule twice.
