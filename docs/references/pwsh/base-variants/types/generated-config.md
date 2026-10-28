# pwsh/Base.Variants/types/GeneratedConfig.cs

One module's writers of generated files: each a row keyed by the writer's name, with its class, its inputs, its outputs and the inputs each
output reads, its check and the command overrides of its head
([ADR-REPO-ROOTCFG-ONECLASSPERWRITER](../../../../drs/repository/generated-root-configs.md#rule-adr-repo-rootcfg-oneclassperwriter)). Every
generating module keeps its own `configs/generated.yml`, and `Get-GeneratedTarget` reads every owner's file alongside `rootconfig.yml` and
`readme.yml`. A row that `expands` its instances from a config of its own, such as `Build-Readme` from `readme.yml`, gives no target of its
outputs there, since that config names each instance.
