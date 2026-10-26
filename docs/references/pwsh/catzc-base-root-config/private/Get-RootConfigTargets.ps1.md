# pwsh/Catzc.Base.RootConfig/private/Get-RootConfigTargets.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Resolves the rootconfig registry into the list of opted-in managed root files Build-RootConfig generates.

### description

Filters the validated registry (Get-Config -Config rootconfig) down to the entries with optIn true — the files the automation actually
manages. Opted-out entries are inert: validated for shape when the config loads, but neither written nor treated as owned. The full registry
semantics live in configs/rootconfig.yml; see [ADR-REPO-ROOTCFG](../../../../drs/repository/generated-root-configs.md).

With -FollowMix, an entry that is an engine's importer entry is kept only when one of the engines it serves is in the session's import mix
([ADR-AUTO-IMPORTER-ENTRIESFOLLOWMIX](../../../../drs/automation/importer.md#rule-adr-auto-importer-entriesfollowmix)), so `importer.sh` is
materialised only with a POSIX engine in the mix.

### parameter `Config`

The parsed rootconfig config (Get-Config -Config rootconfig): a `{ files }` object.

### parameter `FollowMix`

Drop an engine's importer entry when none of its engines is in the mix. Only Build-RootConfig, which materialises the files, passes it; a
committed generated file reads the mix-independent list, so its content never depends on a session's mix.

### outputs

`[object[]]` The opted-in RootConfigFile entries, in registry order.

## comment:1

Above `$mixEngines = $null`, written with `#`.

```text
An engine's importer entry follows the session's mix: it is managed only when one of the engines it serves is in
the mix.
```
