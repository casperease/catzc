function Get-GeneratedFileGenerator {
    [CmdletBinding()]
    [OutputType([string[]])]
    param()

    $writers = @(Get-GeneratedWriterOrder | ForEach-Object name)
    $rootGenerators = @((Get-Config -Config rootconfig).files | Where-Object { $_.optIn -and $_.generator } |
            ForEach-Object { "$($_.generator)" } | Select-Object -Unique)
    # A root generator with a writer row of its own is named once.
    [string[]] @($writers + @($rootGenerators | Where-Object { $_ -cnotin $writers }))
}
