<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-quality-gates/Test-LinkDirections.ps1.md"
  header: "generated"
---
#>

function Test-LinkDirections {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [Catzc.Base.Asserts.ValidatePathGiven()]
        [string[]] $Path,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    $settings = Get-Config -Config links
    $result = Invoke-LinkEngine -RepositoryRoot $RepositoryRoot -Path $Path -Kind Both -Wrap $settings.wrap -IncludeEdge
    $written = @($result.Edges)
    # The relations a declaration implies join the same scope's files and are judged by the same rows.
    $convention = @(Get-ConventionEdge -Path ([string[]] @(Get-LinkScope -RepositoryRoot $RepositoryRoot -Path $Path)))
    $edges = @($written) + @($convention)
    $paths = [string[]] @(foreach ($edge in $edges) {
            $edge.File
            $edge.Target
        })
    $endpoints = Get-LinkEndpoint -Path $paths
    $findings = [Catzc.Base.QualityGates.LinkDirectionEngine]::Judge([Catzc.Base.QualityGates.LinkEdge[]] $edges,
        $endpoints, (Get-Config -Config link-directions))
    $issues = [string[]] @(foreach ($finding in $findings) {
            "$finding"
        })
    # A run that read no relation proves nothing, so it is a finding, never a pass.
    if ($edges.Count -eq 0) {
        $issues = [string[]] @("no relation found in $($result.FileCount) file(s): the walk read no link to judge")
    }

    $facts = [ordered]@{
        FileCount       = $result.FileCount
        EdgeCount       = $edges.Count
        ConventionCount = $convention.Count
    }
    Write-QualityGateReport -Subject link-directions -Title Test-LinkDirections -Issues $issues -Facts $facts -OutputFolder $OutputFolder -PassThru:$PassThru
}
