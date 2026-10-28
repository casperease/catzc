function Test-PythonTests {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    [Catzc.Base.Timeouts.TimeLimit(300, Pipeline = 900)]
    param(
        # The Python test folders to run, repository-relative; every Python test folder by default.
        [string[]] $Path,

        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    $repositoryRoot = Get-RepositoryRoot
    $known = @(Get-LanguageTestFolders | Where-Object { $_.Language -eq 'python' })
    $selected = @(if ($Path) {
            foreach ($item in $Path) {
                $full = [System.IO.Path]::GetFullPath($item, $repositoryRoot).TrimEnd('\', '/')
                $match = @($known | Where-Object {
                        [System.IO.Path]::GetFullPath($_.Folder).TrimEnd('\', '/') -ieq $full
                    })
                Assert-True ($match.Count -eq 1) `
                    -ErrorText "'$item' is not a Python test folder of a catzc module. The Python test folders are: $((@($known | ForEach-Object { [System.IO.Path]::GetRelativePath($repositoryRoot, $_.Folder).Replace('\', '/') })) -join ', ')."
                $match[0]
            }
        }
        else {
            $known
        })

    # The one runner the language bridge uses; it runs ruff and pytest in the managed uv and returns a result per test.
    $issues = [System.Collections.Generic.List[string]]::new()
    $tests = 0
    foreach ($folder in $selected) {
        $relative = [System.IO.Path]::GetRelativePath($repositoryRoot, $folder.Folder).Replace('\', '/')
        foreach ($result in @(Invoke-PythonTest -Module $folder.Module -Folder $folder.Folder)) {
            $tests++
            if ($result.Outcome -eq 'fail') {
                $first = ($result.Output -split '\r?\n' | Where-Object { $_.Trim() } | Select-Object -First 1)
                $issues.Add("${relative}: $($result.Package) $($result.Name) failed: $first")
            }
        }
    }

    Write-QualityGateReport -Subject python-tests -Title Test-PythonTests -Issues $issues.ToArray() `
        -Facts ([ordered]@{ Folders = $selected.Count; Tests = $tests }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
