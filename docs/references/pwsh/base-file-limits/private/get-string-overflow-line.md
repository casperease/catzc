# pwsh/Base.FileLimits/private/Get-StringOverflowLine.ps1

The private scanner that finds the lines over the width limit which only a single-line string literal makes long.

## help

### synopsis

The lines over the width limit that only a single-line string literal makes long.

### description

Test-FileShape asks for these lines when the file-limits config sets `string_overflow: exempt`: a line whose overflow is one string the
writer cannot wrap is not counted against the width. A line is exempt when it is over the width, a single-line string starts at or before
the width, and the string runs to the line's end (for JSON, a string followed only by its member's comma counts as ending the line). Each
language finds its strings with its own reader: the PowerShell tokenizer, the YamlDotNet scanner for scalars, XmlReader for attribute
values, and a quote scan for JSON and JSON Lines that skips escaped quotes and stops at a `//` comment. A file its reader cannot read, or a
language without a reader, exempts no line.

### parameter `Text`

The file's text.

### parameter `Width`

The width limit of the file's class, in characters.

### parameter `Language`

The file's language, one of `powershell`, `yaml`, `xml`, `json` and `jsonl`; any other exempts nothing.

### outputs

`[int[]]` The exempt line numbers, 1-based, ascending and without duplicates.

## String spans

The scanner collects the spans of every one-line string literal as (line, first column, last column), 1-based, from the language's own
tokenizer. For XML the reader gives an attribute's line and the column of its name, and the value runs from its opening quote to the
matching one.

## JSON

A JSON string never spans a line, so each line is scanned on its own: a quote opens, an escaped one does not close, and outside a string a
`//` comment (JSONC settings) ends the line.

## Exempt line

A line is exempt when one string covers every column past the width to the end of its text, so nothing but the string overflows.
