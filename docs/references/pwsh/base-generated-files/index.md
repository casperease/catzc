# Catzc.Base.GeneratedFiles

The generated-files module. It owns the one registry of generated-file writers, `generated-files.yml`, and the one reading of which writer
is due: what each writer reads, what it writes, and whether its inputs changed since it last ran. It deliberately does **not** own the
writers themselves (each generator lives in its own module) or the check that a generated file matches its source (that is the quality
gate).

## Responsibilities

| Responsibility   | Area     | Name                                                                             |
| ---------------- | -------- | -------------------------------------------------------------------------------- |
| responsibility:1 | registry | [The writer registry](#responsibility1--the-writer-registry)                     |
| responsibility:2 | due      | [Judging which writers are due](#responsibility2--judging-which-writers-are-due) |
| responsibility:3 | stamps   | [Storing the input stamp](#responsibility3--storing-the-input-stamp)             |

### responsibility:1 — The writer registry

`generated-files.yml` lists every generated-file writer in the order they re-render in, each with the inputs it reads and the outputs it
writes. The config type `GeneratedFilesConfig` holds the list and `input_depth`, how deep the walk for a `**` input glob goes below the
glob's literal folder; its default is declared once, on the type. See
[the config page](configs/generated-files.md) and the type pages
[GeneratedWriter](types/generated-writer.md) and
[GeneratedWriterDue](types/generated-writer-due.md).

### responsibility:2 — Judging which writers are due

A writer is due when an output named without a wildcard is missing, or when the stamp of every file its inputs match, salted with the
folders its wildcard inputs could write into, differs from the stamp stored after its last run. A dirty tree alone is not a stale output. A
missing or unreadable memo makes every writer due, and a writer with neither list is due whenever git reports anything changed.
`Get-GeneratedWriterDue` returns one result per writer; its private helpers walk the input files, compute the stamps and read the memo. See
[Get-GeneratedWriterDue](get-generated-writer-due.md).

### responsibility:3 — Storing the input stamp

After a writer has run, its input stamp is stored in the memo under `out/cache/generated-writers.json`, so the writer is not due again until
one of its inputs changes. A name that is not a writer of `generated-files.yml` fails at once. See
[Save-GeneratedWriterStamp](save-generated-writer-stamp.md).

## What the module does

What a writer depends on is declared once, in `generated-files.yml`, so the changed-only gate and the import janitors ask the same question
and get the same answer instead of each keeping its own list.

## Division

The module's public functions and configuration, sorted into the responsibilities above.

| Responsibility                                   | Function                    |
| ------------------------------------------------ | --------------------------- |
| responsibility:1 — The writer registry           | `generated-files.yml`       |
| responsibility:2 — Judging which writers are due | `Get-GeneratedWriterDue`    |
| responsibility:3 — Storing the input stamp       | `Save-GeneratedWriterStamp` |
