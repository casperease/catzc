# pwsh/Base.Drs/Build-DrsCodeDictionary.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Generates the spell-checker word list of ADR code segments from the ADR registry.

### description

Reads the ADR registry (configs/drs.yml, via Get-Config -Config drs) and the rule headings of every ADR file under docs/drs/, and writes
every segment of every ADR code and rule heading, lower-cased, de-duplicated and ordinal-sorted, to `.cspell/drs-codes.txt` at the
repository root, the word list cspell.yml loads as `catzc-drs-codes`. A rule is named by a segment of spelled-out words joined, so the spell
checker takes the names from the registry rather than from one hand-written terminology entry per rule
([ADR-REPO-DRSCODE-SEGMENTSAREWORDS](../../../drs/repository/drs-code-language.md#rule-adr-repo-drscode-segmentsarewords)). The list carries
the generated-file head, is gitignored like the terminology lists, and is regenerated at the importer tail; Test-GeneratedFiles fails when
it is stale.

### parameter `DryRun`

Report whether the list would change without writing it. See [ADR-AUTO-DRYRUN](../../../drs/automation/dry-run.md).

### parameter `Silent`

Suppress the status line (used by the importer tail).

### parameter `PassThru`

Return one result object ({ Path, WordCount, Changed, DryRun }) instead of the path.

### outputs

`[string]` The path to the generated list (with -PassThru, the result object instead).

### example 1

```powershell
Build-DrsCodeDictionary -DryRun -PassThru
```
