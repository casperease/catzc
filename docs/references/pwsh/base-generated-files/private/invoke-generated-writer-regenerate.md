# pwsh/Base.GeneratedFiles/private/Invoke-GeneratedWriterRegenerate.ps1

The private run behind `Restore-Generated` for a writer that is no command of the session: it runs the `regenerate` command of the writer's
row, through the managed tool its first word names.

## help

### synopsis

Runs a writer row's regenerate command, once, once per output path when the command names `{path}`, or once with every output path when
it names `{paths}`.

### description

The first word of the command line names a tool `tools.yml` declares, run by its managed path from `Resolve-ToolExecutable`; the rest are
its arguments, so no free text is evaluated. `Invoke-Executable` runs each command from the repository root, bounded by the tool's time
limit. A command that names `{path}` runs once per output the writer claims (`Get-GeneratedWriterOutputPath`), in ordinal order, the path
quoted in place of `{path}`. A command that names `{paths}` runs once, every output the writer claims quoted in ordinal order in place of
`{paths}`, so a writer that pays a start-up per run, such as a cats import to stamp its heads, pays it once; with no output claimed it does
not run. A failed run throws, naming the writer, the command and its output.

### parameter `Writer`

The writer row whose regenerate command runs.

### parameter `Writers`

The rows of the registry, whose outputs compete for each path.

### parameter `RepositoryRoot`

The root the commands run from, and the outputs on disk are looked for under.

### outputs

None.

### example 1

```powershell
Invoke-GeneratedWriterRegenerate -Writer $row -Writers $rows -RepositoryRoot $root
```

## Why the paths come from the git index

`{path}` is the output file, as in the generated-file head the row's command fills, where `{paths}` names that one file too. After `Remove-Generated` the outputs are gone, so a walk
of the disk finds none; the git index still names every committed output, and the disk adds one not yet committed. The index is read at the
session's repository root.
