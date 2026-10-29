function Get-TestRunEntryLine {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [string] $EntryScript,

        [hashtable] $EntryParameter = @{}
    )

    # The one seam between the runs: the repository importer, or the build's Import-Catzc.ps1.
    if ($EntryScript) {
        $entryArguments = foreach ($name in (@($EntryParameter | Where-Object { $_ } | ForEach-Object Keys) | Sort-Object)) {
            $value = $EntryParameter[$name]
            if ($value -is [bool] -or $value -is [switch]) {
                if ($value) {
                    "-$name"
                }
            }
            else {
                "-$name '$("$value" -replace "'", "''")'"
            }
        }
        (@(". '$($EntryScript -replace "'", "''")'") + @($entryArguments)) -join ' '
    }
    else {
        ". '$(Get-RepositoryRoot)/importer.ps1' -SkipJanitors"
    }
}
