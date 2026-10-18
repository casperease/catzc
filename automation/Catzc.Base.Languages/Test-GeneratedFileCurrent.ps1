function Test-GeneratedFileCurrent {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,

        [Parameter(Mandatory, Position = 1)]
        [string] $InputsSha
    )

    if (-not [System.IO.File]::Exists($Path)) {
        return $false
    }

    # The head sits first in the file, so a bounded read is enough.
    $buffer = [char[]]::new(4096)
    $reader = [System.IO.StreamReader]::new($Path)
    try {
        $count = $reader.Read($buffer, 0, $buffer.Length)
    }
    finally {
        $reader.Dispose()
    }
    $start = [string]::new($buffer, 0, $count)

    $match = [regex]::Match($start, 'with_inputs_sha:\s*\\?"?([0-9a-f]{64})')
    $match.Success -and $match.Groups[1].Value -ceq $InputsSha
}
