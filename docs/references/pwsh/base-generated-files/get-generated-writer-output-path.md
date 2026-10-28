# pwsh/Base.GeneratedFiles/Get-GeneratedWriterOutputPath.ps1

The claim rule behind a regenerate command that names `{path}`, the due check and the tracked-path walk: of the candidate paths, the ones a
writer's outputs claim against every other writer's outputs.

## help

### synopsis

The candidate paths a writer row's outputs claim, in ordinal order.

### description

Every output glob of every row competes for each candidate path. The glob with the most literal characters (all but `*`, `?`, `[` and `]`)
claims it, and on a tie the writer named first: the writer itself, then the rows in their order. A path no output matches is dropped.

### parameter `WriterRow`

The writer row whose paths are wanted.

### parameter `Writers`

The rows of the registry, whose outputs compete for each path.

### parameter `Path`

The candidate repository-relative paths, with '/' or '\' separators.

### outputs

`[string]` Each claimed path, '/'-separated, in ordinal order.

### example 1

```powershell
Get-GeneratedWriterOutputPath -WriterRow $picture -Writers $rows -Path $tracked
```

## Why the most literal glob claims

Two rows may write into one folder, one glob inside the other: a picture writer's `*.png` matches the slides a render writer's `*.slide.png`
writes. The narrower glob names the file more exactly, and its writer is the one that makes it, so the glob with more literal characters
wins.
