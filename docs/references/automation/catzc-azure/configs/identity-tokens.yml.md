---
catzc:
  derived:
    path: docs/references/automation/catzc-azure/configs/identity-tokens.yml.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "52298307f3b5"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Azure/configs/identity-tokens.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `tokens:`, written with `#`.

```text
The live production identities this module's configs carry — the customers, the org, the subscriptions and the
environments — which a hermetic logic test must never name; it uses the fixture the suggestion names instead
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)). Get-LiveIdentityTokens reads every
module's identity-tokens.yml, so the gate follows the shipped config without naming it. Validated on load by the
IdentityTokensConfig type: path walks the config by key ('*' = every entry of a map), take is value (default) or
keys, match is exact (default) or position, skip_when leaves out a map entry that sets that key true.
```

## comment:2

Above `- config: azure` (occurrence 3), written with `#`.

```text
Environment names are ambiguous words ('test', 'dev'), so they match only when bound to an identity parameter.
The per-subscription identity environments (nsub/psub) are shared structural vocabulary, not an identity.
```
