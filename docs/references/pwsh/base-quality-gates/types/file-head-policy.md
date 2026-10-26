# pwsh/Base.QualityGates/types/FileHeadPolicy.cs

The head policy of the meta-kind registry: whether a file of a class carries the facts its kinds produce, no meta block, or only its
authored config part ([ADR-REPO-FILEMETA-HEADPOLICY](../../../../drs/repository/file-meta.md#rule-adr-repo-filemeta-headpolicy)).

## Lookup

`For` takes a file class. A class entry decides first, else the default applies: the facts. So a file whose facts are all empty carries no
head.
