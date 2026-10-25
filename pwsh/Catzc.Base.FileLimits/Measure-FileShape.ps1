function Measure-FileShape {
    [CmdletBinding()]
    [OutputType([Catzc.Base.FileLimits.FileShape])]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('FullName')]
        [string[]] $Path
    )

    process {
        foreach ($file in $Path) {
            [Catzc.Base.FileLimits.FileShape]::Measure((Resolve-Path -LiteralPath $file).ProviderPath)
        }
    }
}
