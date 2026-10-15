---
catzc:
  derived:
    path: docs/references/automation/catzc-base-reports/configs/output-formats.yml.md
    kind: comment-page
    body_sha: c72dc0bf389c
    adrs: []
    links: []
---

# automation/Catzc.Base.Reports/configs/output-formats.yml

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `formats:`.

```text
output-formats.yml — every kind of file a producer writes under the output root, declared once
([ADR-REPO-OUTFMT](/docs/adr/repository/output-formats.md)). Validated on load by
Catzc.Base.Reports.OutputFormatsConfig; Test-OutputFormats classifies the files under each format's folders and
runs its validator.

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

Validator kinds: png, drawio-png, drawio-model, pdf, json, csv, md, nunit-xml, zip, powershell, text,
latest-pointer, delegate (names an existing Assert-* that already proves the format).
```
