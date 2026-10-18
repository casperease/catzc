# automation/Catzc.Base.QualityGates/private/Get-FileLanguageFileMetaFact.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The file-language meta kind's fact: the file language of the file, from the languages registry.

### description

The language is the one whose extensions list the file's own, as Get-FileLanguage reads it; the languages are data in the registry, never a
list in this function ([ADR-PRIN-CONFIG#1](../../../../adr/principles/configure-not-program.md#rule-adr-prin-config1)). A file no language
lists, such as a dotfile, gets an empty value, so the key is left out of its head.

It rests on [ADR-REPO-FILEMETA#3](../../../../adr/repository/file-meta.md#rule-adr-repo-filemeta3).

### parameter `State`

What Get-MarkdownMetaState read from the file.

### parameter `Path`

The file's repository-relative path.

### parameter `Kind`

The registry entry that subscribed this function.

### outputs

`[System.Collections.Specialized.OrderedDictionary]` one entry per key of the kind.
