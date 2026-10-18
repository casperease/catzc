# automation/Catzc.Base.Languages/private/ConvertFrom-PytestJunit.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Turns pytest's JUnit XML report into one PythonTestResult per top-level test function.

### description

Reads every `<testcase>` of the report. Its classname is the test file's module path inside the test folder (test_widget, or
nested.test_widget, with pytest's rootdir set to that folder) and its name the test, with a parametrisation suffix (`test_x[a]`) for a
parametrised case. The cases of one function fold into one result, as Go folds subtests into their test:

```text
outcome   fail when any case failed or errored; skip when every case skipped; pass otherwise;
duration  the sum of the cases' times;
output    every case's failure, error and skip message and text, and its captured output, in report order.
```

Results come in report order of each function's first case. A case outside any function (a module-level collection error, whose name is not
a test name) is not a test result: the call throws with its message, as Invoke-GoTest throws when a package fails outside any test.

### parameter Text

The JUnit XML report pytest wrote with --junitxml.

### outputs

`[Catzc.Base.Languages.PythonTestResult]` One record per top-level test function.

### example 1

```powershell
ConvertFrom-PytestJunit -Text (Get-Content -Raw $reportPath)
```
