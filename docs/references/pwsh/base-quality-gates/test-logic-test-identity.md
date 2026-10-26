# pwsh/Base.QualityGates/Test-LogicTestIdentity.ps1

The quality gate for neutral fixtures: it checks that no logic test names a live production identity, such as a real customer, subscription,
org, template or ADO project, as a code string.

## help

### synopsis

Checks that no logic test names a live production identity (a real customer, subscription, org, template or ADO project) as a code string
literal, the tag-aware, comment-blind enforcer of the separation of the test and live zones.

### description

The forbidden set is DERIVED from the shipped config (Get-LiveIdentityTokens), so it is always current — add a customer to customer.yml and
it is immediately banned from logic tests. Each test file is classified by its Pester tags from the AST (Get-LogicTestIdentityFinding): a
pure-logic file is scanned for live-identity string literals; an integrity or `*.Integrity.Tests.ps1` file is skipped; a file mixing both is
reported as needing a split.

This is itself an INTEGRITY check (it reads the shipped config and the whole test tree), so it is tagged `integrity` where a Pester test
wraps it. A quality gate ([ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)): it ends
through Write-QualityGateReport, which writes out/test-logic-test-identity/, prints every finding as '`<file>:<line>`: `<message>`', and
throws once listing them all; -PassThru returns the result instead.

Stage 1 matches the DISTINCTIVE identities exactly (customers, subscriptions, org, templates, deployable units, ADO project); environment
names (dev/test/preprod/prod) are a later, position-aware stage.

It rests on
[ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities) and
[ADR-REPO-LANG](../../../drs/repository/domain-language-separation.md).

### parameter `Path`

Test files to check. Defaults to every `*.Tests.ps1` under pwsh/ (excluding vendored modules) — the catzc source tree, so the default needs
the source mode (Assert-SourceTree); an explicit -Path works in either.

### parameter `OutputFolder`

The report base folder. Defaults to `<out>/test-logic-test-identity`.

### parameter `PassThru`

Return a result object ({ Subject; IssueCount; Issues; ReportPath; FileCount }) instead of throwing.

### outputs

None (throws on findings), or the result object with -PassThru.

### example 1

```powershell
Test-LogicTestIdentity
```

### example 2

```powershell
$r = Test-LogicTestIdentity -PassThru; $r.Issues
```

## Which files are parsed

Only files that could carry a finding are parsed, a provable superset, so no leak is skipped. A finding needs either an exact-match token as
a string-literal value, which then appears word-bounded in the source (`'apex'`, `-Customer apex`), or an ambiguous env or shortcode bound
to an identity parameter, whose name is then in the source. Every other file cannot match and is skipped without a parse. The AST parse is
the whole cost, and about 95% of the tree holds no live token at all, so the cheap text scan pays off. Word boundaries keep two-character
shortcodes from matching inside ordinary words.

## Where tests are

Test files reach four levels below `pwsh/` (module, `tests`, `types`, file), and the walk prunes vendored modules.
