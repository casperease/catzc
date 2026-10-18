# pwsh/Catzc.Base.QualityGates/private/Get-LogicTestIdentityFinding.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Scans one Pester test file's AST for a live production identity used as a code string literal OUTSIDE an integrity-tagged block — the
comment-blind, tag-aware check cspell cannot do.

### description

The PowerShell AST omits comments, here-doc trivia, and help entirely, so this reads only real code string literals — a config comment
illustrating `[acme, globex]`, a `.EXAMPLE` help block, or demo data in a comment never reaches it.

A live identity is legitimate ONLY inside an `integrity`-tagged block (binding the real config is an integrity test's job,
[ADR-AUTO-TEST-ONECATEGORY](../../../../adr/automation/test-automation.md#rule-adr-auto-test-onecategory)); anywhere else in a logic-bearing test file it is a
leak. So the scan EXCLUDES the script-block extent of every Describe/Context/It tagged `integrity`, and reports a match everywhere else —
the shared setup, the logic Contexts, the unit tests. This makes a MIXED logic+integrity file work with no file split: the integrity
Context's identities are carved out, the logic body is checked.

Classification and exclusion are read from the AST `-Tag` values, never by running Pester. A file with no `logic` tag at all is not a logic
surface and is skipped; a `*.Integrity.Tests.ps1` file is skipped by convention. Matching is EXACT (a literal that IS 'apex', not the
segment inside 'apex/…' or a path), so false positives stay near zero (Phase 1).

It rests on [ADR-REPO-LANG](../../../../adr/repository/domain-language-separation.md).

### parameter `Path`

The test file to scan.

### parameter `LiveToken`

A hashtable token -> record (@{ Token; Kind; Source; Suggest }) from Get-LiveIdentityTokens.

### outputs

`[object[]]` findings: @{ File; Line; Token; Kind; Source; Suggest; Message }.

## comment:1

Above `$isCommandNode = {`, written with `#`.

```text
Predicates bound to locals (never inlined in a .FindAll(...) call) —
[ADR-PWSH-FORMAT-MULTILINEPREDICATEBOUND](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format-multilinepredicatebound).
```

## comment:2

Above `$hasLogic = $false`, written with `#`.

```text
Walk the Pester block commands once: note whether the file carries a `logic` tag anywhere, and collect
the script-block offset range of every `integrity`-tagged block (its literals are carved out of the scan).
```

## comment:3

Above `$literals = $ast.FindAll($isStringLiteral, $true)`, written with `#`.

```text
Exact pass — a distinctive identity (customer / subscription / org / template / project) flagged as a
bare literal anywhere outside an integrity block.
```

## comment:4

Above `$identityParameters = 'Environment', 'Env', 'Shortcode'`, written with `#`.

```text
Position pass — an ambiguous identity (an environment name or shortcode, like 'test'/'dev') is flagged
ONLY when bound to an identity parameter (-Environment / -Env / -Shortcode), never as a prose literal.
```
