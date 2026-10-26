# pwsh/Base.QualityGates/types/IdentityTokenRule.cs

One live-identity declaration of an identity-token source: which values of one of the declaring module's own configs are live production
identities that a hermetic logic test must never name
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
`Get-LiveIdentityTokens` walks `path` in the named config and yields each token with this rule's kind, suggestion and match mode.

## Keys

- **`config`** — required; the config the tokens come from, owned by the declaring module.
- **`path`** — required; a dot-separated key path into that config. A `*` segment walks every entry of a map.
- **`take`** — `value` (default) takes the scalar at the path; `keys` takes the keys of the map at the path.
- **`kind`** — required; the token kind a finding reports (customer-key, org, environment, and so on).
- **`suggest`** — required; the fixture the test should use instead.
- **`match`** — `exact` (default) flags the token wherever it appears as a literal. `position` flags it only when it is bound to an identity
  parameter (`-Environment`, `-Env`, `-Shortcode`), for ambiguous words such as `test`.
- **`skip_when`** — optional; a key that, when true on a map entry the path walks, leaves that entry out.
