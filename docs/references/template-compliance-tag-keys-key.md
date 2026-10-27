# The `tag_keys` key of `template-compliance.yml`: what it said, and the schema that replaces it

## What the key said

`template-compliance.yml` named the CAF tag keys every taggable resource in a compiled template had to carry:

```yaml
tag_keys: [workload, environment, owner, cost-center, criticality, data-classification]
```

`TemplateComplianceConfig` carried it, with the same six keys as its default, and `Test-BicepTemplateCompliance` reported a taggable
resource whose resolved tags missed any of them ("misses the CAF tag(s) …"). It checked presence only: a key with a misspelled or mixed-case
value passed.

## Why it goes

The CAF tag keys were then declared twice: here for the compliance quality gate, and by convention in every template configuration. The tag-schema
step of the Azure gaps plan declares one schema that also states each key's allowed values and the lowercase rule, so a second list of the
keys would drift from it ([one-living-version](../drs/principles/one-living-version.md)).

## What replaces it

The `tags` section of `azure.yml`, typed by `AzureConfig`: the required keys, the closed value set of `environment`, `criticality` and
`data-classification`, lowercase keys and values, and the lowercase provenance tag names. `AzureConfig.TagErrors` reports a dropped key, a
value outside its set or a non-lowercase key or value. `Test-BicepTemplateCompliance` calls it on every resolved tags value instead of
reading `tag_keys`. The key leaves `TemplateComplianceConfig` and `template-compliance.yml`; the Azure tagging decision record absorbs this
page when it is next restated.
