# pwsh/Base.QualityGates/types/IdentityTokensConfig.cs

The typed record for one identity-tokens source, a module's `configs/identity-tokens.yml`: the live production identities that module's own
configs carry, declared as rules (`IdentityTokenRule`) so the logic-test identity gate never names another module's config itself. Any
module that owns live identities ships one. It is registered in `Catzc.Base.Config/configs/configs.yml`.

`Get-LiveIdentityTokens` lists the owners (`Get-Config -Config identity-tokens -ListOwners`) and reads each with `-Module`, so a bundle
without those modules simply has no tokens from them.

## Validation

Loading collects its violations into one throw: the only top-level key is `tokens`, a non-empty list, and every entry is a well-formed
`IdentityTokenRule`. That a rule's config is owned by the declaring module is checked where both are known, in `Get-LiveIdentityTokens`.
