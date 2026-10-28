# pwsh/Base.Languages/Format-GeneratedFileHead.ps1

`Format-GeneratedFileHead` composes the content of a generated file with its stamp: the do-not-edit warning and, while git tracks the file,
the command that renders it again and the hash of the body. Every writer stamps through it, and a writer outside PowerShell through
`Set-GeneratedFileHead`, so every generated file carries the same head.

## help

### synopsis

Returns the content of a generated file with the stamp that tells a reader not to edit it and how it is rendered again.

### description

The head is the one form of ADR-REPO-FILEMETA-COMPOSEDFILES: the do-not-edit warning, and, while git tracks the file, the regenerate command
filled from the writer row, then the hash of the body below it, read through the carrier so a head already in the content never moves it. An
untracked generated file carries the warning only. The carrier is named by id, or found by the file-carriers entry whose globs take the
path, then by the file's language, when no id is given. A png carries the head in a tEXt chunk keyed catzc, an svg in a metadata element and
an xml file in a catzc processing instruction (ADR-REPO-FILEMETA-EVERYFORMATCARRIES).

### parameter `Text`

The whole content the generator composed, for every carrier but a png.

### parameter `Bytes`

The whole image the generator rendered, for a png carrier.

### parameter `Path`

The repository-relative path the content is written to. It finds the file's language and whether git tracks it.

### parameter `Carrier`

The id of the file-carriers entry that says where the head goes, for a config that names it, such as a rootconfig.yml entry. Default: the
entry whose globs take Path, else the entry of its file language.

### parameter `Writer`

The name of the writer in the registry, as its row in the module's generated.yml names it. On a tracked file its row is read: its name and
the regenerate template of generated-head.yml, or the row's own regenerate, fill the regenerate command. Default: none, so the head holds no
command.

### parameter `Carriers`

The carrier registry. Default: the shipped file-carriers.yml.

### parameter `Languages`

The file-language registry. Default: the shipped languages.yml.

### parameter `Head`

The head keys in writing order. Default: the shipped generated-head.yml.

### outputs

`[string]` The text with the head written into its carrier, or `[byte[]]` the image with its stamp chunk.

### example 1

```powershell
Format-GeneratedFileHead -Text $content -Path docs/drs/index.md -Writer Build-DrsIndex
```

## Idempotence

The body is what sits below the head the carrier holds, so a second run over the written file finds the same hash and a head already in the
text never moves it.

## Tracked or not

While git tracks the file, the head also carries the hash of the body it is immutable with; an untracked file carries the warning only.
