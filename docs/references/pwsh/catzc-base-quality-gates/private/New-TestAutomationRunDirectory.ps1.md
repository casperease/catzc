# pwsh/Catzc.Base.QualityGates/private/New-TestAutomationRunDirectory.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Creates and returns a fresh timestamped run directory under the report base.

### description

Each Test-Automation run writes its artifacts into `<OutputFolder>/yyyyMMdd-HHmmss/`, suffixed -2, -3, … when a same-second directory
already exists, so rapid or concurrent runs never collide. The directory is created before it is returned.

### parameter `OutputFolder`

The report base directory the timestamped run directory is created under.

### outputs

`[string]` the created run directory's absolute path.
