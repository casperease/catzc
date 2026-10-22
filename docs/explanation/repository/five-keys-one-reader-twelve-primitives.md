---
catzc:
  edges:
    cites:
      - ADR-PWSH-VERBS-PLURALCOLLECTIONNOUNS
      - ADR-REPO-VARIANT-SESSIONVARIANT
      - ADR-REPO-VARIANT-NODIRECTREADS
      - ADR-REPO-VARIANT-ADONAMING
      - ADR-REPO-VARIANT-HAVECUSTOMERS
      - ADR-REPO-VARIANT-GITWORKSPACE
---

# Five keys, one private reader, fifteen exported primitives

```text
Five keys in variants.yml reach fifteen exported primitives through one private reader.

1   variants.yml                  five keys: ado_naming, git_workspace, have_customers, aspects, tracks
2   Get-Config -Config variants   loads the file as a VariantsConfig and caches it for the session
3   Get-Variant                   the private reader: one key, or the caller's default when absent
4   Get-AdoNaming                 ado_naming, default standard
5   Get-GitWorkspace              git_workspace, default main-direct
6   Get-EnabledCustomers          have_customers normalised to @(), all, or a name list
7   Get-AspectDeclaration · Get-Track  aspects and tracks, the two keys with no Assert- guard
8   Test-/Assert-AdoNaming        -Standard or -Classic over Get-AdoNaming
9   Test-GitWorkspace             -MainDirect or -MainViaPr over Get-GitWorkspace
10  Test-/Assert-HaveCustomer(s)  the plural forms over Get-EnabledCustomers; the singular forms cover them

Supports ADR-REPO-VARIANT-SESSIONVARIANT, ADR-REPO-VARIANT-NODIRECTREADS, ADR-REPO-VARIANT-ADONAMING, ADR-REPO-VARIANT-HAVECUSTOMERS and ADR-REPO-VARIANT-GITWORKSPACE (implementation lens).
```

`Catzc.Base.Variants` is small: one YAML file with five keys, one C# config type that validates it, one private function that reads it, and
fifteen public functions that ask it. A value flows one way, from the file through the loader and the reader to a `Get-` accessor, and from
the accessor to the `Test-` and `Assert-` guards that answer a question or stop the run.

```yml drawio
description:
  The five keys of variants.yml are loaded through Get-Config and read by one private reader, which feeds the Get- accessors, which feed the
  Test- and Assert- guards.
about:
  adrs:
    - ADR-REPO-VARIANT-SESSIONVARIANT
    - ADR-REPO-VARIANT-NODIRECTREADS
    - ADR-REPO-VARIANT-ADONAMING
    - ADR-REPO-VARIANT-HAVECUSTOMERS
    - ADR-REPO-VARIANT-GITWORKSPACE
  lens: implementation
content:
  title: Five keys, one private reader, fifteen exported primitives
  kind: explanation
  flow: top-to-bottom
  relation: feeds
  theme: dark
  bands:
    - { id: band-file, label: FILE }
    - { id: band-read-path, label: READ PATH }
    - { id: band-accessors, label: ACCESSORS }
    - { id: band-guards, label: GUARDS }
  glyphs:
    - { id: g-variants-yml, kind: file, label: variants.yml, in: band-file }
    - { id: g-get-config, kind: code, label: Get-Config -Config variants, in: band-read-path }
    - { id: g-get-variant, kind: private, label: Get-Variant, in: band-read-path }
    - { id: g-ado-naming, kind: code, label: Get-AdoNaming, in: band-accessors }
    - { id: g-git-workspace, kind: code, label: Get-GitWorkspace, in: band-accessors }
    - { id: g-enabled-customers, kind: code, label: Get-EnabledCustomers, in: band-accessors }
    - { id: g-aspect-track, kind: code, label: Get-AspectDeclaration · Get-Track, in: band-accessors }
    - { id: g-test-ado-naming, kind: code, label: Test-/Assert-AdoNaming, in: band-guards }
    - { id: g-test-git-workspace, kind: code, label: Test-GitWorkspace, in: band-guards }
    - { id: g-test-customers, kind: code, label: Test-/Assert-HaveCustomer(s), in: band-guards }
  edges:
    - { from: g-variants-yml, to: g-get-config, kind: flow, label: "" }
    - { from: g-get-config, to: g-get-variant, kind: flow, label: "" }
    - { from: g-get-variant, to: g-ado-naming, kind: flow, label: "" }
    - { from: g-get-variant, to: g-git-workspace, kind: flow, label: "" }
    - { from: g-get-variant, to: g-enabled-customers, kind: flow, label: "" }
    - { from: g-get-variant, to: g-aspect-track, kind: flow, label: "" }
    - { from: g-ado-naming, to: g-test-ado-naming, kind: flow, label: "" }
    - { from: g-git-workspace, to: g-test-git-workspace, kind: flow, label: "" }
    - { from: g-enabled-customers, to: g-test-customers, kind: flow, label: "" }
  markers:
    - { at: g-variants-yml, number: 1 }
    - { at: g-get-config, number: 2 }
    - { at: g-get-variant, number: 3 }
    - { at: g-ado-naming, number: 4 }
    - { at: g-git-workspace, number: 5 }
    - { at: g-enabled-customers, number: 6 }
    - { at: g-aspect-track, number: 7 }
    - { at: g-test-ado-naming, number: 8 }
    - { at: g-test-git-workspace, number: 9 }
    - { at: g-test-customers, number: 10 }
  legend: auto
  minimaps:
    code-locations:
      - cell: docs/-/.
        by:
          - docs/drs/index.md
          - docs/drs/repository/dora-explains.md
          - docs/drs/repository/repo-variants.md
          - docs/references/pwsh/catzc-base-module-system/Sync-GeneratedFile.ps1.md
          - docs/references/pwsh/catzc-base-variants/Get-AspectDeclaration.ps1.md
          - docs/references/pwsh/catzc-base-variants/Test-AspectDeclaration.ps1.md
          - docs/references/pwsh/catzc-base-variants/configs/variants.yml.md
          - docs/references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md
          - ADR-REPO-VARIANT-ADONAMING
          - ADR-REPO-VARIANT-GITWORKSPACE
          - ADR-REPO-VARIANT-HAVECUSTOMERS
          - ADR-REPO-VARIANT-NODIRECTREADS
          - ADR-REPO-VARIANT-SESSIONVARIANT
      - cell: pwsh/Catzc.Base.Drs/configs
        by:
          - pwsh/Catzc.Base.Drs/configs/drs.yml
          - ADR-REPO-VARIANT-ADONAMING
          - ADR-REPO-VARIANT-GITWORKSPACE
          - ADR-REPO-VARIANT-HAVECUSTOMERS
          - ADR-REPO-VARIANT-NODIRECTREADS
          - ADR-REPO-VARIANT-SESSIONVARIANT
      - cell: pwsh/Catzc.Base.ModuleSystem/.
        by: [pwsh/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1, ADR-REPO-VARIANT-GITWORKSPACE]
      - cell: pwsh/Catzc.Base.Variants/.
        by:
          - pwsh/Catzc.Base.Variants/Get-AspectDeclaration.ps1
          - pwsh/Catzc.Base.Variants/Test-AspectDeclaration.ps1
          - ADR-REPO-VARIANT-ADONAMING
          - ADR-REPO-VARIANT-GITWORKSPACE
          - ADR-REPO-VARIANT-HAVECUSTOMERS
          - ADR-REPO-VARIANT-NODIRECTREADS
          - ADR-REPO-VARIANT-SESSIONVARIANT
      - cell: pwsh/Catzc.Base.Variants/configs
        by:
          - pwsh/Catzc.Base.Variants/configs/variants.yml
          - ADR-REPO-VARIANT-ADONAMING
          - ADR-REPO-VARIANT-GITWORKSPACE
          - ADR-REPO-VARIANT-HAVECUSTOMERS
          - ADR-REPO-VARIANT-NODIRECTREADS
          - ADR-REPO-VARIANT-SESSIONVARIANT
      - cell: pwsh/Catzc.Base.Variants/types
        by:
          - pwsh/Catzc.Base.Variants/types/VariantsConfig.cs
          - ADR-REPO-VARIANT-ADONAMING
          - ADR-REPO-VARIANT-GITWORKSPACE
          - ADR-REPO-VARIANT-HAVECUSTOMERS
          - ADR-REPO-VARIANT-NODIRECTREADS
          - ADR-REPO-VARIANT-SESSIONVARIANT
    module-neighbourhood:
      - cell: subject/Catzc.Base.Drs
        by:
          - pwsh/Catzc.Base.Drs/configs/drs.yml
          - ADR-REPO-VARIANT-ADONAMING
          - ADR-REPO-VARIANT-GITWORKSPACE
          - ADR-REPO-VARIANT-HAVECUSTOMERS
          - ADR-REPO-VARIANT-NODIRECTREADS
          - ADR-REPO-VARIANT-SESSIONVARIANT
      - cell: subject/Catzc.Base.ModuleSystem
        by: [pwsh/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1, ADR-REPO-VARIANT-GITWORKSPACE]
      - cell: subject/Catzc.Base.Variants
        by:
          - pwsh/Catzc.Base.Variants/Get-AspectDeclaration.ps1
          - pwsh/Catzc.Base.Variants/Test-AspectDeclaration.ps1
          - pwsh/Catzc.Base.Variants/configs/variants.yml
          - pwsh/Catzc.Base.Variants/types/VariantsConfig.cs
          - ADR-REPO-VARIANT-ADONAMING
          - ADR-REPO-VARIANT-GITWORKSPACE
          - ADR-REPO-VARIANT-HAVECUSTOMERS
          - ADR-REPO-VARIANT-NODIRECTREADS
          - ADR-REPO-VARIANT-SESSIONVARIANT
    axis:
      - cell: AUTO/*
        by:
          - ADR-REPO-VARIANT-ADONAMING
          - ADR-REPO-VARIANT-GITWORKSPACE
          - ADR-REPO-VARIANT-HAVECUSTOMERS
          - ADR-REPO-VARIANT-NODIRECTREADS
          - ADR-REPO-VARIANT-SESSIONVARIANT
layout:
  band-file: { x: 20, y: 84, w: 1240, h: 80 }
  band-read-path: { x: 20, y: 184, w: 1240, h: 140 }
  band-accessors: { x: 20, y: 344, w: 1240, h: 90 }
  band-guards: { x: 20, y: 454, w: 1240, h: 90 }
  g-variants-yml: { x: 560, y: 112, w: 190, h: 44 }
  g-get-config: { x: 530, y: 212, w: 250, h: 44 }
  g-get-variant: { x: 560, y: 270, w: 190, h: 44 }
  g-ado-naming: { x: 50, y: 384, w: 260, h: 44 }
  g-git-workspace: { x: 365, y: 384, w: 260, h: 44 }
  g-enabled-customers: { x: 680, y: 384, w: 260, h: 44 }
  g-aspect-track: { x: 995, y: 384, w: 260, h: 44 }
  g-test-ado-naming: { x: 50, y: 494, w: 260, h: 44 }
  g-test-git-workspace: { x: 365, y: 494, w: 260, h: 44 }
  g-test-customers: { x: 680, y: 494, w: 260, h: 44 }
```

![Five keys, one private reader, fifteen exported primitives](.assets/five-keys-one-reader-twelve-primitives.drawio.png)

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
7. **Get-AspectDeclaration · Get-Track.** `Get-AspectDeclaration` reads `aspects` with a built-in default of the two shipped tracks, and
   `Test-AspectDeclaration -Track` answers whether a track has an entry there; `Get-Aspect` in `Catzc.Base.Modules` reads through it.
   `Get-Track -Name` or `-Path` reads `tracks` with an empty default and throws on an unknown name. Neither key has an `Assert-` guard.
8. **Test-/Assert-AdoNaming.** Each takes exactly one of `-Standard` or `-Classic` and calls `Get-AdoNaming`; the predicate returns the
   match, and the guard throws through `Assert-True` with the value to set.
9. **Test-GitWorkspace.** Takes exactly one of `-MainDirect` or `-MainViaPr` and calls `Get-GitWorkspace`. There is no
   `Assert-GitWorkspace`.
10. **Test-/Assert-HaveCustomer(s).** `Test-HaveCustomers`, with an optional `-Name` list, calls `Get-EnabledCustomers`;
    `Assert-HaveCustomers` calls the predicate and throws. The singular `Test-HaveCustomer` and `Assert-HaveCustomer` take one `-Name` and
    call the plural form.

## Why it holds

- The file is the one home, loaded through `Get-Config -Config variants` so that it inherits the session cache
  (ADR-REPO-VARIANT-SESSIONVARIANT).
- Nothing reads the file directly; each variant is a `Get-` accessor and `Test-`/`Assert-` guards over the private `Get-Variant`, so each
  default lives in exactly one place (ADR-REPO-VARIANT-NODIRECTREADS).
- `ado_naming` is a variant, not a code constant: `Get-AdoNaming` reads it with the default `standard` (ADR-REPO-VARIANT-ADONAMING).
- `have_customers` is tri-state, `Get-EnabledCustomers` normalises it, and the plural and singular primitives split by cardinality
  (ADR-REPO-VARIANT-HAVECUSTOMERS, ADR-PWSH-VERBS-PLURALCOLLECTIONNOUNS).
- `git_workspace` is read through `Get-GitWorkspace` and `Test-GitWorkspace -MainDirect|-MainViaPr` (ADR-REPO-VARIANT-GITWORKSPACE).

## Where the code and the decision record differ

- The ADR promises a `Get-` accessor and `Test-`/`Assert-` guards for each variant; `git_workspace` has no `Assert-`, and `aspects` and
  `tracks` have only their accessors.
- `Assert-AdoNaming` exists and is exported, and the ADR never names it.

## See also

- [Repo-wide variants](../../drs/repository/repo-variants.md) — the decision this article explains.
- The other lenses on the same diagram: [meta](one-home-one-read-path-one-vocabulary.md),
  [architecture](a-base-module-between-config-and-its-callers.md), [operations](an-edit-lands-at-the-next-import.md) and
  [governance](values-and-edges-gated-reads-reviewed.md).
- [The repository explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
