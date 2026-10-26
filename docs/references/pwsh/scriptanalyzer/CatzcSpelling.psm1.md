# pwsh/.scriptanalyzer/CatzcSpelling.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:measure = $null`, written with `#`.

```text
The spelling check reads the dictionaries, so it is its own entry rule: a dictionary edit re-runs this rule alone
([ADR-AUTO-CACHE-CHECKEDFILESACROSSSESSIONS](/docs/drs/automation/caching.md#rule-adr-auto-cache-checkedfilesacrosssessions)).
```
