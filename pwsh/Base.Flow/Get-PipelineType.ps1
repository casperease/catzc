function Get-PipelineType {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Name
    )

    # The pipeline types a file name's prefix names, the longest prefix first, so cde- is never read as cd-; a name with none is unknown.
    $types = [ordered]@{ 'cde-' = 'CDe'; 'deploy-' = 'DEPLOY'; 'input-' = 'INPUT'; 'cron-' = 'CRON'; 'ci-' = 'CI'; 'cd-' = 'CD' }
    foreach ($prefix in $types.Keys) {
        if ($Name.StartsWith($prefix, [System.StringComparison]::OrdinalIgnoreCase)) {
            return [pscustomobject]@{ Type = $types[$prefix]; Unit = $Name.Substring($prefix.Length) }
        }
    }
    [pscustomobject]@{ Type = 'unknown'; Unit = $Name }
}
