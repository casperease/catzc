# pwsh/Catzc.Base.Overlay/private/Get-OverlayContractViolation.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns every way an override file breaks the contract of the function it replaces.

### description

The bundle's own code keeps calling a function the way it always has, so an override keeps the original's contract
([ADR-AUTO-OVERLAY](../../../../adr/automation/consumer-overlay.md)): it declares every parameter the original declares, with the same type;
it adds no mandatory parameter the original does not have as mandatory; and it declares the same `[OutputType]`. Read from the override's
syntax tree, against the loaded original.

### parameter `Original`

The loaded function the override replaces.

### parameter `Path`

The override file.

### parameter `RelativePath`

The override file as the messages show it.

### outputs

`[string]` One message per break; nothing when the contract holds.
