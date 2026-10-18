# automation/Catzc.Base.QualityGates/private/Get-FileMetaScope.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists the tracked files that carry a meta block, each with the carrier entry that says where it goes.

### description

A file is in scope when its class has a front-matter or comment-head carrier, the class does not leave it out, an imprint kind's
globs match it, and `.gitattributes` does not exempt it or opt it out.

### parameter RepositoryRoot

The repository root the returned paths are relative to.

### parameter Path

Optional files or folders (absolute or relative to the current location) to limit the scope to.

### parameter Config

The meta-kind registry.

### parameter Resolver

The carrier resolver. Default: built from the shipped file-carriers and languages registries.

### outputs

`[pscustomobject]` @{ Path; Carrier } per file, Path repository-relative and '/'-separated, in git's order.
