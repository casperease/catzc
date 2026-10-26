function Get-PlanOpenStepCount {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Folder,

        [Parameter(Mandatory)]
        [Catzc.Base.QualityGates.PlansConfig] $Config
    )

    $counts = [ordered]@{}
    foreach ($file in $Config.PlanFiles($Folder)) {
        $name = [System.IO.Path]::GetFileName($file)
        $lines = [System.IO.File]::ReadAllText($file) -split "`r?`n"
        $counts[$name] = @(Get-MarkdownListItem -Line $lines | Where-Object { $_.First -match '^\s*(-|\d+\.) \[ \]' }).Count
    }
    , $counts
}
