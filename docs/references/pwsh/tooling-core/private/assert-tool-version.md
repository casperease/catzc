# pwsh/Tooling.Core/private/Assert-ToolVersion.ps1

The private version check behind `Assert-Tool`: it compares the installed version of a tool with the locked one and caches the verdict for
the session.

## help

### synopsis

Asserts the installed version of a tool matches its locked version.

### description

Checks once per session and caches the result. Subsequent calls for the same tool return immediately.

Devbox lever: a tool may declare an optional `devbox_version` in tools.yml. OUTSIDE a CI pipeline (Test-IsRunningInPipeline is false) an
installed version matching EITHER the locked `version` or the `devbox_version` prefix is accepted, so a devbox can run a functional off-pin
tool for local pre-commit tooling. A pipeline session ignores the lever and enforces the locked `version` alone, keeping main/master builds
deterministically locked.

### parameter `Tool`

The snake_case tool key as defined in tools.yml.

## Cache

The cache entry is created lazily and probed in a strict-clean way
([ADR-PWSH-CACHE-STRICTSAFEPROBE](../../../../drs/automation/pwsh/script-scope-caching.md#rule-adr-pwsh-cache-strictsafeprobe)).

## Accepted prefixes

The locked version is always accepted. On a devbox, outside a pipeline, the optional `devbox_version` lever from `tools.yml` is accepted
too. A pipeline enforces the locked version alone.
