function Test-FileIsLocked {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path
    )

    Assert-PathExist $Path -PathType Leaf

    try {
        $stream = [System.IO.File]::Open($Path, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read,
            [System.IO.FileShare]::None)
        $stream.Dispose()
        $false
    }
    catch [System.IO.IOException] {
        $true
    }
}
