# pwsh/Base.QualityGates/private/Get-LogicTestIdentityFinding.ps1

Scans one Pester test file's syntax tree for a live identity used as a code string literal outside an integrity-tagged block. It reads only
real code, so a comment or a help example never reaches it.

## help

### synopsis

Scans one Pester test file's AST for a live production identity used as a code string literal OUTSIDE an integrity-tagged block — the
comment-blind, tag-aware check cspell cannot do.

### description

The PowerShell AST omits comments, here-doc trivia, and help entirely, so this reads only real code string literals — a config comment
illustrating `[acme, globex]`, a `.EXAMPLE` help block, or demo data in a comment never reaches it.

A live identity is legitimate ONLY inside an `integrity`-tagged block (binding the real config is an integrity test's job,
[ADR-AUTO-TEST-ONECATEGORY](../../../../drs/automation/test-automation.md#rule-adr-auto-test-onecategory)); anywhere else in a logic-bearing
test file it is a leak. So the scan EXCLUDES the script-block extent of every Describe/Context/It tagged `integrity`, and reports a match
everywhere else — the shared setup, the logic Contexts, the unit tests. This makes a MIXED logic+integrity file work with no file split: the
integrity Context's identities are carved out, the logic body is checked.

Classification and exclusion are read from the AST `-Tag` values, never by running Pester. A file with no `logic` tag at all is not a logic
surface and is skipped; a `*.Integrity.Tests.ps1` file is skipped by convention. Matching is EXACT (a literal that IS 'apex', not the
segment inside 'apex/…' or a path), so false positives stay near zero (Phase 1).

It rests on [ADR-REPO-LANG](../../../../drs/repository/domain-language-separation.md).

### parameter `Path`

The test file to scan.

### parameter `LiveToken`

A hashtable token -> record (@{ Token; Kind; Source; Suggest }) from Get-LiveIdentityTokens.

### outputs

`[object[]]` findings: @{ File; Line; Token; Kind; Source; Suggest; Message }.

## predicates

The node predicates are bound to locals and never inlined in a `.FindAll(...)` call
([ADR-PWSH-FORMAT-MULTILINEPREDICATEBOUND](../../../../drs/automation/pwsh/powershell-formatting.md#rule-adr-pwsh-format-multilinepredicatebound)).

## one walk over the Pester blocks

The function walks the `Describe`, `Context` and `It` commands once. It notes whether the file carries a `logic` tag anywhere, and it
collects the script-block offset range of every `integrity`-tagged block, whose literals are carved out of the scan.

## the exact pass

A distinctive identity (a customer, subscription, org, template or project) is flagged as a bare literal anywhere outside an integrity
block. A hashtable key is never flagged: it names a parameter or a property (a splat's `Discovery = ...`), never a value, so it is no
identity.

## the position pass

An ambiguous identity, such as an environment name or shortcode like `test` or `dev`, is flagged only when it is the argument of an identity
parameter (`-Environment`, `-Env`, `-Shortcode`), never as a prose literal.
