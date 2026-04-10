<#
.SYNOPSIS
    Asserts that the actual module dependencies conform to the declared graph.
.DESCRIPTION
    Throws a single error listing every conformance violation when the real code uses a
    module dependency not permitted by configs/dependencies.yml (see
    Get-ModuleDependencyViolations for the allow-list rules); silent on success.

    A structurally invalid config throws at load time (via Get-ModuleDependencyConfig)
    before any conformance check runs.

    Must run post-import so the actual call graph covers all loaded modules.
.EXAMPLE
    Assert-ModuleDependency
#>
function Assert-ModuleDependency {
    param()

    $violations = @(Get-ModuleDependencyViolations)
    if ($violations.Count -gt 0) {
        $lines = $violations | ForEach-Object { $_.Message }
        throw "module dependency violations ($($violations.Count)):`n$($lines -join "`n")"
    }
}
