# automation/Catzc.Base.Git/Import-RepositoryWithHistory.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Imports an outside repository with its full history at one landing address under the unordered track.

### description

An import ([ADR-DSGN-TRACK#17](../../../adr/design/tracks.md#rule-adr-dsgn-track17)): every commit of the source ref becomes part of this
repository's history, and the source's files land at the landing address `<unordered>/<name>`, where `<unordered>` is the place of the track
of type `unordered`. Nothing outside the address changes; sorting the files into their modules is a later `git mv`, one file or folder at a
time.

The name resolves once ([ADR-AUTO-DEFAULT#6](../../../adr/automation/sensible-defaults.md#rule-adr-auto-default6)): -Name when given, else
the source's folder or repository name in kebab case. A name that is not a short kebab word fails, a taken address fails, and no suffix is
ever added. Every precondition is asserted before anything is written
([ADR-AUTO-FAILFAST#3](../../../adr/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast3)): git is present, the target has nothing
staged, and a source given as a path is a git repository with a clean working tree.

The history is joined by a subtree merge in core git: the source ref is fetched, its tree is read in under the address, and one merge commit
records both parents, so `git log` reaches every source commit.

It rests on [ADR-AUTO-DRYRUN#2](../../../adr/automation/dry-run.md#rule-adr-auto-dryrun2).

### parameter Source

The repository to import, a local path or a URL.

### parameter Name

The landing name, a short kebab word. Default: the source's folder or repository name in kebab case.

### parameter Ref

The source ref to import. Default: the source's default branch (its HEAD).

### parameter RepositoryRoot

The repository the import lands in. Default: the loaded repository root.

### parameter DryRun

Resolve and check everything, report the landing address, and write nothing.

### outputs

`[pscustomobject]` @{ Name; Address; Source; Ref; Commits } — Commits is $null with -DryRun.

### example 1

```powershell
Import-RepositoryWithHistory -Source C:\projects\widget-tools
```

### example 2

```powershell
Import-RepositoryWithHistory -Source https://example.com/gadget.git -Name gadget -Ref release
```

### example 3

```powershell
Import-RepositoryWithHistory -Source C:\projects\widget-tools -DryRun
```
