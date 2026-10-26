# pwsh/Base.Reports/configs/output-formats.yml

The catalogue of every kind of file a producer writes under the output root, declared once
([ADR-REPO-OUTFMT](../../../../drs/repository/output-formats.md)).

## How it is used

`Catzc.Base.Reports.OutputFormatsConfig` validates it on load. `Test-OutputFormats` classifies the files under each format's folders and
runs its validator. `Clear-Output` prunes by each format's area.

## Keys

```text
formats:
  <kebab-case id>:
    patterns: [ <glob> ]      # relative to the output root; '*' / '?' inside one segment, '**' any depth,
                              # '{stamp}' one stamped run folder. No path may match patterns of two
                              # formats: the catalogue is rejected on load when two can overlap.
    target: file              # file (default) | folder — a folder pattern is checked as one unit
    producer: <function or script>
    audience: <who opens it, with what>
    validator: { kind: <kind>, <parameter>: <value> }
    limits: { <limit>: <positive whole number> }   # width, height, min_/max_width, min_/max_height,
                                                   # min_pages, max_bytes
```

Validator kinds: `png`, `drawio-png`, `drawio-model`, `pdf`, `json`, `csv`, `md`, `nunit-xml`, `zip`, `powershell`, `text`, `latest-pointer`
and `delegate` (names an existing `Assert-*` that already proves the format).

## Entries that are never pruned

- A plan cannot be regenerated
  ([ADR-REPO-OUTDIR-PLANNOTES](../../../../drs/repository/dedicated-output-directory.md#rule-adr-repo-outdir-plannotes)), so its `max_age`
  is `none` and a person retires it.
- The time safeguard log is never pruned
  ([ADR-REPO-OUTDIR-EVERYFILEHASFORMAT](../../../../drs/repository/dedicated-output-directory.md#rule-adr-repo-outdir-everyfilehasformat)):
  it is the record the limits are tuned from, and the hook appends to it for as long as the repository is worked in. A session's own logs
  belong in its session folder, and `Clear-Output -All` is the one way the top of `out/` is emptied.
- The folder's own keep file is declared as a format
  ([ADR-REPO-OUTDIR-OUTGITIGNORED](../../../../drs/repository/dedicated-output-directory.md#rule-adr-repo-outdir-outgitignored)).
