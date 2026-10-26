function Get-LinkEdge {
    [CmdletBinding()]
    [OutputType([Catzc.Base.QualityGates.LinkEdge])]
    param(
        # A folder takes every relation into what lies under it.
        [Parameter(Mandatory, Position = 0)]
        [string] $To,

        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    Assert-SourceTree

    # The written relations and the derived ones, from the same walk and the same declarations as Test-LinkDirections.
    $target = $To.Replace('\', '/').TrimEnd('/')
    $settings = Get-Config -Config links
    $written = @((Invoke-LinkEngine -RepositoryRoot $RepositoryRoot -Kind Both -Wrap $settings.wrap -IncludeEdge).Edges)
    $convention = @(Get-ConventionEdge -Path ([string[]] @(Get-LinkScope -RepositoryRoot $RepositoryRoot)))
    foreach ($edge in @($written) + @($convention)) {
        if ($edge.Target -ceq $target -or $edge.Target.StartsWith("$target/", [System.StringComparison]::Ordinal)) {
            $edge
        }
    }
}
