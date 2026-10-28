# pwsh/Base.QualityGates/Test-ConfigIdentityHygiene.ps1

The reverse of Test-LogicTestIdentity: it checks that no shipped config carries a test-fixture identity in its data, which closes the other
half of the neutral-fixture rule.

## help

### synopsis

Checks that no shipped config carries a test-fixture identity in its data, the reverse of Test-LogicTestIdentity, closing the other half of
the language-zone separation.

### description

A shipped `configs/*.yml` or `infrastructure/**` file is the live zone: it names real identities. A fixture identity (acme/globex, fxo,
alpha, core_lower, widget, …) appearing in one is a leak — a test fixture committed as production data. The forbidden set is DERIVED from
the fixture configs (Get-FixtureIdentityTokens), so it is always current.

The scan parses each config with the YAML reader and inspects the parsed KEYS and scalar VALUES — never the raw text — so it is
comment-blind by construction: a config comment illustrating `[acme, globex]` is not data and is not flagged, while a real
`have_customers: [acme]` value is. The terminology registry (which DEFINES the fixture tokens) is excluded.

It also checks that the two identity sets are disjoint: a fixture token that is also a live identity (Get-LiveIdentityTokens, derived from
the shipped config) is an issue, whatever -Path names.

A quality gate ([ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)): it ends through
Write-QualityGateReport, which writes out/test-config-identity-hygiene/, prints every finding, and throws once listing them all; -PassThru
returns the result instead. It reads the shipped config, so a Pester test wrapping it is `integrity`. It needs the source tree: the fixture
identities live in the repository's tests/, so the source-tree guard (Assert-SourceTree) throws in build mode.

It rests on [ADR-REPO-LANG](../../../drs/repository/domain-language-separation.md).

### parameter `Path`

Config files to check. Defaults to every module `configs/*.yml` (except the terminology registry) and every `infrastructure/**` yml.

### parameter `OutputFolder`

The report base folder. Defaults to `<out>/test-config-identity-hygiene`.

### parameter `PassThru`

Return a result object ({ Subject; IssueCount; Issues; ReportPath; FileCount; LiveTokens }) instead of throwing.

### outputs

None (throws on findings), or the result object with -PassThru.

## Where configs are

A module's configs sit three levels below `pwsh/` (module, `configs`, file). An infrastructure place's yml files reach four levels
(template, configuration, customer, file). A config is one file or a folder of parts (`configs/<name>/*.yml`), and the terminology parts
declare the fixture tokens themselves, so they are left out of the check.
