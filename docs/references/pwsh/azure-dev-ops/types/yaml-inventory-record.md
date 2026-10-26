# pwsh/Azure.DevOps/types/YamlInventoryRecord.cs

The typed inventory row that answers "does this file back a registered pipeline?". It joins one scanned YAML file to its Azure DevOps
registration data: the filesystem-side fields of a `YamlFileRecord` plus the registration-side fields, which are null when the file backs no
registered pipeline.

## Construction

The constructor is flat over primitives, not a `YamlFileRecord`, so a test that mocks the file scan with a plain `pscustomobject` still
binds. The classification and template type are taken as strings and parsed to the enums.
