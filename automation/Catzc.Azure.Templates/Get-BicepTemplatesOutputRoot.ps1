<#
.SYNOPSIS
    Returns the root folder Build-Bicep writes template build output under.
.DESCRIPTION
    The output-side twin of Get-BicepTemplatesRoot: templates' output_folder descriptors resolve to
    <output root>/template/<name>, and this function owns the root — <repository>/out by default. It exists
    as a seam (ADR-TEST:2): build tests mock it to a folder of their own so no two test files ever write
    the same build folder (a fixed out/ path two files both write is the serial-tag race, ADR-TEST:26 —
    mocking the seam removes the sharing instead). Keep any mocked root under the repository when the test
    also asserts the repo-relative artifact contract (Get-BicepDeploymentContext relativizes against the
    repository root).
.OUTPUTS
    [string] the absolute output root path.
.EXAMPLE
    Get-BicepTemplatesOutputRoot
#>
function Get-BicepTemplatesOutputRoot {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    Join-Path (Get-RepositoryRoot) 'out'
}
