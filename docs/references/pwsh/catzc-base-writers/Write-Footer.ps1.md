# pwsh/Base.Writers/Write-Footer.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Writes a closing footer line in a chosen style.

### description

Pairs with Write-Header to visually close a section. Renders a single closing line matching the header style:

```text
Curved:  ╰──────────────╯
Stars:   ****************
Heavy:   ╚══════════════╝
```

-ForegroundColor takes either a `[System.ConsoleColor]` (or its string name), a 'rainbow' / '`<base>-rainbow`' bareword, or a
`[Catzc.Base.Writers.RainbowColor]` profile — the last three render the closing rule as a per-character gradient.

### parameter `Style`

Visual style: Curved, Stars, or Heavy. Defaults to Curved.

### parameter `Width`

Total width of the line. Defaults to 78.

### parameter `ForegroundColor`

Colour for the output: a `[System.ConsoleColor]` (or its name), a 'rainbow' / '`<base>-rainbow`' bareword, or a
`[Catzc.Base.Writers.RainbowColor]` profile — the last three give a gradient rule. No colour by default (renders as terminal default).

### example 1

```powershell
Write-Header 'Deploying'
Deploy-App
Write-Footer
```

### example 2

```powershell
Write-Footer -ForegroundColor rainbow
```
