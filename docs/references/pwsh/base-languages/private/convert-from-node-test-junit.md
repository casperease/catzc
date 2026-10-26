# pwsh/Base.Languages/private/ConvertFrom-NodeTestJunit.ps1

`ConvertFrom-NodeTestJunit` is the private reader `Invoke-JavaScriptTest` uses on the JUnit report of node's test runner. It turns each
`testcase` into a `JavaScriptTestResult`.

## help

### synopsis

Reads node's test runner JUnit report into one JavaScript test result per test case.

### description

Each `testcase` becomes a result named by its test file, relative to the folder the run was given, and its test name, with its outcome
(`fail` for a failure or an error, `skip` for a skipped case, else `pass`), its seconds, and the messages and text of its failure or skip as
its output. An empty report yields nothing.

A case outside any `*.test.js` file, or one with no name, is node failing around the tests, such as a test file that does not load: it is
never a result, and the call throws, naming every such case, once the report is read.

### parameter `Text`

The JUnit XML node's runner wrote, which may be empty.

### parameter `Folder`

The test folder the run was given; each case's file is named relative to it.

### outputs

`[Catzc.Base.Languages.JavaScriptTestResult]` One result per test case, in the report's order.

### example 1

```powershell
ConvertFrom-NodeTestJunit -Text (Get-Content -Raw out/node-test.xml) -Folder js/widget-lamps/tests
```
