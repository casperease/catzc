# pwsh/.internal/tests/Test-IsRunningInPipeline.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-IsRunningInPipeline'`, written with `#`.

```text
Test-IsRunningInPipeline lives in Catzc.Internal.Loader, which both run modes import first and keep loaded, so
no import is needed here. Each case sets the detection variables and restores them after.
```
