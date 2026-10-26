# pwsh/Base.QualityGates/private/Get-LiveIdentityTokens.ps1

Lists the live production identities of the shipped config, which a hermetic logic test must never name. The modules that own the configs
declare which values are identities, so the list is never kept by hand.

## help

### synopsis

Derives the set of LIVE production identity tokens — the identities the owning modules declare for their shipped config, and the shipped
template names — that a hermetic LOGIC test must never name.

### description

The authoritative source of "what is a live identity" is the shipped config itself, not a hand-kept list: reading it here means the
forbidden set is always current (add a customer to customer.yml and it is automatically banned from logic tests). Which values are
identities is declared by the module that owns them, in its configs/identity-tokens.yml (IdentityTokensConfig): this function lists those
owners and walks each declared path, so it never names another module's config and a bundle without those modules simply yields no tokens
from them. A declaration may name only a config its own module owns. Every value is read through Get-Config (the one global reader,
[ADR-CONF-LOADING](../../../../drs/configuration/module-config-loading.md)), so a test isolates this function by mocking Get-Config to
fixtures.

Each declared rule sets a match mode. A distinctive identity matches `exact`: it is flagged wherever it appears as a literal. An ambiguous
one, such as an environment name ('test' is pervasive in test code), matches by `position`: it is flagged only when bound to an identity
parameter. The shipped template names are added after the declared tokens; deployable-unit and pipeline names are left out, because the
generic ones are structural folder names. Each record carries its Source and a Suggest string so a finding can name the fixture the test
should have used.

Backs Test-LogicTestIdentity ([ADR-REPO-LANG](../../../../drs/repository/domain-language-separation.md)): a logic test whose AST contains a
string literal equal to one of these tokens (or a delimited segment of one) is using a live identity where a fixture belongs
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).

### outputs

`[object[]]` One record per token: @{ Token; Kind; Source; Suggest; MatchMode }.

## match mode

Each token carries a match mode that governs how a finder matches it. `exact` is a distinctive identity, flagged wherever it appears as a
literal. `position` is an ambiguous identity, such as an environment name like `test` or `dev`, flagged only when it is bound to an identity
parameter (`-Environment`, `-Env`, `-Shortcode`), never as bare prose.

## walking a rule's path

A rule's path is walked from a config node. A key segment steps in. A `*` steps into every entry of a map and leaves out an entry that sets
the rule's `skip_when`. The end of the path yields the scalar, or the map's keys when the rule takes keys. A node may be parsed YAML or a
typed config object.

## declarations by owner

Each owning module declares the identities of its own configs in `configs/identity-tokens.yml`. A declaration that names a config its module
does not own throws. Shipped template names, read from the templates place of the Bicep track, are added after the declared tokens.

## names left out

Deployable-unit and pipeline names are left out on purpose. The generic ones (`automation`, `infrastructure`, `templates`, `shared`) are
structural folder names that appear as legitimate string literals throughout the tests, so matching them gives only false positives.
