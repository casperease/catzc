# pwsh/Base.Languages/types/PathParts.cs

The parts of a path under its module ([ADR-REPO-FILEMETA-ROLE](../../../../drs/repository/file-meta.md#rule-adr-repo-filemeta-role)): an
optional folder, a kebab-case name and a file type, and only that.

## Of

`Of(tail)` splits a path under its module, separated by forward or back slashes (the whole path for a file in no module), and asserts that
the three parts build the path back: the folders, the name and the file type, compared as kebab case.
