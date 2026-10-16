<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Languages/private/ConvertFrom-GoTestJson.ps1
    folder: private
    name: convert-from-go-test-json
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Languages
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.Languages/tests/ConvertFrom-GoTestJson.Tests.ps1
  config:
    synopsis: Turns a `go test -json` event stream (the test2json format) into one GoTestResult per top-level Go test.
    description: |-
      Reads the stream line by line; each line is one JSON event with an Action:

        run, pause, cont, start, bench   progress only;
        output                           a printed line, joined to its test (or to its package when it has no Test);
        pass, fail, skip                 a test's outcome and Elapsed seconds (or the package's, when it has no Test);
        build-output, build-fail         the compiler's output and verdict for a package that did not build.

      A subtest (Test 'TestWidget/case') folds into its top-level test: its output joins the parent's in event
      order, and go itself fails the parent when a subtest fails. A test that started but never reached an outcome
      (the test binary crashed) is a failure. Results come in the order the tests first ran.

      Throws, with the collected output, when a package failed to build (a build-fail event, or a package result
      naming FailedBuild) or failed outside any test (a failing package with no failing test: TestMain, an init, or
      a setup failure), and on a line that is not a JSON event.
    parameters:
      Text: The stdout of `go test -json`.
    outputs: '[Catzc.Base.Languages.GoTestResult] One record per top-level Go test.'
---
#>

function ConvertFrom-GoTestJson {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Languages.GoTestResult])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $Text
    )

    $tests = [ordered]@{}
    $packageOutput = @{}
    $failedPackages = [System.Collections.Generic.List[string]]::new()
    $buildOutput = [ordered]@{}
    $buildFailures = [System.Collections.Generic.List[string]]::new()

    foreach ($line in ($Text -split '\r?\n')) {
        if ([string]::IsNullOrWhiteSpace($line)) {
            continue
        }
        try {
            $record = ConvertFrom-Json -InputObject $line -AsHashtable -ErrorAction Stop
        }
        catch {
            throw "go test -json printed a line that is not a JSON event: $line"
        }
        if ($record -isnot [System.Collections.IDictionary] -or -not $record.ContainsKey('Action')) {
            throw "go test -json printed a line that is not a JSON event: $line"
        }

        $action = [string] $record['Action']
        $package = if ($record.ContainsKey('Package')) {
            [string] $record['Package']
        }
        else {
            ''
        }
        $output = if ($record.ContainsKey('Output')) {
            [string] $record['Output']
        }
        else {
            ''
        }

        # The compiler's events are keyed by ImportPath, not Package.
        if ($action -eq 'build-output' -or $action -eq 'build-fail') {
            $importPath = [string] $record['ImportPath']
            if (-not $buildOutput.Contains($importPath)) {
                $buildOutput[$importPath] = [System.Text.StringBuilder]::new()
            }
            if ($action -eq 'build-output') {
                $null = $buildOutput[$importPath].Append($output)
            }
            elseif (-not $buildFailures.Contains($importPath)) {
                $buildFailures.Add($importPath)
            }
            continue
        }

        $testName = if ($record.ContainsKey('Test')) {
            [string] $record['Test']
        }
        else {
            ''
        }

        if (-not $testName) {
            # A package-level event: its output, and its overall verdict.
            if (-not $packageOutput.ContainsKey($package)) {
                $packageOutput[$package] = [System.Text.StringBuilder]::new()
            }
            if ($action -eq 'output') {
                $null = $packageOutput[$package].Append($output)
            }
            elseif ($action -eq 'fail') {
                $failedPackages.Add($package)
                if ($record.ContainsKey('FailedBuild') -and $record['FailedBuild'] -and -not $buildFailures.Contains([string] $record['FailedBuild'])) {
                    $buildFailures.Add([string] $record['FailedBuild'])
                }
            }
            continue
        }

        # A test-level event: a subtest folds into its top-level test.
        $topName = $testName.Split('/')[0]
        $key = "$package`t$topName"
        if (-not $tests.Contains($key)) {
            $tests[$key] = @{
                Package = $package
                Name    = $topName
                Outcome = $null
                Elapsed = 0.0
                Output  = [System.Text.StringBuilder]::new()
            }
        }
        $test = $tests[$key]
        if ($action -eq 'output') {
            $null = $test.Output.Append($output)
        }
        elseif ($action -in 'pass', 'fail', 'skip' -and $testName -eq $topName) {
            $test.Outcome = $action
            if ($record.ContainsKey('Elapsed')) {
                $test.Elapsed = [double] $record['Elapsed']
            }
        }
    }

    if ($buildFailures.Count -gt 0) {
        $details = foreach ($importPath in $buildFailures) {
            $compiler = if ($buildOutput.Contains($importPath)) {
                $buildOutput[$importPath].ToString()
            }
            else {
                ''
            }
            "$importPath did not build:`n$compiler"
        }
        throw "go test: the test package did not build.`n$($details -join "`n")"
    }

    $results = foreach ($test in $tests.Values) {
        # A test that started but never reached an outcome died with its test binary.
        $outcome = if ($test.Outcome) {
            $test.Outcome
        }
        else {
            'fail'
        }
        [Catzc.Base.Languages.GoTestResult]::new($test.Package, $test.Name, $outcome, $test.Elapsed, $test.Output.ToString())
    }
    $results = @($results)

    foreach ($package in $failedPackages) {
        if (-not @($results | Where-Object { $_.Package -eq $package -and $_.Outcome -eq 'fail' }).Count) {
            throw "go test: package $package failed outside any test (TestMain, an init, or the test setup).`n$($packageOutput[$package].ToString())"
        }
    }

    $results
}
