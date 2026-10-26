# pwsh/Base.Git/types/GitIgnoreConfig.cs

The typed record of the gitignore registry (`configs/gitignore.yml`) and its validity rules.

## Shape and validation

It requires a `sections` list of explained pattern groups, each validated by `GitIgnoreSection`, with unique section ids. Constructing an
instance validates the registry, collecting every malformed section into one error, and exposes the parsed sections to the renderer
(`New-GitIgnore`).

## Registration

It is registered as the `gitignore` config's type override in `Catzc.Base.Config/configs/configs.yml`. See
[ADR-CONF-LOADING](../../../../drs/configuration/module-config-loading.md) and
[ADR-REPO-ROOTCFG](../../../../drs/repository/generated-root-configs.md).
