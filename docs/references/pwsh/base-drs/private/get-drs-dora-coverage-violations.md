# pwsh/Base.Drs/private/Get-DrsDoraCoverageViolations.ps1

The private helper of `Test-DrsRegistry` that finds rule sets whose record is linked from no section, or more than one, of its domain's DORA
file.

## help

### synopsis

Lists every rule set whose domain's DORA file has no section, or more than one, linking its record.

### description

Every domain outside the exempt list keeps one DORA file (dora_coverage.file, default dora-explains.md) with one `##` section per record of
the domain, the authoring conventions of the DRS index. A section links a record when any markdown link in it resolves to the record's file
(Resolve-DrsLinkTarget). This collects a finding when a rule set's record is linked from no section, or from more than one, and when the
DORA file itself is missing. A rule set with no file, or several, is a finding of Test-DrsRegistry and is skipped here, and so is one whose
record lies in a folder the settings exempt (exempt_folders): a vendor-checklist record is grounded in the vendor's reference, not in DORA.

Private helper for Test-DrsRegistry; not exported.

### parameter `Drs`

The DRS registry (Get-Config -Config drs).

### parameter `Index`

The docs/drs/ file index (Get-DrsFileIndex).

### parameter `Settings`

The check's settings (DrsChecksConfig.dora_coverage).

### outputs

`[string[]]` One finding per missing or duplicated section, naming the DORA file, the linking sections' heading lines, and the rule set.
