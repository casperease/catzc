function Get-FileLimit {
    [CmdletBinding()]
    [OutputType([Catzc.Base.FileLimits.ResolvedFileLimit])]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('FullName')]
        [string[]] $Path
    )

    begin {
        $config = Get-Config -Config file-limits
    }

    process {
        foreach ($file in $Path) {
            $language = Get-FileLanguage -Path $file
            if ($null -eq $language) {
                throw "No file language declares '$file', so it has no file limit (languages.yml in Catzc.Base.Languages)."
            }
            $config.ResolveFile($file, $language.name)
        }
    }
}
