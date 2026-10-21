<#
---
catzc:
  immutable:
    with_body_sha: f21b312895e3
  edges:
    test: pwsh/Catzc.Base.Languages/tests/ConvertFrom-NormalName.Tests.ps1
    cites:
      - ADR-PWSH-PARAM-RESOLUTIONORDER
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

        [ArgumentCompleter({ [Catzc.Base.Languages.LanguageNaming]::Cases })]
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
            [Catzc.Base.Languages.LanguageNaming]::FromNormal($Name, $Case, $config.naming_normal_form)
        }
        catch [System.Management.Automation.MethodInvocationException] {
            throw $_.Exception.InnerException.Message
        }
    }
}
