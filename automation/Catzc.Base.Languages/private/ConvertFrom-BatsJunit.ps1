<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Languages/private/ConvertFrom-BatsJunit.ps1
    kind: private-function
    module: Catzc.Base.Languages
    visibility: private
    adrs: []
---
#>

<#
.SYNOPSIS
    Turns the bats JUnit report into one BashTestResult per Bash test.
.DESCRIPTION
    A case whose classname is no .bats path is not a test result, so the call throws with its text.
.PARAMETER Text
    The JUnit XML report bats wrote.
.OUTPUTS
    [Catzc.Base.Languages.BashTestResult] One record per Bash test.
.EXAMPLE
    ConvertFrom-BatsJunit -Text (Get-Content -Raw $reportPath)
#>
function ConvertFrom-BatsJunit {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Languages.BashTestResult])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $Text
    )

    if (-not $Text.Trim()) {
        return
    }
    $document = [System.Xml.XmlDocument]::new()
    $document.LoadXml($Text)

    $outsideTests = [System.Collections.Generic.List[string]]::new()
    $results = [System.Collections.Generic.List[Catzc.Base.Languages.BashTestResult]]::new()
    foreach ($case in $document.SelectNodes('//testcase')) {
        $package = $case.GetAttribute('classname')
        $name = $case.GetAttribute('name')
        $failure = $case.SelectSingleNode('failure|error')
        $skipped = $case.SelectSingleNode('skipped')

        $output = [System.Collections.Generic.List[string]]::new()
        foreach ($node in @($failure, $skipped)) {
            if ($null -ne $node) {
                $message = $node.GetAttribute('message')
                if ($message) {
                    $output.Add($message)
                }
                if ($node.InnerText.Trim()) {
                    $output.Add($node.InnerText.Trim())
                }
            }
        }
        foreach ($stream in $case.SelectNodes('system-out|system-err')) {
            if ($stream.InnerText.Trim()) {
                $output.Add($stream.InnerText.Trim())
            }
        }

        if (-not $package.EndsWith('.bats', [System.StringComparison]::Ordinal) -or -not $name.Trim()) {
            $outsideTests.Add("$package $name`n$($output -join "`n")")
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
        $results.Add([Catzc.Base.Languages.BashTestResult]::new($package, $name.Trim(), $outcome, $seconds, ($output -join "`n")))
    }

    if ($outsideTests.Count -gt 0) {
        throw "bats reported a failure outside any test:`n$($outsideTests -join "`n")"
    }
    $results
}
