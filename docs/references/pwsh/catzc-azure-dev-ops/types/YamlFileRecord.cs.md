# pwsh/Azure.DevOps/types/YamlFileRecord.cs

The typed record of one YAML file found by scanning a repository, with the classification derived from its content. It is the
filesystem-side view of a pipeline or template, before any cross-reference to Azure DevOps registration.

## Properties

- **`TopLevelKeys`** — the file's top-level YAML keys, the evidence the classification was derived from. Never null; an empty array when
  there were none.

## Construction

The constructor takes the classification and template type as strings and parses them to the enums, so a producer, or a test mock, that
supplies string literals binds without first converting to enum values.
