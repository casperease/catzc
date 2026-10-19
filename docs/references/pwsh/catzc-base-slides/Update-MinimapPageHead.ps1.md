# pwsh/Catzc.Base.Slides/Update-MinimapPageHead.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The minimap head step: writes the generated meta head on every sister .md the diagram kit's minimap renderer wrote for the listed slides.

### description

`minimap_render.py` (`minimap_describe.py`) of the `Catzc.Diagrams` module writes each minimap's sister page as a body only; this step, run
after it, gives every `<view>.md` beside a listed slide (views chain, grid and tree) the generated head through the one head function,
Format-GeneratedFileHead, so the head opens with the hash of the body below it (ADR-REPO-FILEMETA-COMPOSEDFILES). The page's source is the
slide it describes, the folder's `diagram.drawio.png`, when that slide exists. A page whose text is already current is left as it is, so a
second run writes nothing.

### parameter `Slides`

The slide list: a JSON file { "slides": [ { "id", "stem", "lens", "adrs": `[...]`, "folder" } ] }, each slide's folder holding its sister
pages.

### example 1

```powershell
Update-MinimapPageHead -Slides out/diagrams/k4/slides.docs.json
```
