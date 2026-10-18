function Get-ScriptAnalyzerInputs {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [Parameter(Mandatory)]
        [string] $SettingsPath,

        [Parameter(Mandatory)]
        [ValidateSet('rules', 'spelling')]
        [string] $Pass
    )

    $codeRoot = Get-CatzcModulesRoot
    # The spelling pass's own rule files; the rules pass reads every other rule file.
    $spellingRules = 'CatzcSpelling.psm1', 'SpellOutIdentifiers.psm1'
    $inputs = [System.Collections.Generic.List[string]]::new()
    $inputs.Add($SettingsPath)
    foreach ($folder in (Join-Path $codeRoot '.scriptanalyzer'), (Join-Path $codeRoot '.vendor/PSScriptAnalyzer')) {
        if ([System.IO.Directory]::Exists($folder)) {
            $isVendor = $folder -like '*.vendor*'
            $pattern = if ($isVendor) {
                'PSScriptAnalyzer.psd1'
            }
            else {
                '*.ps*1'
            }
            # The rule files sit directly in .scriptanalyzer and the manifest one version folder into the vendored module.
            foreach ($file in @(Get-ChildPath $folder -File -Filter $pattern -Depth 3 -PruneVendor $false | Sort-Object)) {
                if ($file -match '[\\/]tests[\\/]') {
                    continue
                }
                $isSpellingRule = -not $isVendor -and [System.IO.Path]::GetFileName($file) -in $spellingRules
                if ($isVendor -or ($isSpellingRule -eq ($Pass -eq 'spelling'))) {
                    $inputs.Add($file)
                }
            }
        }
    }
    if ($Pass -eq 'spelling') {
        $inputs.Add((Join-Path $RepositoryRoot "$(Get-CatzcModulesFolder)/Catzc.Base.QualityGates/assets/english.txt.gz"))
        $inputs.Add((Join-Path $RepositoryRoot "$(Get-CatzcModulesFolder)/Catzc.Base.QualityGates/types/SpellingOracle.cs"))
        $cspell = Join-Path $RepositoryRoot '.cspell'
        if ([System.IO.Directory]::Exists($cspell)) {
            foreach ($file in @([System.IO.Directory]::EnumerateFiles($cspell, '*.txt') | Sort-Object)) {
                $inputs.Add($file)
            }
        }
    }
    , [string[]] $inputs.ToArray()
}
