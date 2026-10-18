# automation/Catzc.Base.QualityGates/private/Invoke-FileMetaEngine.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Computes the meta block of every in-scope file — the one place Format-FileMeta and Test-FileMeta share.

### description

Each file's `immutable` and `edges` parts are rebuilt from the imprint kinds of the registry, and its authored `config` part is kept as
written. A file whose block holds a key no kind owns is reported as Unowned and left unchanged, since writing it would drop the author's key
([ADR-REPO-FILEMETA#5](../../../../adr/repository/file-meta.md#rule-adr-repo-filemeta5)).

### parameter RepositoryRoot

The repository root paths are relative to.

### parameter Path

Optional files or folders to limit the scope to.

### parameter Config

The meta-kind registry. Default: the shipped one.

### parameter Entry

The files to check, each { Path; Carrier }, instead of the scope git and the registries give.

### outputs

`[pscustomobject]` @{ FileCount; Files } — Files holds every file with a finding: @{ Path; Findings; Fixed }, each finding @{ Path; Line;
Kind; Actual; Expected }.
