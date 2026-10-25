function Format-CatzcPackageManifest {
    # .SYNOPSIS
    #     Renders the package manifest Catzc.psd1 as canonical, deterministic text.
    # .DESCRIPTION
    #     Not New-ModuleManifest, whose generation date would make the same commit yield different bytes.
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Version,

        [Parameter(Mandatory)]
        [hashtable] $PackageMetadata,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $FunctionToExport
    )

    $quote = {
        param([string] $Value)
        "'" + $Value.Replace("'", "''") + "'"
    }
    $listLiteral = {
        param([string[]] $Values)
        if ($Values.Count -eq 0) {
            return '@()'
        }
        $quoted = foreach ($value in $Values) {
            & $quote $value
        }
        '@(' + (@($quoted) -join ', ') + ')'
    }

    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add('@{')
    $lines.Add("    RootModule        = 'Catzc.psm1'")
    $lines.Add("    ModuleVersion     = $(& $quote $Version)")
    $lines.Add("    GUID              = $(& $quote ([string] $PackageMetadata['Guid']))")
    $lines.Add("    Author            = $(& $quote ([string] $PackageMetadata['Author']))")
    $lines.Add("    CompanyName       = $(& $quote ([string] $PackageMetadata['CompanyName']))")
    $lines.Add("    Description       = $(& $quote ([string] $PackageMetadata['Description']))")
    $lines.Add("    PowerShellVersion = '7.4'")
    if ($FunctionToExport.Count -eq 0) {
        $lines.Add('    FunctionsToExport = @()')
    }
    else {
        $lines.Add('    FunctionsToExport = @(')
        foreach ($name in $FunctionToExport) {
            $lines.Add("        $(& $quote $name)")
        }
        $lines.Add('    )')
    }
    $lines.Add('    CmdletsToExport   = @()')
    $lines.Add('    VariablesToExport = @()')
    $lines.Add('    AliasesToExport   = @()')
    $lines.Add('    PrivateData       = @{')
    $lines.Add('        PSData = @{')
    $lines.Add("            Tags       = $(& $listLiteral ([string[]] @($PackageMetadata['Tags'] | Where-Object { $_ })))")
    foreach ($key in 'ProjectUri', 'LicenseUri') {
        $value = [string] $PackageMetadata[$key]
        if (-not [string]::IsNullOrWhiteSpace($value)) {
            $lines.Add("            $($key.PadRight(10)) = $(& $quote $value)")
        }
    }
    $lines.Add('        }')
    $lines.Add('    }')
    $lines.Add('}')
    ($lines -join "`n") + "`n"
}
