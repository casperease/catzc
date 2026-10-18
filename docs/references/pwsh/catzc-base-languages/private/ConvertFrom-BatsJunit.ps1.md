# automation/Catzc.Base.Languages/private/ConvertFrom-BatsJunit.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Turns the bats JUnit report into one BashTestResult per Bash test.

### description

Reads every `<testcase>` of the report bats writes with --report-formatter junit. Its classname is the .bats file's path inside the test
folder bats ran ('/'-separated: repository.bats, or nested/widget.bats) and its name the @test name:

```text
outcome   fail when the case has a <failure> or <error>; skip when it has <skipped>; pass otherwise;
duration  the case's time;
output    the failure, error or skip text (bats folds the test's output into it), and any system-out or
          system-err.
```

Results come in report order. A case outside any .bats file (a classname that is no .bats path) is not a test result: the call throws with
its text, as Invoke-GoTest throws when a package fails outside any test.

### parameter `Text`

The JUnit XML report bats wrote.

### outputs

`[Catzc.Base.Languages.BashTestResult]` One record per Bash test.

### example 1

```powershell
ConvertFrom-BatsJunit -Text (Get-Content -Raw $reportPath)
```
