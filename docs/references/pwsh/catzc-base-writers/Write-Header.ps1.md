# pwsh/Base.Writers/Write-Header.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Writes a header with optional message in a chosen style.

### description

Styles (with message / without message):

```text
Curved (default):
  ╭──────────────╮       ╭──────────────╮
  │ Message      │
  ╰──────────────╯
```

```text
Stars:
  ****************       ****************
```

- Message

```text
****************
```

-ForegroundColor takes either a `[System.ConsoleColor]` (or its string name) — one colour for the whole header — or a
`[Catzc.Base.Writers.RainbowColor]` profile, which renders the horizontal rule lines as a per-character gradient while the titled line keeps
the profile's base colour. The gradient is also reachable as a bareword: 'rainbow' (anchored on the ring head, a full chromatic walk) or
'`<base>-rainbow`' (e.g. 'green-rainbow', the RainbowColor.ToString form). A profile passed to any plain `[ConsoleColor]` sink side-grades
to its base, so the same value works everywhere.

### parameter `Message`

The text to display. If omitted, writes a single separator line.

### parameter `Style`

Visual style: Curved, Stars, or Heavy. Defaults to Curved.

### parameter `Width`

Total width of the separator lines. Defaults to 78.

### parameter `ForegroundColor`

Colour for the output: a `[System.ConsoleColor]` (or its name), a 'rainbow' / '`<base>-rainbow`' bareword, or a
`[Catzc.Base.Writers.RainbowColor]` profile — the last three give a gradient rule. No colour by default (renders as terminal default).

### example 1

```powershell
Write-Header 'Deployment starting'
```

### example 2

```powershell
Write-Header 'Build' -Style Stars -ForegroundColor Yellow
```

### example 3

```powershell
Write-Header 'PASSED' -ForegroundColor rainbow
```

### example 4

```powershell
Write-Header 'PASSED' -ForegroundColor green-rainbow
```
