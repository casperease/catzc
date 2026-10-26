# pwsh/Base.QualityGates/types/FileCarrierResolver.cs

Finds the carrier entry of a repository path
([ADR-REPO-FILEMETA-KINDSCOPE](../../../../drs/repository/file-meta.md#rule-adr-repo-filemeta-kindscope)). Every glob is compiled once, so a
scan of all tracked files stays cheap.
