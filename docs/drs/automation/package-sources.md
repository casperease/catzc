# Automation: One configured package source per language

## Rules: ADR-AUTO-PKGSRC

### Rule ADR-AUTO-PKGSRC-SOURCEPERLANGUAGE

Every supported language that has a package manager declares one `package_source` (`name`, `url`, `credential_env`) in its language config.
The source is one shared type, its public default is declared once on that type, and a working root overrides it whole, so a consumer or a
devbox behind a proxy points every language at a private feed in one place.

- [Decision](#decision)

### Rule ADR-AUTO-PKGSRC-GENERATEDNATIVESETTINGS

The file or environment a package manager reads is rendered from the `package_source` by the root-config generators or the engine contract,
never maintained by hand. A hand edit of such a file is drift, and the formatter reports it.

- [Generated settings](#generated-settings)

### Rule ADR-AUTO-PKGSRC-CREDENTIALBYNAME

A source names a credential's environment variable, never a value. A rendered file carries the reference the tool expands, a process gets
the variable exported for the call only, nothing writes a token to disk, and a tooling command whose source names an unset variable fails
fast naming it.

- [Credentials](#credentials)

### Rule ADR-AUTO-PKGSRC-BUILDRESOLVESTESTOFFLINE

A build resolves dependencies from the configured source and the test phase never reaches one. The sanctioned online steps are the tooling
commands `Install-PythonWorkspace`, `Install-TypeScript`, `Update-BatsVendor`, `Install-VendorModule`, the go module download and the dotnet
restore; the exporters resolve from the manager's cache. The configured host is a sanctioned site through the generated guard.

- [Build and test phases](#build-and-test-phases)

### Rule ADR-AUTO-PKGSRC-COREVENDOREDONLY

Vendoring is for the core the tooling needs to start fast and to work offline: the pwsh modules under `pwsh/.vendor` and the bats runner. A
language module's dependencies are resolved by its package manager, never vendored.

- [Vendoring](#vendoring)

## Context

A repository holds code in several languages, and each language resolves its dependencies through its own package manager. Today only the
pwsh vendor source is configurable; python, go and javascript reach the public registries implicitly. A consumer behind a corporate proxy
cannot reach them, so every such team patches tool files by hand and the build is not the same everywhere. A feed that a repository names
once, in its configuration, renders the same settings on a devbox, in a pipeline and in a consumer root.

## Decision

Each language with a package manager carries one `package_source` in its language config, one generated file or environment carries it to
the tool, and the public registry is the default:

| Language   | Config           | Manager and public package source              | Rendered to                                              |
| ---------- | ---------------- | ---------------------------------------------- | -------------------------------------------------------- |
| powershell | `vendor.yml`     | PSResourceGet, PSGallery                       | the repository `Install-VendorModule` registers          |
| bcl        | `bcl.yml`        | NuGet, nuget.org                               | `nuget.config`                                           |
| python     | `python.yml`     | uv, the PyPI simple index                      | `[[tool.uv.index]]` in the generated root pyproject.toml |
| go         | `go.yml`         | the Go module proxy, proxy.golang.org          | `GOPROXY` and `GOPRIVATE` in the engine environment      |
| javascript | `javascript.yml` | npm, registry.npmjs.org                        | `.npmrc`                                                 |
| bash       | `bash.yml`       | a release download, GitHub releases            | the base URL `Update-BatsVendor` fetches from            |
| bicep      | `bicep.yml`      | the Bicep module registry, `mcr.microsoft.com` | `bicepconfig.json` module aliases                        |

The default is declared once on the type, so an absent key means the public source; a working-root override replaces it whole, as every
language config does. A language with no package manager (yaml, markdown, json, xml, html, css) has no key.

### Generated settings

`Rendered from the config, never kept by hand`

The generators the root-config registry already runs render `.npmrc` (the registry and the token line for its host), the `[[tool.uv.index]]`
table in the generated root `pyproject.toml`, and `nuget.config`; the one engine contract gives every go call `GOPROXY` and `GOPRIVATE`;
`Install-VendorModule` registers the PSResource repository from the same key. A hand edit of a rendered file is a drift the formatter and
`Test-Formatting` report, as for every generated root file.

### Credentials

`The variable's name is configuration; its value is the environment's`

`credential_env` names an environment variable. A rendered file carries the variable reference the tool expands (`${VAR}` in `.npmrc`, uv's
`UV_INDEX_<NAME>_USERNAME` and `_PASSWORD` pair for python), a process gets the variable exported for the one call, and a token is never
written to disk. A tooling command whose source names a variable that is unset fails fast and names the variable. A source with no
`credential_env` is anonymous.

### Build and test phases

`The restore is a tooling step before the tests`

The online steps are the tooling commands a build runs ([ADR-AUTO-NET-PACKAGEINSTALL](network-calls.md#rule-adr-auto-net-packageinstall));
the exporters resolve from the manager's cache, and a missing dependency names the tooling command that fills the cache from the configured
source. Tests stay offline ([ADR-AUTO-NET-TESTSOFFLINE](network-calls.md#rule-adr-auto-net-testsoffline)) because the restore ran before
them. The configured host is registered as a site of the `package-install` class, rendered into the site registry and the generated guard
from the same configs ([ADR-AUTO-NET-SITEREGISTRY](network-calls.md#rule-adr-auto-net-siteregistry),
[ADR-AUTO-NET-GENERATEDGUARD](network-calls.md#rule-adr-auto-net-generatedguard)), so a private feed is allowed exactly where the config
names it.

### Vendoring

`Only the core is checked in`

The vendored set is what the tooling needs before any package manager has run: the pwsh modules the importer loads
([DDR-VENDOR-ISVENDORED](../design/vendoring.md#rule-ddr-vendor-isvendored),
[DDR-VENDOR-HEADREPRODUCIBLE](../design/vendoring.md#rule-ddr-vendor-headreproducible)) and the bats runner the bash tests need. A language
module's dependencies are installed by its package manager from the configured source; a consumer's runtime contacts nothing because the
bundle ships what the build resolved.

## Consequences

- One override per language moves a repository to a private feed; no tool file is patched by hand.
- The settings a package manager reads are generated files and environment, so they render the same on a devbox, in a pipeline and in a
  consumer root.
- A hand edit of a rendered file is drift: the formatter reports it, and the fix is the `package_source`, not the file.
- `nuget.config` renders the configured package source as its one entry, where it cleared every entry before; the test phase stays offline
  through the dotnet offline guard.
- A token is never in the repository or on disk; a missing credential variable stops the tooling command that needs it, by name.
- The vendored set stays small, so a clone starts fast and works offline, and the dependencies of every other language are as reproducible
  as its package manager's lock.

## Related

- [network-calls](network-calls.md) — the sanctioned classes, the site registry and the generated guard the configured hosts join.
- [vendoring](../design/vendoring.md) — what the vendored set is and why its head is reproducible.
- [platform-bundle](platform-bundle.md) — the bundle that ships what the build resolved.
