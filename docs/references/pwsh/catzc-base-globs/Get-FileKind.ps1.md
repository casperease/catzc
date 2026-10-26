# pwsh/Base.Globs/Get-FileKind.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the kind of a file by its role, and its subkind when it has one, from the file-kinds registry.

### description

The kind is the role of the file and never its language, track or module, which are keys of their own. The first kind of the file-kinds
registry whose globs, or whose subkinds' globs, match the path names it, and a path no entry selects is `other`. The registry is local to
catzc and global to every file, and a consumer extends it with a config fragment
([ADR-REPO-FILEMETA-METAKIND](../../../drs/repository/file-meta.md#rule-adr-repo-filemeta-metakind)).

### parameter `Path`

A repository-relative path ('/' or '\' separated).

### outputs

`[Catzc.Base.Globs.FileKindMatch]` The kind, the subkind (null when none), the kind's definition, and Class, what a selector matches.

### example 1

```powershell
(Get-FileKind 'pwsh/Base.Variants/Test-GitWorkspace.ps1')   # -> Class function/gate
```

### example 2

```powershell
(Get-FileKind 'elsewhere/notes.txt').kind                                # -> other
```
