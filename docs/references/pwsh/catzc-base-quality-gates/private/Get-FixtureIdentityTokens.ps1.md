# pwsh/Base.QualityGates/private/Get-FixtureIdentityTokens.ps1

The set of identity tokens the hermetic tests use: the customers, subscriptions, org, tenants and environments of the fixture configs, plus
a few neutral names. Test-ConfigIdentityHygiene bans each one from a shipped config value, so a fixture never stands where a live identity
belongs.

## help

### synopsis

Derives the set of TEST-fixture identity tokens — the deliberately-distinct customers, subscriptions, org, tenants, and environments the
hermetic tests use — that must NEVER appear in a shipped config value — the reverse of Get-LiveIdentityTokens.

### description

Symmetric to Get-LiveIdentityTokens: the authoritative source is the config itself, here the FIXTURE configs under every
`tests/assets/config/` (the `azure.yml` / `customer.yml` a logic test redirects to). Reading them means the fixture set is always current —
a fixture customer added to a test config is immediately banned from shipped config. Each fixture file is constructed as the C# config type
the config registry (configs.yml) registers for its name, exactly as Get-Config constructs a shipped config, so a malformed fixture fails
the same way a malformed shipped config does. A small set of neutral in-memory fixtures that never live in a config file
(widget/gadget/faketool) is added explicitly.

Backs Test-ConfigIdentityHygiene: a shipped `configs/*.yml` or `infrastructure/**` file whose parsed VALUES (or keys) contain one of these
tokens has a test fixture where a live identity belongs, and a fixture token that is also a live identity (Get-LiveIdentityTokens) is no
fixture at all.

It rests on [ADR-REPO-LANG](../../../../drs/repository/domain-language-separation.md).

### outputs

`[string[]]` the distinct fixture identity tokens.

## the fixture config trees

Every `tests/assets/config/` tree holds the identity-bearing `azure.yml` and `customer.yml` that a logic test redirects Get-Config to. The
function enumerates all of them and unions their identities. Test fixtures live only in the catzc source tree, because tests never ship in a
build, hence the source-tree guard at the start. Environments the config marks `per_subscription` are left out: those names are shared
structural vocabulary, not a fixture identity.

## neutral in-memory fixtures

`widget`, `gadget` and `faketool` are added explicitly. They are the globset and tool fixtures that logic tests construct inline and that
never live in a config file.
