# pwsh/Azure.DevOps/types/YamlTemplateType.cs

The enum of the sub-kind of a Template YAML file, determined by which body key it exposes: `stages`, `jobs`, `steps` or `variables`. Callers
carry it as a `Nullable<YamlTemplateType>`; null means the file is not a Template, so it is a Pipeline or Unknown.
