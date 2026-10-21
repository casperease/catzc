# pwsh/Catzc.Base.QualityGates/types/IdentityTokensConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One identity-tokens source (a module's configs/identity-tokens.yml): the live production identities that module's
own configs carry, declared as rules (IdentityTokenRule) so the logic-test identity gate never names another
module's config itself. Any module that owns live identities ships one; Get-LiveIdentityTokens lists the owners
(Get-Config -Config identity-tokens -ListOwners) and reads each with -Module, so a bundle without those modules
simply has no tokens from them. Registered in Catzc.Base.Config/configs/configs.yml
(type: Catzc.Base.QualityGates.IdentityTokensConfig).

Load-time rules, collected into one throw: only the top-level key 'tokens', a non-empty list, every entry a
well-formed IdentityTokenRule. That a rule's config is owned by the declaring module is checked where both are
known, in Get-LiveIdentityTokens.
```
