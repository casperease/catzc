# pwsh/Base.QualityGates/private/Get-ResultCache.ps1

Reads a quality check's result cache: which files the check last found clean, keyed on their content. The cache is a per-machine file under
`out/cache/`, gitignored, so a check skips files whose content and stamp are unchanged.

## help

### synopsis

Reads a quality check's result cache: which files the check last found clean, keyed on their content.

### description

A per-machine file under out/cache/ (gitignored, never committed): repository-relative '/'-separated path -> '`<file SHA-256>:<stamp>`'
(Get-ContentStamp over every input that decides the check's verdict), recorded when the check last found the file clean
([ADR-AUTO-CACHE-CHECKEDFILESACROSSSESSIONS](../../../../drs/automation/caching.md#rule-adr-auto-cache-checkedfilesacrosssessions)). A file
whose bytes or the check's inputs changed no longer matches its entry and is checked again. A missing or unreadable cache is an empty one,
so the only cost of losing it is one full check; a pipeline starts with none. Format-Code and Get-ScriptAnalyzerDiagnostics keep one each.

### parameter `Path`

The cache file.

### outputs

`[hashtable]` Path -> key.
