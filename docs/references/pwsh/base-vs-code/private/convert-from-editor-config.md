# pwsh/Base.VSCode/private/ConvertFrom-EditorConfig.ps1

The private converter of an `.editorconfig` into VS Code settings, so the editor follows the one file the formatters read.

## help

### synopsis

Renders an .editorconfig's settings as VS Code settings, so the editor follows the one file the formatters read.

### description

Each recognised key becomes its VS Code setting: `indent_style` → `editor.insertSpaces`, `indent_size` → `editor.tabSize`,
`trim_trailing_whitespace` → `files.trimTrailingWhitespace`, `insert_final_newline` → `files.insertFinalNewline`, `end_of_line` →
`files.eol`, `charset` → `files.encoding`, `max_line_length` → `editor.rulers`. The root section (`[*]`) writes its settings bare; a section
whose glob the map names writes them into each of its languages' `[<id>]` blocks, with `editor.detectIndentation` off; any other section, a
comment, or a key with no setting is skipped.

### parameter `Text`

The .editorconfig's text, which may be empty.

### parameter `Section`

Each section glob to the VS Code language ids it renders into (vscode-settings.yml `editorconfig`).

### outputs

`[System.Collections.Specialized.OrderedDictionary]` The settings, bare ones and `[<id>]` blocks, in the order the file states them.

### example 1

```powershell
ConvertFrom-EditorConfig -Text (Get-Content -Raw .editorconfig) -Section $map
```

## Which properties convert

Only the `.editorconfig` properties VS Code has a setting for are converted; every other property stays for the tools that read
`.editorconfig` itself.
