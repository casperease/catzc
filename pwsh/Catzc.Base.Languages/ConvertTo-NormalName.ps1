<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-languages/ConvertTo-NormalName.ps1.md"
  header: "generated"
---
#>

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
        [string] $NameKind = 'function'
    )

    begin {
        $config = Get-Config -Config languages
        $naming = (Get-FileLanguage -Name $Language).naming
        if ($null -eq $naming -or $naming.$NameKind.Count -eq 0) {
            throw "languages['$Language'].naming names no $NameKind case, so a $Language $NameKind name has no normal form."
        }
        $cases = $naming.$NameKind
    }

    process {
        # The first of the language's cases the name is in.
        $case = @($cases.Where({ [Catzc.Base.Objects.NameCase]::IsInCase($_, $Name) }, 'First'))
        if ($case.Count -eq 0) {
            throw "'$Name' is not a $Language $NameKind name (it is in none of: $($cases -join ', '))."
        }
        [Catzc.Base.Objects.NameCase]::ToNormal($case[0], $Name, $config.naming_normal_form)
    }
}
