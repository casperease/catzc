# pwsh/Base.GeneratedFiles/private/Get-GeneratedWriterOrder.ps1

The private function that reads every module's writer rows and answers them in the order they render in.

## help

### synopsis

The writer rows of every module's generated.yml, in render order.

### description

Reads the `generated` config of every module that owns one and hands the rows to `GeneratedFilesConfig.RenderOrder`, which sorts them by
their input and output globs: a writer comes after every writer one of whose output globs overlaps one of its input globs, and writers that
wait on nothing come by name. A writer whose own output matches its own input is no edge. A cycle between writers throws, naming them
(ADR-REPO-ROOTCFG-DERIVEDRENDERORDER).

### outputs

`[Catzc.Base.Variants.GeneratedWriterRow]` One per writer of the registry, in render order.

### example 1

```powershell
Get-GeneratedWriterOrder | ForEach-Object name
```

## Why the order is sorted each time

The order is a fact of the inputs and outputs, so it is derived from the registry on each call and never listed by hand; a list kept by hand
would drift the first time a writer gains an input.
