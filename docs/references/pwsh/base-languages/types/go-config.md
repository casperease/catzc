# pwsh/Base.Languages/types/GoConfig.cs

The typed record for `go.yml`, the Go test-workspace settings, and the single declaration of their sensible defaults: every key is optional,
and an omitted key behaves exactly like its default, so no function restates a value
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)).
`New-GoWorkspace` renders the repository-root `go.work` and each `<root>/tests/<folder>/go.mod` from it, and `Invoke-GoTest` runs the tests
in `<root>/tests/<folder>/`. It is registered in `Catzc.Base.Config/configs/configs.yml` (type `Catzc.Base.Languages.GoConfig`), so
`Get-Config -Config go` returns it. Its property names mirror the YAML keys
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)). The
go directive is not a setting here: it is the go tool's pin in `tools.yml`, the one Go version.

## Validation

Constructing an instance validates the file and collects every violation into one `ArgumentException`:

- only the known keys, `root`, `module_root` and `dependencies`, are allowed, so a typo fails at load;
- `root` is the Go root folder, repository-relative: slash-separated segments of letters, digits, `.`, `_` and `-`, no leading or trailing
  slash, no `.` or `..` segment. Omitted, it resolves per repository: `go` when the repository has a `go/` folder (a Go root track), else
  `.go`, the dot-prefixed tooling folder
  ([ADR-REPO-FOLDERS-DOTMEANSTOOLING](../../../../drs/repository/conventional-folders.md#rule-adr-repo-folders-dotmeanstooling));
- `module_root` is the module-path prefix: lowercase slash-separated segments, no leading or trailing slash (default `catzc/go/tests`);
- `dependencies` maps a module path (with a dot in its first segment) to a semantic version `vX.Y.Z`. It is empty by default, and kept in
  ordinal path order so a rendering never depends on the file's key order.

## Properties

- **`root`** — the declared Go root folder, repository-relative (`/`-separated). Null when the file declares none; `ResolveRoot` then
  applies the default.
- **`module_root`** — the module-path prefix: a test folder `<root>/tests/<folder>/` is the Go module `<module_root>/tests/<folder>`, and a
  module folder `<root>/<Module>/` of the track is `<module_root>/<Module>`.
- **`dependencies`** — the test dependencies every `go.mod` requires, module path to version, in ordinal path order. Empty when the file
  declares none.

## ResolveRoot

`ResolveRoot(repositoryRoot)` returns the Go root folder for a repository, repository-relative: the declared root, else `go` when the
repository has a `go/` folder, else `.go`.
