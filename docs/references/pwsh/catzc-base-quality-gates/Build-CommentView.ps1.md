# pwsh/Catzc.Base.QualityGates/Build-CommentView.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Writes the annotated view: every file that has a comment page, with each section of the page put back above the code line it names.

### description

The inverse of Export-Comments. A file keeps no long comment and the prose lives once, in the file's comment page
([PDR-ONELIVE-ONEVERSION](../../../drs/principles/one-living-version.md#rule-pdr-onelive-oneversion)); the view is the generated, gitignored
copy a reader or an agent opens to see a file with its comments inline. It is written under comments.yml's `view` folder in out/
([ADR-REPO-OUTDIR-OUTPUTROOTFUNCTION](../../../drs/repository/dedicated-output-directory.md#rule-adr-repo-outdir-outputrootfunction)), at
the file's own repository path, so `out/annotated/<path>` is the annotated `<path>`. Only files whose view differs from the file get one; a
section whose code line is gone is left out (Test-Comments reports it).

Idempotent: a view whose content is current is not rewritten (Write-FileIfChanged), so a second run is a fast no-op. A source-tree tool: it
throws in build mode (Assert-SourceTree).

### parameter `Path`

Files or folders to build the view of. Default: every file in scope.

### parameter `RepositoryRoot`

The repository root paths, pages and the view folder resolve against. Default: the loaded repository root.

### parameter `DryRun`

Report which views would change without writing them.

### outputs

`[string[]]` the view files written (or, under -DryRun, that would be), repository-relative.

### example 1

```powershell
Build-CommentView
```

### example 2

```powershell
Build-CommentView -Path pwsh/Catzc.Base.Files
```
