# pwsh/Catzc.Base.Contracts/configs/contracts.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `addressing: full-path`, written with `#`.

```text
Contracts settings for Get-Contract ([ADR-REPO-CONTRACT](/docs/adr/repository/api-contracts.md)).

Every key is optional: an omitted key takes the sensible default declared once on
Catzc.Base.Contracts.ContractsConfig
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)), and a Get-Contract parameter
overrides the resolved value per call
([ADR-PWSH-PARAM-RESOLUTIONORDER](/docs/adr/pwsh/parameter-design.md#rule-adr-pwsh-param-resolutionorder)).
```

## comment:2

Above `addressing: full-path`, written with `#`.

```text
How one contract asset addresses many files
([ADR-REPO-CONTRACT-CONFIGUREDADDRESSING](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract-configuredaddressing)):
  full-path      an asset addresses the one real file at its own path (built; the default)
  manifest-glob  a glob in a manifest names the files (declared, not built: selecting it throws NotImplemented)
  per-folder     one asset applies to each file of its folder (declared, not built: selecting it throws NotImplemented)
```

## comment:3

Above `target_roots:`, written with `#`.

```text
Each owning module's target root: the repository-relative folder its assets' paths are relative to
([ADR-REPO-CONTRACT-LAYOUT](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract-layout)). A module not named here takes
the default, the repository root. contracts/ holds no dot-prefixed folder
([ADR-REPO-CONTRACT-NODOTFOLDERS](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract-nodotfolders)), so a module whose files sit
under a dot-prefixed root names that root here.
```
