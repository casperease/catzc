<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Languages/private/ConvertFrom-PytestJunit.ps1
    folder: private
    name: convert-from-pytest-junit
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Languages
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.Languages/tests/ConvertFrom-PytestJunit.Tests.ps1
    docs: "[ConvertFrom-PytestJunit.ps1.md](docs/references/pwsh/catzc-base-languages/private/ConvertFrom-PytestJunit.ps1.md)"
---
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
