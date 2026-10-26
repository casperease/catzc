# pwsh/Base.RootConfig/types/RootConfigFiles.cs

The typed record of the root-config registry (`configs/rootconfig.yml`) and its validity rules.

## Shape and validation

It requires a `files` list of managed root-file entries, each validated by `RootConfigFile`, with unique targets. Constructing an instance
validates the registry, collecting every malformed entry into one error, and exposes the parsed entries to the generator
(`Build-RootConfig`).

## Registration

It is registered as the `rootconfig` config's type override in `Catzc.Base.Config/configs/configs.yml`. See
[ADR-CONF-LOADING](../../../../drs/configuration/module-config-loading.md) and
[ADR-REPO-ROOTCFG](../../../../drs/repository/generated-root-configs.md).

## Settings paths

`SpellingConfigPath` and its sibling name the spell checker's and the Markdown linter's settings: root files `rootconfig.yml` materialises,
named here once for every gate that runs them.
