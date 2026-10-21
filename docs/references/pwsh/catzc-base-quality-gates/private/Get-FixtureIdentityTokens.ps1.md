# pwsh/Catzc.Base.QualityGates/private/Get-FixtureIdentityTokens.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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

It rests on [ADR-REPO-LANG](../../../../adr/repository/domain-language-separation.md).

### outputs

`[string[]]` the distinct fixture identity tokens.

## comment:1

Above `Assert-SourceTree`, written with `#`.

```text
Every fixture config tree (tests/assets/config/) — the identity-bearing azure.yml and customer.yml a
logic test redirects Get-Config to. Enumerate all of them and union their identities. Test fixtures live
only in the catzc source tree (tests never ship in a build), hence the guard.
```

## comment:2

Above `foreach ($token in 'widget', 'gadget', 'faketool') {`, written with `#`.

```text
Neutral in-memory fixtures that never live in a config file — the globset and tool fixtures logic tests
construct inline.
```
