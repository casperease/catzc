---
catzc:
  immutable:
    with_body_sha: "860c5428e23e"
    path: docs/references/automation/catzc-base-languages/types/GoConfig.cs.md
    folder: docs/references/automation/catzc-base-languages/types
    name: go-config-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-TYPES#8
      - ADR-REPO-FOLDERS#4
---

# automation/Catzc.Base.Languages/types/GoConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The Go test-workspace settings (configs/go.yml), and the single declaration of their sensible defaults: every
key is optional, and an omitted key behaves exactly like its default, so no function restates a value
([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)). New-GoWorkspace renders
the repository-root go.work and each <root>/tests/<folder>/go.mod from it, and Invoke-GoTest runs the tests in
<root>/tests/<folder>/. Registered in Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.Languages.GoConfig),
so Get-Config -Config go returns this typed record. Property names mirror the YAML keys (snake_case,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)). The go directive is not
a setting here: it is the go tool's pin in tools.yml, the one Go version.

Constructing an instance validates the file, collecting every violation into one ArgumentException:
  - only the known keys ('root', 'module_root', 'dependencies') — an unknown key (a typo) fails at load;
  - 'root' is the Go root folder, repository-relative: slash-separated segments of letters, digits, '.', '_' and
    '-', no leading or trailing slash, no '.' or '..' segment. Omitted, it resolves per repository (ResolveRoot):
    'go' when the repository has a go/ folder (a Go root track), else '.go', the dot-prefixed tooling folder
    ([ADR-REPO-FOLDERS#4](/docs/adr/repository/conventional-folders.md#rule-adr-repo-folders4));
  - 'module_root' is the module-path prefix: lowercase slash-separated segments, no leading or trailing slash
    (default catzc/go/tests);
  - 'dependencies' maps a module path (with a dot in its first segment) to a semantic version vX.Y.Z; empty by
    default, and kept in ordinal path order so a rendering never depends on the file's key order.
```

## comment:2

Above `public string root { get; }`, written with `//`.

```text
The declared Go root folder, repository-relative ('/'-separated). Null when the file declares none; ResolveRoot
then applies the default.
```

## comment:3

Above `public IReadOnlyDictionary<string, string> dependencies { get; }`, written with `//`.

```text
The test dependencies every go.mod requires, module path -> version, in ordinal path order. Empty when the
file declares none.
```

## comment:4

Above `public string ResolveRoot(string repositoryRoot)`, written with `//`.

```text
The Go root folder for a repository, repository-relative: the declared root, else 'go' when the repository has
a go/ folder, else '.go'.
```
