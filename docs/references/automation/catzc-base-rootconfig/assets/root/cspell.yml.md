# docs/references/automation/catzc-base-rootconfig/assets/root/cspell.yml.md

`automation/Catzc.Base.RootConfig/assets/root/cspell.yml`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `noConfigSearch: true`.

```text
This is the repository's ONE spelling config (the root cspell.yml is a managed copy-in of this source —
see rootconfig.yml). Never search for per-folder configs: the source copy of this very file lives under
assets/root/, and without this flag cspell would treat it as a nearest config for its sibling files and
resolve the ./.cspell/ dictionary paths relative to the wrong folder.
```

## comment:2

Above `- "**/assets/scripts/dotnet-install.*"`.

```text
Vendored, downloaded third-party install scripts (.NET Foundation dotnet-install.*) — never authored here,
and they carry Authenticode signature blocks whose base64 is not spellable vocabulary. Same rationale as
.vendor/** above.
```

## comment:3

Above `- infrastructure/templates/**/configuration/**`.

```text
Per-slot template configs hold Azure resource names assembled by the naming convention (deweuzctexpedapst:
env, region, org, template, customer, type). They are data, not vocabulary
([ADR-AUTO-SPELL#4](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell4)), written statically per slot
([ADR-AZ-DATAMOD#6](/docs/adr/azure/azure-data-model.md#rule-adr-az-datamod6)), so the spelling gate and the editor
both skip them here, once.
```

## comment:4

Above `ignoreRegExpList:`.

```text
GUID literals are not words: the managed-GUID gate (Catzc.Base.QualityGates configs/guids.yml,
Get-RepositoryGuids) is their single owner, so cspell never tokenizes their hex fragments. One gate owns
words, one owns GUIDs.
```

## comment:5

Above `dictionaryDefinitions:`.

```text
Approved-vocabulary dictionaries — one per registry category
([ADR-AUTO-SPELL#6](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell6)) — generated from the terminology
registry (automation/Catzc.Base.QualityGates/configs/terminology.yml) by Build-TerminologyDictionary. The
.cspell/<category>.txt lists are GITIGNORED and regenerated at the importer tail (terminology.yml is the
single source of truth), so run `. ./importer.ps1` once on a fresh clone before cspell can resolve them.
Never hand-edit the lists; add or remove vocabulary in terminology.yml. See .cspell/README.md and
[ADR-AUTO-SPELL](/docs/adr/automation/spell-out-names.md)
([ADR-AUTO-SPELL#5](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell5)-[ADR-AUTO-SPELL#8](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell8)).

ONE definition + dictionary entry per registry category. This list must match the `categories:` keys in
terminology.yml — adding a category means adding it in both places (cspell.yml cannot read the registry).
```

## comment:6

Above `- powershell`.

```text
cspell's built-in PowerShell dictionary. The conventional-abbreviation allow-list
([ADR-AUTO-SPELL#2](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell2) — cfg, ctx,
cmd, repo, …) and all other approved vocabulary live in terminology.yml (single source,
[ADR-AUTO-SPELL#5](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell5)),
generated into the .cspell/*.txt dictionaries this config loads globally — never inline here.
```
