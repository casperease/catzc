# pwsh/Catzc.Base.Drs/private/Get-DrsDoraCoverageViolations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists every rule set whose domain's DORA file has no section, or more than one, linking its ADR.

### description

Every domain outside the exempt list keeps one DORA file (dora_coverage.file, default dora-explains.md) with one `##` section per ADR of the
domain, the authoring conventions of the ADR index. A section links an ADR when any markdown link in it resolves to the ADR's file
(Resolve-DrsLinkTarget). This collects a finding when a rule set's ADR is linked from no section, or from more than one, and when the DORA
file itself is missing. A rule set with no file, or several, is a finding of Test-DrsRegistry and is skipped here, and so is one whose ADR
lies in a folder the settings exempt (exempt_folders): a vendor-checklist ADR is grounded in the vendor's reference, not in DORA.

Private helper for Test-DrsRegistry; not exported.

### parameter `Adrs`

The ADR registry (Get-Config -Config drs).

### parameter `Index`

The docs/drs/ file index (Get-DrsFileIndex).

### parameter `Settings`

The check's settings (DrsChecksConfig.dora_coverage).

### outputs

`[string[]]` One finding per missing or duplicated section, naming the DORA file, the linking sections' heading lines, and the rule set.
