# pwsh/Base.Languages/Export-GoModule.ps1

The exporter that compiles a go module into one binary per target platform and records their hashes.

## help

### synopsis

Builds a go module for each target platform into a destination folder, with a binaries.json that lists the binaries and their SHA-256.

### description

Builds with the managed go, offline and with cgo off, once per platform into `<os>-<arch>/<name>` (with `.exe` for windows), from the
module's vendor folder when it has one and from the local cache otherwise. A missing or unpinned go, or a failed build, throws. Writes
`binaries.json`, a list of each binary's path and SHA-256 sorted ordinally, so a rebuild compares byte for byte. Returns the module,
destination, platform count and binary paths.

### parameter `Module`

The module folder, relative to the repository root or an absolute path under it.

### parameter `Destination`

The folder the binaries are built into; created when missing.

### parameter `Platform`

The target platforms, each as `<os>/<arch>` in lowercase. Without it, the host's own platform is the one target.

### parameter `Silent`

Suppresses the message that names the packaged module and the build output.

### example 1

```powershell
Export-GoModule -Module 'go/widget' -Destination $buildRoot/go/widget -Platform 'linux/amd64', 'windows/amd64'
```

## comment:1

Above `$go = Resolve-ToolExecutable -Tool go`, written with `#`.

```text
The managed go by its path, never a bare go off PATH
([ADR-AUTO-GO-MANAGEDTOOLCHAIN](/docs/drs/automation/go/go-language.md#rule-adr-auto-go-managedtoolchain)).
```

## comment:2

Above `$sorted = @($records | Sort-Object -Property { $_.path } -CaseSensitive)`, written with `#`.

```text
Sorted ordinally, so a rebuild compares byte for byte
([ADR-AUTO-BUNDLE-IMMUTABLEBUILD](/docs/drs/automation/platform-bundle.md#rule-adr-auto-bundle-immutablebuild)).
```
