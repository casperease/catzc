# pwsh/Azure.DevOps/types/YamlClassificationResult.cs

The typed outcome of classifying one YAML file: the coarse kind plus, for a template, the body sub-kind.

## Construction

The constructor takes the two values as strings and parses them to the enums, so a caller holding string literals binds directly without
first converting to enum values.
