<#
.SYNOPSIS
    Tests whether the actual module dependencies conform to the declared graph.
.DESCRIPTION
    Compares the real module-to-module edges against the allow-list declared in
    configs/dependencies.yml (see Get-ModuleDependencyViolations for the rules).

    Returns $true when the code conforms, $false otherwise. Violations are written to
    the console in red. A structurally invalid config throws at load time rather than
    returning $false — a malformed config is a bug to fix, not a conformance result.

    Must run post-import so the actual call graph covers all loaded modules.
.EXAMPLE
    Test-ModuleDependency
.EXAMPLE
    Test-ModuleDependency -Verbose
#>
function Test-ModuleDependency {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    $violations = @(Get-ModuleDependencyViolations)
    foreach ($violation in $violations) {
        Write-Message $violation.Message -ForegroundColor Red
    }

    $violations.Count -eq 0
}
