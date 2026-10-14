# A function bounds its own long-running work through Get-TimeoutSeconds -Command and its [TimeLimit] decoration, never
# a number literal as the parameter default
# ([ADR-PWSH-ASSERT#1](/docs/adr/pwsh/assert-idioms.md#rule-adr-pwsh-assert1)). Reads the shipped .ps1
# files by AST, so it runs in the source and the build run alike.
Describe 'TimeoutSeconds defaults come from the time safeguard' -Tag 'L1', 'integrity', 'ADR-PWSH-ASSERT#1' {
    It 'no function defaults a TimeoutSeconds parameter to a number literal above zero' {
        $root = Get-CatzcModulesRoot
        $isParameter = { param($node) $node -is [System.Management.Automation.Language.ParameterAst] }
        $violations = foreach ($file in [System.IO.Directory]::EnumerateFiles($root, '*.ps1', [System.IO.SearchOption]::AllDirectories)) {
            $relative = [System.IO.Path]::GetRelativePath($root, $file) -replace '\\', '/'
            if ($relative -like '.vendor/*' -or $relative -like '*/tests/*') {
                continue
            }
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($file, [ref]$null, [ref]$null)
            foreach ($parameter in $ast.FindAll($isParameter, $true)) {
                $default = $parameter.DefaultValue
                if ($parameter.Name.VariablePath.UserPath -eq 'TimeoutSeconds' -and
                    $default -is [System.Management.Automation.Language.ConstantExpressionAst] -and
                    $default.Value -is [ValueType] -and [double]$default.Value -gt 0) {
                    "${relative}:$($parameter.Extent.StartLineNumber) defaults -TimeoutSeconds to $($default.Value)"
                }
            }
        }
        @($violations) | Should -BeNullOrEmpty -Because 'declare [Catzc.Base.Timeouts.TimeLimit] and default to Get-TimeoutSeconds -Command'
    }
}
