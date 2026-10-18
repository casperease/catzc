---
catzc:
  immutable:
    with_body_sha: e252bfb86f50
    repo_status: locked
    path: docs/references/automation/catzc-tooling-core/private/Assert-ToolVersion.ps1.md
    folder: docs/references/automation/catzc-tooling-core/private
    name: assert-tool-version-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-PWSH-CACHE#4
---

# automation/Catzc.Tooling.Core/private/Assert-ToolVersion.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Asserts the installed version of a tool matches its locked version.

### description

Checks once per session and caches the result. Subsequent calls for the same tool return immediately.

Devbox lever: a tool may declare an optional `devbox_version` in tools.yml. OUTSIDE a CI pipeline (Test-IsRunningInPipeline is false) an
installed version matching EITHER the locked `version` or the `devbox_version` prefix is accepted, so a devbox can run a functional off-pin
tool for local pre-commit tooling. A pipeline session ignores the lever and enforces the locked `version` alone, keeping main/master builds
deterministically locked.

### parameter Tool

The snake_case tool key as defined in tools.yml.

## comment:1

Above `$script:toolVersionCache = @{}`, written with `#`.

```text
strict-clean probe of the lazy cache entry
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```

## comment:2

Above `$accepted = [System.Collections.Generic.List[string]]::new()`, written with `#`.

```text
Accepted prefixes: always the locked version; on a devbox (non-pipeline) also the optional devbox_version
lever from tools.yml. A pipeline enforces the locked version alone.
```
