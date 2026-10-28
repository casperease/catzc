function Get-GlossaryRuleStatements {
    [CmdletBinding()]
    [OutputType([System.Collections.Generic.Dictionary[string, string]])]
    param(
        [Parameter(Mandatory)]
        [string] $IndexPath
    )

    $drsRoot = Split-Path $IndexPath -Parent
    $statements = [System.Collections.Generic.Dictionary[string, string]]::new([System.StringComparer]::Ordinal)
    foreach ($record in (Get-DrsIndex -IndexPath $IndexPath)) {
        foreach ($rule in (Get-DrsRules -DrsPath (Join-Path $drsRoot $record.Path))) {
            $statements[$rule.Id] = $rule.Statement -replace '`[^`]*`', ''
        }
    }

    , $statements
}
