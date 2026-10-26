# Catzc.Base.FileLimits

The file-limits module. It owns the one declaration of how long and how wide a tracked file may be, per file class, and the one way to
measure a file against it: a config type that holds the defaults and their bounds, a compiled measure that reads a file in one pass, and the
functions that resolve and check a file's limits. It deliberately does **not** own which language a file is (that is
[Catzc.Base.Languages](catzc-base-languages.md)) or the limit on one function's body (that is the analyzer rule that reads its own setting).

## Responsibilities

| Responsibility   | Area     | Name                                                                             |
| ---------------- | -------- | -------------------------------------------------------------------------------- |
| responsibility:1 | defaults | [Limits in the registry](#responsibility1--limits-in-the-registry)               |
| responsibility:2 | measure  | [Measuring and checking a file](#responsibility2--measuring-and-checking-a-file) |
| responsibility:3 | tools    | [Tool widths](#responsibility3--tool-widths) |

### responsibility:1 — Limits in the registry

The length and width every file class may reach: a global default per class (code, config, prose), a per-language override that may push it,
and bounds no value may leave. A file's class comes from its language, or from an extension override applied first; a file with no
measurable text takes the class `none`. They are one registered config, `file-limits`, and its defaults are declared once, on the config
type. A value outside its bounds fails the config load, so a wrong number never reaches a check.

### responsibility:2 — Measuring and checking a file

Reading a file once for its line count and its widest line, resolving the file's limits from the registry, and reporting one finding per
breach with the file, the line, the limit and where the limit came from. A file no language declares fails at once instead of escaping
unlimited. The gate runs this over every tracked file in scope: a length breach fails it unless the file is exempt with a reason, and a
width breach is reported until its class is switched to fail.

### responsibility:3 — Tool widths

The width settings of the editor, the formatter and the Markdown linter, rendered from the one declared width: each tool's template names
the extension whose width it takes, and the root-config build writes the filled copy, so no tool carries a width of its own.

## What the module does

Widths and lengths used to be repeated across the formatter, linter and editor settings and kept in step by hand. This module holds them in
one config, so every tool that needs a width reads the same value and a change lands in one place.

The measure is a type, so a large tree is read without loading any file into memory, and the limits are resolved once per language and
reused for the run.

## Division

The module's public functions and configuration, sorted into the responsibilities above.

| Responsibility                                   | Function            |
| ------------------------------------------------ | ------------------- |
| responsibility:1 — Limits in the registry        | `Get-FileLimit`     |
| config                                           | `file-limits.yml`   |
| responsibility:2 — Measuring and checking a file | `Measure-FileShape` |
|                                                  | `Test-FileShape`    |
|                                                  | `Test-FileLimits`   |
| responsibility:3 — Tool widths | `Build-WidthConfigs` |
