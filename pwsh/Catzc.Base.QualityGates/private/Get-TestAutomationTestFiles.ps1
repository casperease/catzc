<#
---
catzc:
  immutable:
    with_body_sha: de57fc6c74a5
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-TestAutomationTestFiles.Tests.ps1
    docs: "[Get-TestAutomationTestFiles.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-TestAutomationTestFiles.ps1.md)"
---
#>

function Get-TestAutomationTestFiles {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string[]] $TestPath
    )

    $languageFolders = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($testFolder in @(Get-LanguageTestFolders)) {
        [void]$languageFolders.Add($testFolder.Folder)
    }

    $testFiles = [System.Collections.Generic.List[string]]::new()
    foreach ($testsPath in $TestPath) {
        if ($languageFolders.Contains($testsPath)) {
            $testFiles.Add($testsPath)
            continue
        }
        # Test files sit at most two levels below a tests folder (tests/types/); the third level is headroom.
        $files = @(Get-ChildPath $testsPath -File -Filter '*.Tests.ps1' -Depth 3)
        [Array]::Sort($files, [System.StringComparer]::Ordinal)
        foreach ($file in $files) {
            $testFiles.Add($file)
        }
    }
    if ($testFiles.Count -eq 0) {
        throw 'No test files found in the discovered tests folders.'
    }
    , $testFiles.ToArray()
}
