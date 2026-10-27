# ADR: Idiomatic names — each language names its own way, over one repository normal form

## Rules: ADR-AUTO-IDIOM

### Rule ADR-AUTO-IDIOM-LANGUAGEIDIOM

Every source file, every folder that holds one, and every function and type a source file defines is named in the idiom of its language. The
idiom is configuration, not code ([configure-not-program](../principles/configure-not-program.md)): each language's entry in the languages
config carries a `naming:` map that gives the naming case of its folders, its files, its functions and its types. A language with no
`naming:` entry is not judged.

- [One idiom per language](#one-idiom-per-language)

### Rule ADR-AUTO-IDIOM-CLOSEDCASES

A naming case is one of a closed set, and each case states how a name splits into words and how words join into a name: `pascal`
(`GetCommandContract`), `camel` (`getCommandContract`), `pascal-dotted` (`Catzc.Base.Contracts`), `verb-noun` (`Get-CommandContract`),
`kebab` (`get-command-contract`), `snake` (`get_command_contract`), and `flat` (`getcommandcontract`). A configuration names cases from the
set and never a pattern of its own; a new case is new mechanism, and its split, its join and its name land together. A hidden folder's
leading dot sits outside the case, so `.internal` is a `kebab` folder.

- [A closed set of cases](#a-closed-set-of-cases)

### Rule ADR-AUTO-IDIOM-SOURCENAMEDEXEMPT

A file whose name its source fixes keeps that name: the files under an asset folder or a vendored folder, at any depth, and the files a
language's `naming:` entry lists by repository path as `exempt` (an entry script whose name every session types). The exempt folders are
listed once, as `naming.exempt_folders` of the languages config. This is the file-name form of
[ADR-AUTO-SPELL-IDENTIFIERSNOTDATA](spell-out-names.md#rule-adr-auto-spell-identifiersnotdata): a name owned by someone else is data, not a
choice.

- [Names owned by a source](#names-owned-by-a-source)

### Rule ADR-AUTO-IDIOM-NORMALFORM

Every function, type, parameter and module name has one language-neutral **repository normal form**: the same name in one configured naming
case, `naming.normal_form` of the languages config, with namespace segments joined by `.`. The case is chosen as the best of all worlds,
even when that best is one language's own idiom, and it is `snake`: `get_command_contract`, `repository_root`,
`catzc.base.contracts.contract_command`. Every place that names a thing for more than one language — a contract, a lookup, a cross-language
test — names it in the normal form.

- [One normal form under the idioms](#one-normal-form-under-the-idioms)
- [Why snake](#why-snake)

### Rule ADR-AUTO-IDIOM-PLACENORMALFORM

A place in the repository, a track, a module, a folder inside a module or a folder of a track without modules, has one place normal form,
its one short form in any projection that shows it in a row: its path from the repository root, normalised as a repository-relative path
([ADR-AUTO-PATH](path-representation.md)), joined with `.` (`pwsh.azure.types`, `docs.explanation.ado`, `.claude.skills`). The module's
`Catzc.` prefix is dropped whole, and a dot inside a module name becomes `_`, so the module name is lower-case snake, the repository normal
form (`Azure.Templates` is `azure_templates`); the dot is then only ever the path join. A module's lit sub-folders share one row, joined by
`|` in sort order, the module's own root among them written `(root)` (`pwsh.azure_templates.(root)|tests|types`); a module with no lit
sub-folder is just `pwsh.<module>`. A place outside any module is its own row, the track and the whole path of its folder: a module that
only repeats its track (`.claude` in `.claude`) is no module, and a place at the docs root, which names no folder, has no row and is not
counted. Rows are sorted in true repository path order, the track first and then the module's or the folder's path (`.claude` before `docs`
before `pwsh`). A row never cuts a name: it holds every joined folder whole, or, when they do not fit the configured characters, the count
of the places (`pwsh.azure.+3`); a folder path keeps the whole segments that fit and counts the rest (`docs.explanation.automation.+2`); no
row carries an elision. A projection computes its rows once, beside its data, from the inputs its source carries, and whatever shows the
projection prints the rows as given and cuts nothing itself; how a projection budgets and folds its rows is its own configuration.

- [Places have one short form](#places-have-one-short-form)

### Rule ADR-AUTO-IDIOM-ROUNDTRIP

A language's idiomatic name is a rendering of the normal form: split into the normal form's words and joined in the language's case. Every
name round-trips — idiom to normal form and back gives the same name — and a name that does not is a finding, renamed until it does.

- [One normal form under the idioms](#one-normal-form-under-the-idioms)

### Rule ADR-AUTO-IDIOM-ACRONYMISWORD

An acronym is one ordinary word in every case: `ado` in the normal form, `Ado` in `pascal`, `ado` in `kebab`. No list of acronyms renders
one in capitals; a name fixed by a vendor in capitals (`PSScriptAnalyzerSettings`) is exempt by ADR-AUTO-IDIOM-SOURCENAMEDEXEMPT, never by a
list. The acronyms [ADR-AUTO-SPELL-ALLOWEDABBREVIATIONS](spell-out-names.md#rule-adr-auto-spell-allowedabbreviations) allows stay allowed;
this rule says only how they are cased.

- [Acronyms are words](#acronyms-are-words)

### Rule ADR-AUTO-IDIOM-TESTFOLDERBYIDIOM

A language's test folder, `<root>/tests/<module>/`, is named for its catzc module by rendering the module's normal form in the language's
folder case, the namespace dropped: `base_repository` for a `snake` language, `baserepository` for a `flat` one, `base-repository` for a
`kebab` one. A test folder maps back to its module by the same rendering, so no mapping file exists and no convention is shared across languages.

- [Test folders](#test-folders)

### Rule ADR-AUTO-IDIOM-HELDBYGATE

The naming is held by one gate and one assertion over the tracked files ([tracked-files-from-the-index](tracked-files-from-the-index.md)):
`Test-IdiomaticNames`, a quality gate in the `checks` of every language with a `naming:` entry, reports each misnamed folder once per
language and each misnamed file, function and type; `Assert-IdiomaticNames` throws with the same findings. `Repair-IdiomaticNames` moves a
misnamed folder or file to its idiomatic name and lists every tracked file that names the old path, for the edits that follow it one file at
a time.

- [How this is enforced](#how-this-is-enforced)

## Context

A repository with more than one source language meets two pulls on every name. Each language has an idiom its readers and its tools assume:
Python imports a package by a name that must be an identifier, Go wants one lowercase word per package directory, and a PowerShell module is
a dotted PascalCase folder of `Verb-Noun` files. And some names cross languages: a contract states a command once for every language that
calls it, and a test in one language names a module written in another. A name chosen in one language's idiom and copied into another reads
as foreign there, and a contract written in one language's spelling binds every other language to it.

### One idiom per language

The idiom of a language is a small set of facts — the case of its folders, files, functions and types — and facts are configuration
([configure-not-program](../principles/configure-not-program.md)). They live beside the language's other facts in the languages config, read
by its one typed reader, so adding a language's idiom is one entry and no code. A language without an entry is not judged: the rule lands
language by language.

### A closed set of cases

A case is mechanism: it must split a name into words and join words into a name, exactly, or the round trip fails. A configuration that
named a free pattern could match names but never render one, so the set is closed and each case carries both directions. The seven cases
cover the languages in the tree; `pascal`, `pascal-dotted` and `verb-noun` are distinct because each joins words differently, and a case
that matched all three could not render any of them. `camel` is distinct from `pascal` because a language can give the first letter meaning:
in Go it is a name's visibility, so an unexported function is `camel` and an exported one `pascal`, and both are the language's idiom.

### Names owned by a source

Asset folders hold data and payload, often a file whose name a vendor chose (an installer script, a fixture shaped like the outside system),
and a vendored folder holds another project's code under its own names. Renaming either breaks the tie to its source. The one exempt file in
a source tree is an entry whose name people type, such as the importer every session dot-sources; it is listed by path, so the exemption is
visible and reviewed.

### One normal form under the idioms

A normal form that belongs to no single language gives a name one identity whichever language spells it. The round trip is what makes the
rendering safe: a name that cannot go to the normal form and come back unchanged has two identities.

### Why snake

The normal form is configured, so the choice is the best case for the job, not the most neutral-looking one. `snake` wins on every count
that matters here. It is the case of the repository's YAML keys (`Assert-YmlNaming`), and the native config types mirror those keys, so a
contract's parameter names are ordinary keys. It splits into words with no loss, so every other case renders from it. And it is a real
language's own idiom, Python's, which costs nothing: a normal form that happens to be idiomatic somewhere is still one form.

### Places have one short form

A projection names places in a row only a few dozen characters wide, such as a diagram's sidebar. Left to whatever shows it, each place is
cut where the width runs out, so two places that differ only at the end read as the same, and the cut falls inside a word. A place is a
path, and a path is one entity ([ADR-AUTO-PATH](path-representation.md)); the place normal form is one short way to write it.
Dropping the prefix every module shares and writing the module in the repository normal form gives a row that is still a path, shorter, and
one that reads the same wherever a name appears; keeping the dot for the path join alone means a row splits into track, module and folders
without a guess. A module's folders share its row because the module is what a reader looks for. When even that is too long, whole names are
kept and the rest is marked, never a name cut in the middle. Computing the rows once, beside the data, means every projection of the same
places prints the same rows, and its budget stays one setting.

### Acronyms are words

A list of acronyms to capitalise would make the round trip depend on a list that grows by reflex: `PSScriptAnalyzer` splits as `ps`,
`script`, `analyzer` only if the list knows `PS`, and renders back only if the list agrees. Treating an acronym as an ordinary word keeps
every case total and every name's round trip a property of the name alone (`Get-AdoBuildValidations`). A vendor's capitalised name is the
vendor's, and is exempt where it lives.

### Test folders

A test folder in one language names a module of another. Named by rendering the module's normal form in the test language's folder case, it
is idiomatic where it lives — a Python test folder is an importable snake name, a Go test folder a flat package directory — and it maps back
to its module by the same rendering, with nothing to keep in step.

## Decision

Each language names its files, folders, functions and types in its own idiom, stated as configuration from a closed set of naming cases.
Under the idioms sits one repository normal form, configured as `snake`; every idiomatic name renders from it and back, acronyms are
ordinary words, and names a source owns are exempt. A test folder is its module's normal form in its language's folder case. One gate and
one assertion hold it over the tracked files.

### How this is enforced

- **`LanguagesConfig`** reads each language's `naming:` entry and `naming.normal_form`, validates every case against the closed set and
  every exempt entry, and judges a set of paths by the cases it names.
- **`Test-IdiomaticNames`** is the quality gate, in the `checks` of every language with a `naming:` entry; **`Assert-IdiomaticNames`**
  throws with the same findings.
- **`Repair-IdiomaticNames`** moves a misnamed folder or file on disk, with `-DryRun`, and lists the tracked files that name the old path.

## Consequences

- A reader of each language finds the names that language's tools and conventions expect.
- A place has one short row, so the same place reads the same in every projection, and a row cut at a segment boundary still names its
  place.
- A name has one identity across languages; a contract or a lookup names it once, and each language renders its own.
- A new language's idiom is one `naming:` entry; a new case is a change to the closed set and its two directions, reviewed as mechanism.
- Renaming a misnamed folder touches every file that names its path, so a rename is a step of its own, with those edits beside it.
