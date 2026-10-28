# pwsh/Base.GeneratedFiles/Get-GeneratedWriterDue.ps1

The command that judges which generated-file writers need to run again. It reads the writer rows of every module's `generated.yml`, through
`Get-GeneratedWriterOrder`, and answers one `GeneratedWriterDue` per writer.

## help

### synopsis

Says which generated-file writers are due: the one reading of the inputs and outputs of the writer rows.

### description

A writer is due when an output named without a wildcard is missing, or when the stamp of every file on disk its inputs match, salted with
the folders its wildcard inputs could write into, differs from the stamp stored after its last run. A pull, a drifted ignored file and a new
folder all change the stamp; a changed output alone never does. A missing or unreadable memo makes every writer due. A writer's inputs are
its own `inputs` and those of each of its outputs; every writer row declares at least one output, so git is never read. Test-GeneratedFiles
-Changed and the import janitors both ask here, so what a writer depends on is declared once, in the `generated.yml` of its module.

### parameter `Name`

The writers to judge, as the writer rows name them. The walk then reaches only their inputs. Default: every writer.

### parameter `RepositoryRoot`

The root the inputs are walked and a missing output is looked for under. Default: the repository root.

### parameter `MemoPath`

The memo of the stamps each writer stored after its last run (Save-GeneratedWriterStamp). Default: out/cache/generated-writers.json.

### outputs

`[Catzc.Base.GeneratedFiles.GeneratedWriterDue]` One per writer of the registry, in render order: Name and Due.

### example 1

```powershell
Get-GeneratedWriterDue | Where-Object Due
```

## Why a dirty tree is not enough

A dirty tree is not a stale output: a writer is due when a literal output is missing, or when the stamp of every file its inputs match
differs from the one stored after its last run (`Save-GeneratedWriterStamp`). A missing or unreadable memo makes every writer due. The input
files are walked once for all writers, and git is never read.
