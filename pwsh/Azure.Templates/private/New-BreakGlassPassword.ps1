function New-BreakGlassPassword {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [ValidateRange(16, 128)]
        [int] $Length = 32
    )

    # The four classes SQL requires, without I, O, l, 0 and 1, which read alike, and without a quote, backslash, space or dollar sign.
    $classes = @(
        -join ([char[]](65..90) | Where-Object { $_ -cnotin 'I', 'O' })
        -join ([char[]](97..122) | Where-Object { $_ -cnotin 'l' })
        -join ([char[]](50..57))
        '-_.~!@#%^+='
    )
    $all = -join $classes
    $characters = [System.Collections.Generic.List[char]]::new()
    foreach ($class in $classes) {
        $characters.Add($class[[System.Security.Cryptography.RandomNumberGenerator]::GetInt32($class.Length)])
    }
    while ($characters.Count -lt $Length) {
        $characters.Add($all[[System.Security.Cryptography.RandomNumberGenerator]::GetInt32($all.Length)])
    }
    for ($index = $characters.Count - 1; $index -gt 0; $index--) {
        $swap = [System.Security.Cryptography.RandomNumberGenerator]::GetInt32($index + 1)
        $characters[$index], $characters[$swap] = $characters[$swap], $characters[$index]
    }
    -join $characters
}
