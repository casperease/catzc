function Get-GlossaryRuleStatements {
    [CmdletBinding()]
    [OutputType([System.Collections.Generic.Dictionary[string, string]])]
    param(
        [Parameter(Mandatory)]
        [string] $IndexPath
    )

    $adrRoot = Split-Path $IndexPath -Parent
    $statements = [System.Collections.Generic.Dictionary[string, string]]::new([System.StringComparer]::Ordinal)
    foreach ($adr in (Get-DrsIndex -IndexPath $IndexPath)) {
        foreach ($rule in (Get-DrsRules -DrsPath (Join-Path $adrRoot $adr.Path))) {
            $statements[$rule.Id] = $rule.Statement -replace '`[^`]*`', ''
        }
    }

    , $statements
}
