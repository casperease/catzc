# pwsh/Base.Asserts/Assert-PipelineCount.ps1

A pass-through pipeline stage that counts what flows by and throws when the count misses an exact, minimum or maximum bound.

## help

### synopsis

Asserts the number of objects in the pipeline.

### description

Counts pipeline objects and validates against -Equals, -Minimum, or -Maximum. Objects are passed through. Fails early when the count exceeds
-Equals or -Maximum.

### parameter `InputObject`

Pipeline input (do not pass directly).

### parameter `Equals`

Exact expected count.

### parameter `Minimum`

Minimum acceptable count (inclusive).

### parameter `Maximum`

Maximum acceptable count (inclusive).

### example 1

```powershell
Get-Process | Assert-PipelineCount -Minimum 1
```

### example 2

```powershell
1..3 | Assert-PipelineCount 3
```
