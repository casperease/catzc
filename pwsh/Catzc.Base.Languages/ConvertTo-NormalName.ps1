function ConvertTo-NormalName {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [string] $Name,

        [Parameter(Mandatory)]
        [ArgumentCompleter({ (Get-Config -Config languages).languages.Where({ $null -ne $_.naming }).name })]
        [string] $Language,

        [ValidateSet('function', 'type', 'file', 'folder')]
        [string] $Kind = 'function'
    )

    begin {
        $config = Get-Config -Config languages
        $naming = (Get-FileLanguage -Name $Language).naming
        if ($null -eq $naming -or $naming.$Kind.Count -eq 0) {
            throw "languages['$Language'].naming names no $Kind case, so a $Language $Kind name has no normal form."
        }
        $cases = $naming.$Kind
    }

    process {
        # The first of the language's cases the name is in.
        $case = @($cases.Where({ [Catzc.Base.Languages.LanguageNaming]::IsInCase($_, $Name) }, 'First'))
        if ($case.Count -eq 0) {
            throw "'$Name' is not a $Language $Kind name (it is in none of: $($cases -join ', '))."
        }
        [Catzc.Base.Languages.LanguageNaming]::ToNormal($case[0], $Name, $config.naming_normal_form)
    }
}
