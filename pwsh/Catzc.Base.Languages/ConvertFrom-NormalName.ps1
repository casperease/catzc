function ConvertFrom-NormalName {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [string] $Name,

        [Parameter(Mandatory)]
        [ArgumentCompleter({ (Get-Config -Config languages).languages.Where({ $null -ne $_.naming }).name })]
        [string] $Language,

        [ValidateSet('function', 'type', 'file', 'folder')]
        [string] $Kind = 'function',

        [ArgumentCompleter({ [Catzc.Base.Languages.LanguageNaming]::Cases })]
        [string] $Case
    )

    begin {
        $config = Get-Config -Config languages
        $naming = (Get-FileLanguage -Name $Language).naming
        if ($null -eq $naming -or $naming.$Kind.Count -eq 0) {
            throw "languages['$Language'].naming names no $Kind case, so no $Language $Kind name renders from the normal form."
        }
        # One resolution order: the case named, else the language's first case for the kind.
        if (-not $Case) {
            $Case = $naming.$Kind[0]
        }
        elseif ($Case -cnotin $naming.$Kind) {
            throw "'$Case' is not a $Language $Kind case (one of: $($naming.$Kind -join ', '))."
        }
    }

    process {
        try {
            [Catzc.Base.Languages.LanguageNaming]::FromNormal($Name, $Case, $config.naming_normal_form)
        }
        catch [System.Management.Automation.MethodInvocationException] {
            throw $_.Exception.InnerException.Message
        }
    }
}
