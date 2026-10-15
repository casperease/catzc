<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Languages/private/ConvertFrom-PytestJunit.ps1
    kind: function
    module: Catzc.Base.Languages
    visibility: private
    adrs: []
---
#>

<#
.SYNOPSIS
    Turns pytest's JUnit XML report into one PythonTestResult per top-level test function.
.DESCRIPTION
    The cases of one function fold into one result; a case outside any function throws with its message.
.PARAMETER Text
    The JUnit XML report pytest wrote with --junitxml.
.OUTPUTS
    [Catzc.Base.Languages.PythonTestResult] One record per top-level test function.
.EXAMPLE
    ConvertFrom-PytestJunit -Text (Get-Content -Raw $reportPath)
#>
function ConvertFrom-PytestJunit {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Languages.PythonTestResult])]
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

    $order = [System.Collections.Generic.List[string]]::new()
    $byKey = @{}
    $outsideTests = [System.Collections.Generic.List[string]]::new()
    foreach ($case in $document.SelectNodes('//testcase')) {
        $package = $case.GetAttribute('classname')
        $rawName = $case.GetAttribute('name')
        $name = ($rawName -split '\[', 2)[0]
        $failure = $case.SelectSingleNode('failure|error')
        $skipped = $case.SelectSingleNode('skipped')

        $caseOutput = [System.Collections.Generic.List[string]]::new()
        foreach ($node in @($failure, $skipped)) {
            if ($null -ne $node) {
                $message = $node.GetAttribute('message')
                if ($message) {
                    $caseOutput.Add($message)
                }
                if ($node.InnerText.Trim()) {
                    $caseOutput.Add($node.InnerText.Trim())
                }
            }
        }
        foreach ($stream in $case.SelectNodes('system-out|system-err')) {
            if ($stream.InnerText.Trim()) {
                $caseOutput.Add($stream.InnerText.Trim())
            }
        }

        if (-not $package -or $name -cnotmatch '^test\w*$') {
            $outsideTests.Add("$package $rawName`n$($caseOutput -join "`n")")
            continue
        }

        $key = "$package $name"
        if (-not $byKey.ContainsKey($key)) {
            $order.Add($key)
            $byKey[$key] = [pscustomobject]@{ Package = $package; Name = $name; Failed = $false; Cases = 0; Skipped = 0; Seconds = 0.0; Output = [System.Collections.Generic.List[string]]::new() }
        }
        $entry = $byKey[$key]
        $entry.Cases++
        if ($null -ne $failure) {
            $entry.Failed = $true
        }
        elseif ($null -ne $skipped) {
            $entry.Skipped++
        }
        $seconds = 0.0
        if ([double]::TryParse($case.GetAttribute('time'), [System.Globalization.NumberStyles]::Float, [System.Globalization.CultureInfo]::InvariantCulture, [ref] $seconds)) {
            $entry.Seconds += $seconds
        }
        foreach ($line in $caseOutput) {
            $entry.Output.Add($line)
        }
    }

    if ($outsideTests.Count -gt 0) {
        throw "pytest reported a failure outside any test:`n$($outsideTests -join "`n")"
    }

    foreach ($key in $order) {
        $entry = $byKey[$key]
        $outcome = if ($entry.Failed) {
            'fail'
        }
        elseif ($entry.Skipped -eq $entry.Cases) {
            'skip'
        }
        else {
            'pass'
        }
        [Catzc.Base.Languages.PythonTestResult]::new($entry.Package, $entry.Name, $outcome, $entry.Seconds, ($entry.Output -join "`n"))
    }
}
