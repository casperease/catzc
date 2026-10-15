---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/configs/go.yml.md
    kind: comment-page
    body_sha: "6260b077e224"
    adrs:
      - ADR-AUTO-DEFAULT#6
---

# automation/Catzc.Base.Languages/configs/go.yml

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `module_root: catzc/go/tests`.

```text
The Go test workspace — the one declared source that New-GoWorkspace renders the repository-root go.work and every
<root>/tests/<folder>/go.mod from. Go code in this repository is test artifacts only: one Go module per catzc module,
under <root>/tests/<module-in-kebab>/, and nothing Go-specific is committed but the *_test.go files.

Every key is optional: an omitted key takes the sensible default declared once on
Catzc.Base.Languages.GoConfig ([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)).
Loaded via Get-Config -Config go; the shape is validated by the GoConfig type.

The go directive of go.work and every go.mod is not declared here: it is the go tool's pin in tools.yml
(global.tools.go.version), the one Go version, so the workspace never asks for a newer toolchain than the one
installed.
```

## comment:2

Above `module_root: catzc/go/tests`.

```text
root — the Go root folder, repository-relative: the test modules live in <root>/tests/<module>/, and go.work stays at
the repository root with one `use ./<root>/tests/<module>` entry per module. Not declared here, so it takes the
default: 'go' when the repository has a go/ folder (a Go root track), else '.go', the dot-prefixed tooling folder.
Declare it (e.g. `root: test/go`) only to place the Go root elsewhere.
```

## comment:3

Above `module_root: catzc/go/tests`.

```text
The module-path prefix: the folder <root>/tests/<folder>/ is the Go module <module_root>/<folder>. Default:
catzc/go/tests.
```

## comment:4

Above `dependencies: {}`.

```text
The test dependencies every go.mod requires: module path -> version (vX.Y.Z). The go.mod files are rendered and
never tidied, so a dependency's own requirements are declared here too. Default: none — the standard library's
testing package is enough for black-box tests that start the engine and assert on its output.
```
