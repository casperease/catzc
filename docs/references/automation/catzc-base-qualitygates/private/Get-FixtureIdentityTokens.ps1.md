# docs/references/automation/catzc-base-qualitygates/private/Get-FixtureIdentityTokens.ps1.md

`automation/Catzc.Base.QualityGates/private/Get-FixtureIdentityTokens.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Symmetric to Get-LiveIdentityTokens: the authoritative source is the config itself, here the FIXTURE
configs under every `tests/assets/config/` (the `azure.yml` / `customer.yml` a logic test redirects to).
Reading them means the fixture set is always current — a fixture customer added to a test config is
immediately banned from shipped config. Each fixture file is constructed as the C# config type the config
registry (configs.yml) registers for its name, exactly as Get-Config constructs a shipped config, so a
malformed fixture fails the same way a malformed shipped config does. A small set of neutral in-memory
fixtures that never live in a config file (widget/gadget/faketool) is added explicitly.

Backs Test-ConfigIdentityHygiene: a shipped `configs/*.yml` or `infrastructure/**` file whose parsed VALUES
(or keys) contain one of these tokens has a test fixture where a live identity belongs, and a fixture token
that is also a live identity (Get-LiveIdentityTokens) is no fixture at all.
```

## comment:2

Above `Assert-SourceTree`.

```text
Every fixture config tree (tests/assets/config/) — the identity-bearing azure.yml and customer.yml a
logic test redirects Get-Config to. Enumerate all of them and union their identities. Test fixtures live
only in the catzc source tree (tests never ship in a build), hence the guard.
```

## comment:3

Above `foreach ($token in 'widget', 'gadget', 'faketool') {`.

```text
Neutral in-memory fixtures that never live in a config file — the globset and tool fixtures logic tests
construct inline.
```
