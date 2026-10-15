# docs/references/automation/catzc-tooling-core/private/Assert-ToolVersion.ps1.md

`automation/Catzc.Tooling.Core/private/Assert-ToolVersion.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Checks once per session and caches the result. Subsequent calls
for the same tool return immediately.

Devbox lever: a tool may declare an optional `devbox_version` in tools.yml. OUTSIDE a CI pipeline
(Test-IsRunningInPipeline is false) an installed version matching EITHER the locked `version` or the
`devbox_version` prefix is accepted, so a devbox can run a functional off-pin tool for local pre-commit
tooling. A pipeline session ignores the lever and enforces the locked `version` alone, keeping
main/master builds deterministically locked.
```

## comment:2

Above `$script:toolVersionCache = @{}`.

```text
strict-clean probe of the lazy cache entry
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```

## comment:3

Above `$accepted = [System.Collections.Generic.List[string]]::new()`.

```text
Accepted prefixes: always the locked version; on a devbox (non-pipeline) also the optional devbox_version
lever from tools.yml. A pipeline enforces the locked version alone.
```
