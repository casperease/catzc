---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/types/IdentityTokenRule.cs.md
    kind: comment-page
    body_sha: "0c7e93cf776e"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/types/IdentityTokenRule.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One live-identity declaration of an identity-tokens source: which values of one of the declaring module's own
configs are live production identities that a hermetic logic test must never name
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)). Get-LiveIdentityTokens walks
`path` in the named config and yields each token with this rule's kind, suggestion and match mode.

  config     required; the config the tokens come from (owned by the declaring module)
  path       required; dot-separated key path into that config; a '*' segment walks every entry of a map
  take       'value' (default): the scalar at the path; 'keys': the keys of the map at the path
  kind       required; the token kind a finding reports (customer-key, org, environment, ...)
  suggest    required; the fixture the test should use instead
  match      'exact' (default): flagged wherever it appears as a literal; 'position': flagged only when bound to
             an identity parameter (-Environment/-Env/-Shortcode), for ambiguous words such as 'test'
  skip_when  optional; a key that, when true on a map entry the path walks, leaves that entry out
```
