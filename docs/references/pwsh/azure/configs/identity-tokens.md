# pwsh/Azure/configs/identity-tokens.yml

The live production identities this module's configs carry: the customers, the org, the subscriptions and the environments. A hermetic logic
test must never name them, and uses the fixture the entry's suggestion names instead
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).

## how it is read

`Get-LiveIdentityTokens` reads every module's `identity-tokens.yml`, so the check follows the shipped config without naming it. The
`IdentityTokensConfig` type validates the file on load. Each entry has these keys:

- `path` walks the config by key, and `*` stands for every entry of a map.
- `take` is `value`, the default, or `keys`.
- `match` is `exact`, the default, or `position`.
- `skip_when` leaves out a map entry that sets that key true.

## environment names

Environment names are ambiguous words such as `test` and `dev`, so they match only when bound to an identity parameter. The per-subscription
identity environments, `nsub` and `psub`, are shared structural vocabulary and not an identity, so `skip_when` leaves them out.
