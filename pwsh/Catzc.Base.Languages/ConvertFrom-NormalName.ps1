<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-languages/ConvertFrom-NormalName.ps1.md"
  warning: "Generated Header"
---
#>

function ConvertFrom-NormalName {
    [CmdletBinding()]
    [OutputType([string])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-ParameterFillIn', '', Justification = '-Case defaults to the first case -Language configures for -NameKind, so the body first checks that the language names one and says so; a declared default would fail before that message (ADR-PWSH-PARAM-RESOLUTIONORDER)')]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [string] $Name,

        [Parameter(Mandatory)]
        [ArgumentCompleter({ (Get-Config -Config languages).languages.Where({ $null -ne $_.naming }).name })]
        [string] $Language,

        [ValidateSet('function', 'type', 'file', 'folder')]
        [string] $NameKind = 'function',

        [ArgumentCompleter({ [Catzc.Base.Objects.NameCase]::Cases })]
        [string] $Case
    )

    begin {
        $config = Get-Config -Config languages
        $naming = (Get-FileLanguage -Name $Language).naming
        if ($null -eq $naming -or $naming.$NameKind.Count -eq 0) {
            throw "languages['$Language'].naming names no $NameKind case, so no $Language $NameKind name renders from the normal form."
        }
        # One resolution order: the case named, else the language's first case for the kind.
        if (-not $Case) {
            $Case = $naming.$NameKind[0]
        }
        elseif ($Case -cnotin $naming.$NameKind) {
            throw "'$Case' is not a $Language $NameKind case (one of: $($naming.$NameKind -join ', '))."
        }
    }

    process {
        try {
            [Catzc.Base.Objects.NameCase]::FromNormal($Name, $Case, $config.naming_normal_form)
        }
        catch [System.Management.Automation.MethodInvocationException] {
            throw $_.Exception.InnerException.Message
        }
    }
}
