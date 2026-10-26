# pwsh/Base.Exporter/Resolve-CatzcBuildVersion.ps1

The command that resolves the version a Catzc build carries: the devbox placeholder, a version calculated for a pipeline build, or an
explicit one.

## help

### synopsis

Resolves the version a Catzc build carries — the devbox placeholder, a calculated pipeline version, or an explicit MAJOR.MINOR.PATCH.

### description

The one place a build version is decided
([ADR-AUTO-BUNDLE-AUTOVERSION](../../../drs/automation/platform-bundle.md#rule-adr-auto-bundle-autoversion)); every value comes from
configs/exporter.yml (Get-Config -Config exporter):

```text
-Version auto, on a devbox    the fixed direct_install_version placeholder (6.6.666), announced by a yellow
                              Write-Message notice — never Write-Warning, which terminates under the catzc
                              session's preferences
                              ([ADR-PWSH-ERROR-STOPONWARNING](/docs/drs/automation/pwsh/error-handling.md#rule-adr-pwsh-error-stoponwarning)). A rebuild overwrites it in place.
-Version auto, in a pipeline  <the bundle's MAJOR.MINOR (exporter.yml bundles.<name>.version)>.<first-parent
                              commit count of HEAD>, so the same commit always gets the same version and
                              versions rise along main. Each bundle has its own MAJOR.MINOR line. Needs the full
                              history; a shallow clone throws instead of miscounting.
-Version <x.y.z>              honoured as given once asserted numeric MAJOR.MINOR.PATCH (a valid module
                              version); a pipeline build naming the placeholder throws — it never leaves a
                              devbox.
```

### parameter `Version`

'auto' (default) or an explicit numeric MAJOR.MINOR.PATCH.

### parameter `Bundle`

The bundle whose version line a pipeline build follows (an exporter.yml bundles key). Defaults to default_bundle.

### parameter `Silent`

Suppress the local-build notice.

### example 1

```powershell
Resolve-CatzcBuildVersion                  # devbox -> 6.6.666 (with the notice); pipeline -> e.g. 0.1.427
```

### example 2

```powershell
Resolve-CatzcBuildVersion -Bundle azure    # pipeline -> azure's MAJOR.MINOR plus the commit count
```

### example 3

```powershell
Resolve-CatzcBuildVersion -Version 1.2.3   # -> 1.2.3
```
