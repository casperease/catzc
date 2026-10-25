<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-languages/private/ConvertFrom-NodeTestJunit.ps1.md"
  header: "generated"
---
#>

function ConvertFrom-NodeTestJunit {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Languages.JavaScriptTestResult])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $Text,

        # The test folder the run was given; each case's file is named relative to it.
        [Parameter(Mandatory)]
        [string] $Folder
    )

    if (-not $Text.Trim()) {
        return
    }
    $document = [System.Xml.XmlDocument]::new()
    $document.LoadXml($Text)

    $outsideTests = [System.Collections.Generic.List[string]]::new()
    $results = [System.Collections.Generic.List[Catzc.Base.Languages.JavaScriptTestResult]]::new()
    foreach ($case in $document.SelectNodes('//testcase')) {
        $file = $case.GetAttribute('file')
        $name = $case.GetAttribute('name')
        $failure = $case.SelectSingleNode('failure|error')
        $skipped = $case.SelectSingleNode('skipped')

        $output = [System.Collections.Generic.List[string]]::new()
        foreach ($node in @($failure, $skipped)) {
            if ($null -ne $node) {
                $message = $node.GetAttribute('message')
                if ($message -and $message -ne 'true') {
                    $output.Add($message)
                }
                if ($node.InnerText.Trim()) {
                    $output.Add($node.InnerText.Trim())
                }
            }
        }

        # A case outside any test file is node failing around the tests (a file that does not load).
        $package = if ($file) {
            [System.IO.Path]::GetRelativePath($Folder, $file).Replace('\', '/')
        }
        if (-not $package -or -not $package.EndsWith('.test.js', [System.StringComparison]::Ordinal) -or -not $name.Trim()) {
            $outsideTests.Add("$file $name`n$($output -join "`n")")
            continue
        }
        $outcome = if ($null -ne $failure) {
            'fail'
        }
        elseif ($null -ne $skipped) {
            'skip'
        }
        else {
            'pass'
        }
        $seconds = 0.0
        $null = [double]::TryParse($case.GetAttribute('time'), [System.Globalization.NumberStyles]::Float, [System.Globalization.CultureInfo]::InvariantCulture, [ref] $seconds)
        $results.Add([Catzc.Base.Languages.JavaScriptTestResult]::new($package, $name.Trim(), $outcome, $seconds, ($output -join "`n")))
    }

    if ($outsideTests.Count -gt 0) {
        throw "node reported a failure outside any test:`n$($outsideTests -join "`n")"
    }
    $results
}
