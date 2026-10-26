# pwsh/Base.Variants/types/VariantTrack.cs

One track of the `tracks` variant (`configs/variants.yml`, [DDR-TRACK](../../../../drs/design/tracks.md)): a named root concern of the
repository, with its places, its type and the file languages its tech-stack is declared as
([DDR-TRACK-FILELANGUAGE](../../../../drs/design/tracks.md#rule-ddr-track-filelanguage)). VariantsConfig validates each entry and builds
one; `Get-Track` returns them. The properties mirror the YAML keys, so they are snake_case
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)), and
`name` is the entry's YAML key.

## Properties

- **`languages`** — the file-language names of the declared tech-stack, in declared order; empty when the track declares none. They are not
  resolved here: the file-language registry lives in `Catzc.Base.Languages`.
- **`kinds`** — named kinds of the track's files, each a place pattern inside one of its places with one `*` segment allowed (for example
  `configs` → `infrastructure/templates/*/configuration`). Empty when the track names none; membership is decided by places alone.
- **`join`** — what the track's language spells between its namespace and a folder name: `-` on the js track (`catzc-track-lamps`), nothing
  on one such as go.
- **`namespace_exempt`** — globs of the files that keep the namespace on disk because they name the product, not a module folder
  ([DDR-TRACK-MODULENAMESPACE](../../../../drs/design/tracks.md#rule-ddr-track-modulenamespace)): a loader psm1 PowerShell names its module
  after, or the types assembly's identity.

## Path questions

- **`NamespaceSegmentOf`** — the path up to the first segment below one of the track's places that spells the namespace in the track's join
  form; null when none does, when the track declares no namespace, or when an exempt glob matches. The match is ordinal, as `FolderNameOf`
  strips: a segment in another track's form (`catzc-` under `Catzc.`) names that track's identity, not this track's namespace.
- **`PlaceLengthOf`** — the length of the longest member that contains the path, or -1 when none does. A glob member counts by its pattern's
  length, so a glob inside another track's place takes the files it names.
