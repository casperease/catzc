<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Timeouts/tests/Get-TimeoutSeconds.Repository.Tests.ps1
    folder: tests
    name: get-timeout-seconds-repository-tests
    filetype: ps1
    role: test
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Timeouts
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[Get-TimeoutSeconds.Repository.Tests.ps1.md](docs/references/pwsh/catzc-base-timeouts/tests/Get-TimeoutSeconds.Repository.Tests.ps1.md)"
    cites:
      - ADR-PWSH-ASSERT-DECLAREDTIMELIMIT
---
#>

Describe 'TimeoutSeconds defaults come from the time safeguard' -Tag 'L1', 'integrity', 'ADR-PWSH-ASSERT-DECLAREDTIMELIMIT' {
    It 'no function defaults a TimeoutSeconds parameter to a number literal above zero' {
        $root = Get-CatzcModulesRoot
        $isParameter = { param($node) $node -is [System.Management.Automation.Language.ParameterAst] }
        # Scripts reach four levels below pwsh/ (module, tests, types, file); the vendored modules are pruned by the walk.
        $violations = foreach ($file in Get-ChildPath $root -File -Filter '*.ps1' -Depth 4) {
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
