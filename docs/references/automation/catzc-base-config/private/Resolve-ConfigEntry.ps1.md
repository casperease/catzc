# docs/references/automation/catzc-base-config/private/Resolve-ConfigEntry.ps1.md

`automation/Catzc.Base.Config/private/Resolve-ConfigEntry.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Scans <module>/configs/*.yml under the loaded code root (Get-CatzcModulesRoot — the source tree's
automation/ or a built package) once (cached) into a name -> entries index, and resolves a
requested name to a single @{ Name; Module; Path }. -Module disambiguates a name present in more than one
module. In build mode the scan also covers a consumer overlay's local modules — the folders under
.catzc/automation/ that name no bundled module ([ADR-AUTO-OVERLAY](/docs/adr/automation/consumer-overlay.md))
— so a local module's configs are found like any module's. Throws when the name is unknown or ambiguous. -All instead returns every entry of the name, one
per owning module sorted by module name (ordinal), and nothing when no module has it — the listing for a
config several modules opt into by shipping it. Mock this to redirect a config to a fixture in logic tests
(see ADR test-automation).
```

## comment:2

Above `$script:configIndex = @{}`.

```text
strict-clean probe of the lazy cache entry
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```
