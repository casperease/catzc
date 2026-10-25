# pwsh/Catzc.Base.Languages/Format-GeneratedFileHead.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the text of a generated file with the meta head that tells a reader not to edit it.

### description

The head is the one form of ADR-REPO-FILEMETA-COMPOSEDFILES: the do-not-edit warning, and, while git tracks the file, the hash of the body
below it, read through the carrier so a head already in the text never moves it. An untracked generated file carries the warning only. The
carrier is named by id, or found from the file's language when no id is given.

### parameter `Text`

The whole content the generator composed, without any head.

### parameter `Path`

The repository-relative path the content is written to. It finds the file's language and whether git tracks it.

### parameter `Carrier`

The id of the file-carriers entry that says where the head goes. Default: the entry of the file language of Path.

### parameter `Carriers`

The carrier registry. Default: the shipped file-carriers.yml.

### parameter `Languages`

The file-language registry. Default: the shipped languages.yml.

### parameter `Head`

The head keys in writing order. Default: the shipped generated-head.yml.

### outputs

`[string]` The text with the head written first.

### example 1

```powershell
Format-GeneratedFileHead -Text $content -Path .gitignore -Carrier dotfile
```
