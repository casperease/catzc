# pwsh/Base.ModuleSystem/configs/artifacts.yml

The publish targets for versioned, immutable module-manifest artifacts: the feeds a CI build promotes the gold manifest to. The keys load
and validate through `Get-Config -Config artifacts`, but no publish code reads them yet, so they are inert configuration surface.

## Targets

Three targets are declared, `ado`, `github` and `artifactory`, each with an `enabled` switch and its own coordinates (organization, project
and feed; owner, repository and feed; url and repository). The shape and the load-time checks live on the typed record
([ArtifactsConfig](../types/artifacts-config.md)). The publish step and the pipeline that promotes the gold artifact are where the keys
will be read; the build verification test is the stage that produces the gold output
([ADR-AUTO-TEST-BUILDVERIFICATIONTEST](../../../../drs/automation/test-automation.md#rule-adr-auto-test-buildverificationtest)).
