# automation/Catzc.Base.Asserts/Assert-PipelineCount.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Asserts the number of objects in the pipeline.

### description

Counts pipeline objects and validates against -Equals, -Minimum, or -Maximum.
Objects are passed through. Fails early when the count exceeds -Equals or -Maximum.

### parameter InputObject

Pipeline input (do not pass directly).

### parameter Equals

Exact expected count.

### parameter Minimum

Minimum acceptable count (inclusive).

### parameter Maximum

Maximum acceptable count (inclusive).

### example 1

```powershell
Get-Process | Assert-PipelineCount -Minimum 1
```

### example 2

```powershell
1..3 | Assert-PipelineCount 3
```
