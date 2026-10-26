# pwsh/Azure.DevOps/configs/identity-tokens.yml

The live production identity this module's config carries, the Azure DevOps project, which a hermetic logic test must never name
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).

## Reading

`Get-LiveIdentityTokens` reads this file together with every other module's `identity-tokens.yml`, and the `IdentityTokensConfig` type
validates it. Each entry names the config, the key path inside it, the token kind and a neutral suggestion to use in a fixture instead.
