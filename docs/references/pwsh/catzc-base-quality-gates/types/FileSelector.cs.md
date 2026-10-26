# pwsh/Base.QualityGates/types/FileSelector.cs

Selects files by class. A file's class is its kind, or `kind/subkind`.

## Class patterns

`ClassMatches` takes a class name, or a name with one `*` standing for any run of characters. A pattern without a `/` names the kind, so it
selects the kind whatever its subkind. A pattern with one names a subkind.
