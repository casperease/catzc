# pwsh/Base.GeneratedFiles/configs/generated-files.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `writers:`, written with `#`.

```text
The writers Test-GeneratedFiles runs report-only (ADR-AUTO-TEST-QUALITYGATE); a file result names its stale file in the property result_path
(default Path). The generators of the managed root files are the generator keys of rootconfig.yml, so they are never listed here.
A writer with at_import true is re-rendered by the import when its lists make it due, in the order of this file (default: false); the
importer holds no writer list of its own. Optional inputs and outputs are repo-relative globs of what a writer reads and writes: with -Changed its dry run runs when a changed path
matches one of them, and a writer with neither list runs whenever anything changed (default: none). Build-RootConfig lists neither: its generators live in several modules and its output set is every opted-in root file, so it
runs whenever anything changed.
```

## comment:2

Above `inputs:` (occurrence 2), written with `#`.

```text
Its generators, its sources (rootconfig.yml's source and sources) and its targets: a drifted target, ignored or not, is an input
change, so the run that writes it back is due.
```
