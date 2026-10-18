# pwsh/Catzc.Base.Languages/Format-GeneratedFileHead.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the text of a generated file with the meta head that says which generator or source wrote it.

### description

The head is the one unified form of ADR-REPO-FILEMETA#7: the kind of the file by its role, and its subkind when it has one, as the caller
read them from the file-kinds registry; the file language, the file type (extension), the track and the module when the file has them; and
the generator and the source when the file has them. The generator is written as the path of the file its command is defined in. The head
opens with the hash of the body below it, read through the carrier so a head already in the text never moves it, and a tracked generated
file of any language says which text its writer composed. The carrier is named by id, or found from the file's language when no id is given.

### parameter `Text`

The whole content the generator composed, without any head.

### parameter `Path`

The repository-relative path the content is written to. It names the file in the head and finds its language.

### parameter `Carrier`

The id of the file-carriers entry that says where the head goes. Default: the entry of the file language of Path.

### parameter `Generator`

The command that composed the content, when one did; the head names the path of its file.

### parameter `Source`

The repository-relative authored file or files the content comes from, when it has any.

### parameter `InputsSha`

The stamp (Get-InputStamp) of every input the generator read, when it skips an unchanged build; the head carries it as with_inputs_sha,
which Test-GeneratedFileCurrent compares. Default: none, and the key is left out.

### parameter `FileKind`

The kind of Path by its role: what Get-FileKind returns for it (kind, and subkind when it has one). The caller reads it, since the registry
lives in a module this one cannot depend on.

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
Format-GeneratedFileHead -Text $content -Path .gitignore -Carrier dotfile -Generator New-GitIgnore -FileKind (Get-FileKind .gitignore)
```
