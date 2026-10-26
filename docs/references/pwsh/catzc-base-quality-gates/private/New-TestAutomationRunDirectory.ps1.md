# pwsh/Base.QualityGates/private/New-TestAutomationRunDirectory.ps1

Creates and returns a fresh timestamped run directory under the report base. Each Test-Automation run writes its artifacts into
`<OutputFolder>/yyyyMMdd-HHmmss/`, with a numeric suffix when a same-second directory exists.

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
