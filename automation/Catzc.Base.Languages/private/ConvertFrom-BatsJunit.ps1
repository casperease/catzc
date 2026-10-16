<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Languages/private/ConvertFrom-BatsJunit.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Languages
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: private
    relatives:
      test: automation/Catzc.Base.Languages/tests/ConvertFrom-BatsJunit.Tests.ps1
  config:
    synopsis: Turns the bats JUnit report into one BashTestResult per Bash test.
    description: |-
      Reads every <testcase> of the report bats writes with --report-formatter junit. Its classname is the .bats file's
      path inside the test folder bats ran ('/'-separated: repository.bats, or nested/widget.bats) and its name the
      @test name:

        outcome   fail when the case has a <failure> or <error>; skip when it has <skipped>; pass otherwise;
        duration  the case's time;
        output    the failure, error or skip text (bats folds the test's output into it), and any system-out or
                  system-err.

      Results come in report order. A case outside any .bats file (a classname that is no .bats path) is not a test
      result: the call throws with its text, as Invoke-GoTest throws when a package fails outside any test.
    parameters:
      Text: The JUnit XML report bats wrote.
    outputs: '[Catzc.Base.Languages.BashTestResult] One record per Bash test.'
    examples:
      - ConvertFrom-BatsJunit -Text (Get-Content -Raw $reportPath)
---
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
