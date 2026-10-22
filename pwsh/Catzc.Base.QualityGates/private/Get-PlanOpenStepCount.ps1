function Get-PlanOpenStepCount {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Folder,

        [Parameter(Mandatory)]
        [Catzc.Base.QualityGates.PlansConfig] $Config
    )

    $files = [string[]] @([System.IO.Directory]::GetFiles($Folder, 'plan-*.md'))
    [Array]::Sort($files, [System.StringComparer]::Ordinal)
    $counts = [ordered]@{}
    foreach ($file in $files) {
        $name = [System.IO.Path]::GetFileName($file)
        if ($name -ceq $Config.master_file) {
            continue
        }
        $lines = [System.IO.File]::ReadAllText($file) -split "`r?`n"
        $counts[$name] = @(Get-MarkdownListItem -Line $lines | Where-Object { $_.First -match '^\s*(-|\d+\.) \[ \]' }).Count
    }
    , $counts
}
