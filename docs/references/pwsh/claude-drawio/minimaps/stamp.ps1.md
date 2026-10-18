# .claude/drawio/minimaps/stamp.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The minimap head step: writes the generated meta head on every sister .md render.py wrote under -Target.

### description

render.py (describe.py) writes each minimap's sister page as a body only; this step, run after it, gives every `<view>/<stem>.<view>.md`
under -Target (views chain, grid and tree) the generated head through the one head function, Format-GeneratedFileHead, so the head opens
with the hash of the body below it (ADR-REPO-FILEMETA-COMPOSEDFILES). The page's source is the slide it describes,
`<Target>/<stem>.drawio.png`, when that slide exists. A page whose text is already current is left as it is, so a second run writes nothing.

### parameter `Target`

The slides folder the minimaps were rendered into, repository-relative or absolute.

### example 1

```powershell
pwsh -NoProfile -File .claude/drawio/minimaps/stamp.ps1 -Target docs/explanation/.assets
```
