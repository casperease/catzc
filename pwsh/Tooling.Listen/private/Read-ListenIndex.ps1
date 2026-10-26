function Read-ListenIndex {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path
    )

    Assert-PathExist $Path -PathType Leaf
    $index = [System.IO.File]::ReadAllText($Path) | ConvertFrom-Json -AsHashtable
    if ($null -eq $index) {
        return @{}
    }
    $index
}
