---
catzc:
  immutable:
    repo_status: clean
    path: docs/explanation/repository/five-keys-one-reader-twelve-primitives.md
    folder: docs/explanation/repository
    name: five-keys-one-reader-twelve-primitives
    filetype: md
    kind: explanation
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    cites:
      - ADR-PWSH-VERBS#6
      - ADR-REPO-VARIANT#{1,2,4-6}
    links:
      - docs/adr/repository/repo-variants.md
      - docs/explanation/.assets/adr-repo-variant--five-keys-one-reader-twelve-primitives--implementation.drawio.png
      - docs/explanation/index.md#how-to-read-the-diagrams
      - docs/explanation/repository/a-base-module-between-config-and-its-callers.md
      - docs/explanation/repository/an-edit-lands-at-the-next-import.md
      - docs/explanation/repository/five-keys-one-reader-twelve-primitives.drawio.md
      - docs/explanation/repository/index.md
      - docs/explanation/repository/one-home-one-read-path-one-vocabulary.md
      - docs/explanation/repository/values-and-edges-gated-reads-reviewed.md
---

# Five keys, one private reader, twelve exported primitives

```text
Five keys in variants.yml reach twelve exported primitives through one private reader.

1   variants.yml                  five keys: ado_naming, git_workspace, have_customers, aspects, tracks
2   Get-Config -Config variants   loads the file as a VariantsConfig and caches it for the session
3   Get-Variant                   the private reader: one key, or the caller's default when absent
4   Get-AdoNaming                 ado_naming, default standard
5   Get-GitWorkspace              git_workspace, default main-direct
6   Get-EnabledCustomers          have_customers normalised to @(), all, or a name list
7   Get-Aspect · Get-Track        aspects and tracks, the two keys with an accessor only
8   Test-/Assert-AdoNaming        -Standard or -Classic over Get-AdoNaming
9   Test-GitWorkspace             -MainDirect or -MainViaPr over Get-GitWorkspace
10  Test-/Assert-HaveCustomer(s)  the plural forms over Get-EnabledCustomers; the singular forms cover them

Supports ADR-REPO-VARIANT#1, #2, #4, #5 and #6 (implementation lens).
```

`Catzc.Base.Variants` is small: one YAML file with five keys, one C# config type that validates it, one private function that reads it, and
twelve public functions that ask it. A value flows one way, from the file through the loader and the reader to a `Get-` accessor, and from
the accessor to the `Test-` and `Assert-` guards that answer a question or stop the run.

![Five keys, one private reader, twelve exported primitives](../.assets/adr-repo-variant--five-keys-one-reader-twelve-primitives--implementation.drawio.png)

The diagram is described element by element in [its asset description](five-keys-one-reader-twelve-primitives.drawio.md).

## Walkthrough

1. **variants.yml.** `configs/variants.yml` declares `ado_naming: standard`, `git_workspace: main-direct`, `have_customers: all`, the
   `aspects` of the automation and infrastructure tracks, and the eleven `tracks` of the repository. Every key is optional, and an unknown
   key is an error.
2. **Get-Config -Config variants.** The loader parses the file into a `VariantsConfig`, the type registered for `variants` in `configs.yml`.
   Constructing the type validates every key and throws one error that lists every violation. The parsed record is cached for the session.
3. **Get-Variant.** `Get-Variant -Name <key> -Default <x>` asks the loaded record for one key and returns the default when the record does
   not contain it. It is listed among the module's files and absent from its exports, so only the module's own primitives call it.
4. **Get-AdoNaming.** Reads `ado_naming` with the default `standard`. The value selects the key of `Get-AzureNameOrderSet` that the name
   assembler uses.
5. **Get-GitWorkspace.** Reads `git_workspace` with the default `main-direct`.
6. **Get-EnabledCustomers.** Reads `have_customers` with the default `$false` and is its single interpreter: a boolean becomes `@()` or
   `all`, the literal `all` stays, and anything else is the list of enabled customer names.
7. **Get-Aspect · Get-Track.** `Get-Aspect -Track` reads `aspects` with a built-in default of the two shipped tracks; `Get-Track -Name` or
   `-Path` reads `tracks` with an empty default and throws on an unknown name. These two keys have an accessor and no guard.
8. **Test-/Assert-AdoNaming.** Each takes exactly one of `-Standard` or `-Classic` and calls `Get-AdoNaming`; the predicate returns the
   match, and the guard throws through `Assert-True` with the value to set.
9. **Test-GitWorkspace.** Takes exactly one of `-MainDirect` or `-MainViaPr` and calls `Get-GitWorkspace`. There is no
   `Assert-GitWorkspace`.
10. **Test-/Assert-HaveCustomer(s).** `Test-HaveCustomers`, with an optional `-Name` list, calls `Get-EnabledCustomers`;
    `Assert-HaveCustomers` calls the predicate and throws. The singular `Test-HaveCustomer` and `Assert-HaveCustomer` take one `-Name` and
    call the plural form.

## Why it holds

- The file is the one home, loaded through `Get-Config -Config variants` so that it inherits the session cache (ADR-REPO-VARIANT#1).
- Nothing reads the file directly; each variant is a `Get-` accessor and `Test-`/`Assert-` guards over the private `Get-Variant`, so each
  default lives in exactly one place (ADR-REPO-VARIANT#2).
- `ado_naming` is a variant, not a code constant: `Get-AdoNaming` reads it with the default `standard` (ADR-REPO-VARIANT#4).
- `have_customers` is tri-state, `Get-EnabledCustomers` normalises it, and the plural and singular primitives split by cardinality
  (ADR-REPO-VARIANT#5, ADR-PWSH-VERBS#6).
- `git_workspace` is read through `Get-GitWorkspace` and `Test-GitWorkspace -MainDirect|-MainViaPr` (ADR-REPO-VARIANT#6).

## Where the code and the ADR differ

- The ADR promises a `Get-` accessor and `Test-`/`Assert-` guards for each variant; `git_workspace` has no `Assert-`, and `aspects` and
  `tracks` have only their accessors.
- `Assert-AdoNaming` exists and is exported, and the ADR never names it.

## See also

- [Repo-wide variants](../../adr/repository/repo-variants.md) — the decision this article explains.
- The other lenses on the same diagram: [meta](one-home-one-read-path-one-vocabulary.md),
  [architecture](a-base-module-between-config-and-its-callers.md), [operations](an-edit-lands-at-the-next-import.md) and
  [governance](values-and-edges-gated-reads-reviewed.md).
- [The repository explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
