# automation/Catzc.Base.Asserts/Assert-PipelineEmpty.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Asserts that the pipeline contains no objects.

### description

Throws on the first object received. Must be used as a pipeline consumer; passing -InputObject directly is an error.

### parameter `InputObject`

Pipeline input (do not pass directly).

### example 1

```powershell
Get-ChildPath $logFolder -File -Filter '*.log' | Assert-PipelineEmpty
```
