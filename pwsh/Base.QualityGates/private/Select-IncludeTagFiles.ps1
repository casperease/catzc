function Select-IncludeTagFiles {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $TestFile,

        [Parameter(Mandatory)]
        $Discovery,

        [Parameter(Mandatory)]
        [string[]] $Tag,

        [AllowEmptyCollection()]
        [string[]] $ExcludeTag = @()
    )

    $tagged = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($test in @($Discovery.Tests)) {
        # The test's run file: its test file, or the Go test folder of a Go bridge test.
        $file = Get-TestRunFile -Test $test
        if (-not $file -or -not (Test-TestInRunScope -Test $test -ExcludeTag $ExcludeTag)) {
            continue
        }
        if ((Get-TestBlockTag -Test $test -Valid $Tag).Count -gt 0) {
            [void]$tagged.Add($file)
        }
    }

    @($TestFile | Where-Object { $tagged.Contains($_) })
}
