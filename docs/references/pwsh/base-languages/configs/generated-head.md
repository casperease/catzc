# pwsh/Base.Languages/configs/generated-head.yml

The keys of the generated-file head, in writing order, and the regenerate template a writer row fills. `Format-GeneratedFileHead` reads them
to compose the head of a generated file
([ADR-REPO-FILEMETA-COMPOSEDFILES](../../../../drs/repository/file-meta.md#rule-adr-repo-filemeta-composedfiles)).

## Order

The do-not-edit warning opens the head; while git tracks the file the `regenerate` command follows it, and the hash of the body below the
head closes it. The type fixes this one order, so a config that lists the keys in any other refuses to load. What a file comes from and what
a roll-off takes are the writer registry's to answer, so the head names neither.

## Templates

`regenerate` is declared once here and filled from the writer row: `{writer}` is the row's name and `{path}` the file's repository path. A
writer row's own `regenerate` replaces the template where its call differs. The template names `{path}` and no placeholder but `{writer}`
and `{path}`.
