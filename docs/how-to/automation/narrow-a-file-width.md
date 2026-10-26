# Narrow a file's width

`Test-FileLimits` measures every tracked file's widest line against the width `file-limits.yml` declares for its class: 120 columns for
code, 140 for config and prose. Width is reported, never failed, and no file is reflowed to fit it. This guide is for the day you want a
file, or a class, narrower: how to find the wide lines, and the fixes that keep each file's meaning and every tool that reads it intact.

## Find the wide lines

Run the gate over the files you care about; its report lists each width breach with the file, the line and the limit:

```powershell
Test-FileLimits -Path docs/explanation/flow/index.md -PassThru
```

`Get-FileLimit -Path <file>` names the width a file is held to and where that width comes from: its class default, a language override, or
an extension override. The comment pages under `docs/references/` are authored prose, so they are measured too.

## Fix a wide line in markdown

Prettier wraps prose at the declared width on `Format-Code`, so a prose line that stays wide is one it cannot break. Each kind has its fix:

- **A long link, URL, anchor or citation.** Prettier never breaks link text, so the link takes a reference label, `[text][label]`, with
  `[label]: <destination>` on its own line below the paragraph or the list. When the definition line itself is too long, a one-letter label
  makes it fit. Put the definitions after a list, never between its items, or markdownlint reads two lists.
- **A diagram embed.** The diagram kit reads the reference form as well as the inline one: `![alt][diagram]`, with
  `[diagram]: .assets/<name>.drawio.png` directly below the image.
- **A rule citation.** `Update-DrsCitation` writes a citation inline when its line fits and as a numbered reference, `[CODE][rN]`, when it
  does not.
- **A wide table.** When a table is only a few columns over, shorten its widest cell: the padding sets every row's width. Otherwise make it
  a list. A two-column table becomes one item per row, `- **key**: value`; a wider one nests each column under the row's first cell.
- **A heading, or one token that cannot wrap.** Reword it shorter; a heading never wraps. A long quoted message splits into two code spans
  at a sentence boundary.

Check each file after a fix with `Format-Code -Path <file>`, then `Test-Markdownlint`, `Test-Links` and `Test-Spelling` on it.

## Fix a wide line in code

A string literal past the width moves to a line of its own (`Get-StringOverflowLine` finds it), and a long pipeline or argument list wraps
at its pipes and commas. `Format-Code` keeps the result in the language's formatting.

## Change a class's width

The widths, their bounds and the per-language overrides are declared once in `pwsh/Base.FileLimits/configs/file-limits.yml`.
`Build-WidthConfigs` renders `.editorconfig`, the prettier and the markdownlint widths from that one declaration at the next import, so a
change lands in one place and every tool follows it.
