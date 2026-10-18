# pwsh/Catzc.Azure.DevOps/configs/identity-tokens.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `tokens:`, written with `#`.

```text
The live production identity this module's config carries — the ADO project — which a hermetic logic test must
never name ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)). Read by
Get-LiveIdentityTokens with every other module's identity-tokens.yml; validated by the IdentityTokensConfig type.
```
