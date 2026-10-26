# pwsh/Base.Languages/New-GoWorkspace.ps1

`New-GoWorkspace` renders the Go test workspace from `go.yml`: the repository-root `go.work` and one `go.mod` per Go test folder and per
module folder of the go track. `Build-RootConfig` writes the result.

## help

### synopsis

Renders the Go test workspace, the repository-root go.work and one go.mod per Go test folder, from the go config.

### description

The Go root is go.yml's `root`, resolved by GoConfig.ResolveRoot: the declared folder, else go/ when the repository has one (a Go root
track), else .go/ (the dot-prefixed tooling folder). Discovers the Go test folders (the immediate, non-dot-prefixed subdirectories of
`<root>/tests/` that hold at least one .go file; each is one Go module, named for its catzc module in kebab case) and renders:

```text
go.work                       at the repository root, the idiomatic workspace place an editor's Go language
                              server finds with no configuration: the go directive and one
                              `use ./<root>/tests/<folder>` entry per folder;
<root>/tests/<folder>/go.mod  the module path <module_root>/<folder>, the go directive, and one require line
                              per declared dependency.
```

The settings come from configs/go.yml (Get-Config -Config go, typed as GoConfig); the go directive is the go tool's pin in tools.yml
(global.tools.go.version, e.g. 1.27), the one Go version, so the workspace never asks for a newer toolchain than the managed one. Folders
and dependencies are sorted ordinally and every file is LF with one trailing newline, so the same tree and config render the same bytes on
every machine. Rendering is pure text: offline, with no call to the go tool.

This is a pure renderer: it returns the content and writes nothing. It is the `generator` the root-config registry names for the go.work and
go.mod targets, and Build-RootConfig owns the write ([ADR-REPO-ROOTCFG](../../../drs/repository/generated-root-configs.md)). One call
renders every file, so a registry entry selects its files with -Target.

### parameter `Target`

Return only the files whose repository-relative path matches this case-sensitive wildcard pattern (e.g. 'go.work' or '`*/tests/*/go.mod`').
Default: every file.

### outputs

`[Catzc.Base.Languages.GoWorkspaceFile]` One record per rendered file ({ Target; Content }): go.work first, then each go.mod in folder
order.

### example 1

```powershell
New-GoWorkspace
```

### example 2

```powershell
(New-GoWorkspace -Target 'go.work').Content
```

## The go directive

The one Go version is the go tool's `tools.yml` pin, read by address (reading config is global access,
[ADR-CONF-ADDRESSING](../../../drs/configuration/config-value-addressing.md)). A major.minor pin (1.27) is a valid `go` directive, as is a
full 1.N.P.

## The members

One Go module per module folder of the track: a folder the module-type registry names as a module, holding Go code. The members are the test
holder's folders under `tests/`, then the modules, each with its module path under `module_root`.
