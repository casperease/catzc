function Get-Naming {
    [CmdletBinding()]
    [OutputType([string], [string[]])]
    param()

    $naming = Get-Variant -Name naming
    if ($naming -is [string]) {
        return $naming
    }
    , [string[]] @($naming)
}
