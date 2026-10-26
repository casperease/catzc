function Get-GeneratedFileGenerator {
    [CmdletBinding()]
    [OutputType([string[]])]
    param()

    $writers = @((Get-Config -Config generated-files).writers.Keys)
    $rootGenerators = @((Get-Config -Config rootconfig).files | Where-Object { $_.optIn -and $_.generator } |
            ForEach-Object { "$($_.generator)" } | Select-Object -Unique)
    [string[]] @($writers + $rootGenerators)
}
