# pwsh/Catzc.Base.QualityGates/private/Move-FunctionHelp.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Moves the help of one PowerShell file from its head's config part to the `## help` section of its comment page.

### description

The help keys (synopsis, description, parameters, inputs, outputs, examples, notes) are rendered in the section's fixed shape
([ADR-REPO-HELP-HELPONCOMMENTPAGE](../../../../adr/repository/function-help.md#rule-adr-repo-help-helponcommentpage)), their text kept as written, and the head loses its
config part; a head left with nothing else goes. A page that does not exist yet starts the way the comment exporter starts one, and an
existing page keeps every other byte, its comment sections included. A help section already on the page is replaced, so a second move
changes nothing once the head holds no help. A config part that holds a key that is no help key, or does not parse, is reported and the file
is left alone, so no authored key is lost.

### parameter `Path`

The file's repository-relative, '/'-separated path.

### parameter `RepositoryRoot`

The repository root the path is relative to.

### parameter `RestsOn`

Code links ('[ADR-X#n](../../../../adr/)') the description gains as the sentence 'It rests on ...', in the order given.

### parameter `DryRun`

Compute the new texts without writing either file.

### outputs

`[pscustomobject]` { Path; Page; Moved; Reason; Text; PageText }: Moved is false with a Reason when nothing moves, and Text and PageText are
the texts the two files have after the move.

### notes

RestsOn carries the codes the head lists that no text of the file spells out, so the move keeps each as a real link in the help's
description and none is lost when the head goes ([ADR-REPO-FILEMETA-NOREADBACK](../../../../adr/repository/file-meta.md#rule-adr-repo-filemeta-noreadback)).
