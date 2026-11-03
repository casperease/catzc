# pwsh/Base.RootConfig/private/Resolve-RootConfigSource.ps1

The resolver of the path a root config is rendered from: it maps a repository-relative path to the file that holds it in the running mode.

## help

### synopsis

Resolves a root-config `source` or `sources` path to the file it names in the running mode.

### description

In source mode the path is repository-relative and resolves under the working root (Resolve-RepoPath). In build mode the root-config
registry still names the source tree's layout, `<code track>/<module folder>/<child path>`, while the built package holds the module folder
under the code root with its namespace on it
([DDR-RUNMODE-SAMEMODULEINBOTH](../../../../drs/design/run-modes.md#rule-ddr-runmode-samemoduleinboth)), so the path resolves under the code
root (Get-CatzcModulesRoot) through the module folder (Resolve-CodeModuleFolder). An internal folder (its name starting with a dot) is kept
as it is. Throws when the built root holds no such module folder.

### parameter `Path`

The repository-relative source path, as the registry names it.

### outputs

`[string]` The full path of the file.
