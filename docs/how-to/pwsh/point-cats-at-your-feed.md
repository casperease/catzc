# Point cats at your feed

Every language that has a package manager resolves its packages from a **package source**: a `name`, a `url` and an optional
`credential_env`. The public registry is the default. You need this guide when the repository must resolve from a private Artifactory or
Azure DevOps feed, a mirror, or through a proxy.

One override per language moves the repository to the feed, and the settings each package manager reads are rendered from it, never edited
by hand ([ADR-AUTO-PKGSRC-SOURCEPERLANGUAGE](../../drs/automation/package-sources.md#rule-adr-auto-pkgsrc-sourceperlanguage),
[ADR-AUTO-PKGSRC-GENERATEDNATIVESETTINGS](../../drs/automation/package-sources.md#rule-adr-auto-pkgsrc-generatednativesettings)).

## Write the override

The override is a file in the **working root**, `.catzc/configs/<language>.yml`. A working-root config is read whole, never merged onto the
bundled one
([ADR-CONF-LOADING-WORKINGROOTREADWHOLE](../../drs/configuration/module-config-loading.md#rule-adr-conf-loading-workingrootreadwhole)), so
the file states every key the language config holds, and `package_source` is one of them. The sections below show the `package_source` block
only; keep the rest of the bundled config beside it.

```yaml
package_source:
  name: widget-feed
  url: https://feeds.example/api/widget
  credential_env: WIDGET_FEED_TOKEN
```

- `name` is the source's name in the rendered file.
- `url` is its address.
- `credential_env` names an environment variable that holds the credential. Leave it out for a package source that needs none.

When the key is absent the language uses its public default. After each edit, run `Build-RootConfig` so the generated files follow. A hand
edit of a generated file is drift the formatter reports, and the fix is the `package_source`, not the file.

## Python

Override `.catzc/configs/python.yml`:

```yaml
package_source:
  name: widget-feed
  url: https://feeds.example/api/widget/simple
  credential_env: WIDGET_FEED_TOKEN
```

`New-PythonProject` renders the source as the `[[tool.uv.index]]` table of the python workspace's generated `pyproject.toml`, with
`default = true`. Fetch with:

```powershell
Install-PythonWorkspace
```

Check that the generated `pyproject.toml` holds `name = "widget-feed"` and `url = "https://feeds.example/api/widget/simple"` under
`[[tool.uv.index]]`, and that the command ends with `The Python workspace ... is synced.`

## JavaScript

Override `.catzc/configs/javascript.yml` with the same three keys, the `url` being the npm registry of the feed:

```yaml
package_source:
  name: widget-feed
  url: https://feeds.example/api/widget/npm
  credential_env: WIDGET_FEED_TOKEN
```

`New-Npmrc` renders `.npmrc`. The root-config registry marks that file as opt-in, so it renders where the repository asks for it. Fetch
with:

```powershell
Install-TypeScript
```

Check that `.npmrc` holds `registry=https://feeds.example/api/widget/npm/` and, with a credential,
`//feeds.example/api/widget/npm/:_authToken=${WIDGET_FEED_TOKEN}`. The file carries the variable reference, never the token.

## Go

Override `.catzc/configs/go.yml`:

```yaml
package_source:
  name: widget-feed
  url: https://feeds.example/api/go/widget
```

`Get-GoEnvironment` gives every go call `GOPROXY` as the `url`. A `url` other than the public proxy also sets `GOPRIVATE` to the host and
`GOSUMDB` to `off`. Fetch with:

```powershell
Invoke-Go '-C <folder> mod download'
```

Check with `Get-GoEnvironment`: it lists `GOPROXY`, `GOPRIVATE` and `GOSUMDB` with your values. Go reads a proxy credential from `~/.netrc`,
not from an environment variable, so `credential_env` is not used for go and `Invoke-Go` says so when it is set.

## NuGet (bcl)

Override `.catzc/configs/bcl.yml`:

```yaml
package_source:
  name: widget-feed
  url: https://feeds.example/api/nuget/v3/index.json
  credential_env: WIDGET_FEED_TOKEN
```

`New-NuGetConfig` renders `nuget.config` with the source as its one package source, and the `auditSources` element cleared. The restore that
a dotnet build runs reads it. Check that `nuget.config` holds
`<add key="widget-feed" value="https://feeds.example/api/nuget/v3/index.json" />` and, with a credential, a `packageSourceCredentials` entry
whose password is `%WIDGET_FEED_TOKEN%`.

## PowerShell vendor modules

Override `.catzc/configs/vendor.yml`:

```yaml
package_source:
  name: widget-feed
  url: https://feeds.example/api/psresource/v2
```

`Resolve-VendorRepository` registers a trusted PSResource repository of that name and address the first time it is needed, and
`Install-VendorModule` saves from it. Fetch with:

```powershell
Install-VendorModule
```

Check with `Get-PSResourceRepository -Name widget-feed`, which shows the address, and the message `Registered vendor repository` that the
first run writes. A feed that needs a credential names its variable in `credential_env`; `Install-VendorModule` reads the variable at call
time and passes it to `Save-PSResource` as the password of the user `token`, and a named but unset variable stops the install naming it.

## Bash (the bats runner)

Override `.catzc/configs/bash.yml`. The `url` is the base the bats-core archive is downloaded from:

```yaml
package_source:
  name: widget-feed
  url: https://feeds.example/api/github-mirror
  credential_env: WIDGET_FEED_TOKEN
```

`Update-BatsVendor` fetches `<url>/bats-core/bats-core/archive/refs/tags/v<version>.tar.gz` and verifies the download against the pinned
checksum. With a credential, the download sends a bearer header. Fetch with:

```powershell
Update-BatsVendor
```

Check that the command ends with `bats-core ... vendored at`, the checksum having held.

## Bicep

Override `.catzc/configs/bicep.yml`. The `url` is a registry host with the module path after it, so a private container registry serves
`br:` module references:

```yaml
package_source:
  name: widget
  url: widget.azurecr.io/bicep
```

`New-BicepConfig` renders the bicep track's own `bicepconfig.json` (`infrastructure/bicepconfig.json` here) with a `moduleAliases.br.<name>`
entry for that registry and the `analyzers` block from the same config (the core analyzer, enabled, not verbose, when `analyzers` is left
out). Render with:

```powershell
Build-RootConfig -Path infrastructure/bicepconfig.json
```

Check with `Get-Content infrastructure/bicepconfig.json`, which shows the alias with `"registry": "widget.azurecr.io"` and
`"modulePath": "bicep"`. Sign-in to the registry is the Azure CLI's, so this source has no credential variable.

## Credentials

`credential_env` is the name of an environment variable, never its value. Set the variable in the shell or the pipeline before the fetching
command ([ADR-AUTO-PKGSRC-CREDENTIALBYNAME](../../drs/automation/package-sources.md#rule-adr-auto-pkgsrc-credentialbyname)):

```powershell
$env:WIDGET_FEED_TOKEN = '<token from your secret store>'
```

How each tool receives it:

- `.npmrc` carries `${VAR}`, which npm expands at run time.
- `nuget.config` carries `%VAR%`, which NuGet expands.
- `Install-PythonWorkspace` exports uv's `UV_INDEX_<NAME>_USERNAME` and `UV_INDEX_<NAME>_PASSWORD` for its one sync, `<NAME>` being the
  source's `name` in upper case with `-` as `_`, and restores the environment afterwards.
- `Save-VerifiedDownload` sends the bats download a bearer header.
- `Install-VendorModule` passes `Save-PSResource` a credential with the user `token` and the variable's value.
- Go reads `~/.netrc`.

A command whose source names a variable that is unset fails fast and names it: `Install-PythonWorkspace` and `Save-VerifiedDownload` do
today. A token is never written to a file.

## What stays offline

The fetching commands above are the build's online steps, and the only commands that reach a source
([ADR-AUTO-PKGSRC-BUILDRESOLVESTESTOFFLINE](../../drs/automation/package-sources.md#rule-adr-auto-pkgsrc-buildresolvestestoffline)). Run
them before the tests. Tests never reach a source
([ADR-AUTO-NET-TESTSOFFLINE](../../drs/automation/network-calls.md#rule-adr-auto-net-testsoffline)), and the exporters resolve from the
package manager's cache.

Only the core is vendored: the pwsh modules under `pwsh/.vendor` and the bats runner
([ADR-AUTO-PKGSRC-COREVENDOREDONLY](../../drs/automation/package-sources.md#rule-adr-auto-pkgsrc-corevendoredonly)). A language module's
dependencies come from its package manager and the source you configured.
