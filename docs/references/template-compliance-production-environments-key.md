# The `production_environments` key of `template-compliance.yml`: what it said, and the fact that replaces it

## What the key said

`template-compliance.yml` listed the environments the template compliance check treats as production:

```yaml
production_environments: [prod]
```

`TemplateComplianceConfig` carried it, with `[prod]` as its default, and its `IsProduction(environment)` method answered from the list.
`Test-BicepTemplateCompliance` asked it once per slot, to hold a production slot to the production-only rules.

## Why it goes

Production is a fact about an environment, and `azure.yml`, the identity model, is where environments are declared. With the list in the
compliance config, the one fact lived in a config that only the compliance check reads, and any other reader (the production database's
metric alerts) would have had to depend on that check's config or declare the fact a second time
([one-living-version](../drs/principles/one-living-version.md)).

## What replaces it

`production: true` on the environment's record in `azure.yml` (`prod`), read through `AzureEnvironmentRecord.production`, whose default,
false, is declared once on the type. `Test-BicepTemplateCompliance` reads it from the slot's environment, and the build derives the
production database alerts' switch from it in the same way, so no slot writes it. The key, `production_environments`, and
`TemplateComplianceConfig.IsProduction` are deleted.
