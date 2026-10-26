# pwsh/Base.ModuleSystem/types/ImportMix.cs

The one record of what a session loads: the languages, the execution engines and the modules, plus what was left out and why
([ADR-AUTO-IMPORTER-ONEMIXRECORD](../../../../drs/automation/importer.md#rule-adr-auto-importer-onemixrecord)). `Resolve` builds it from the
importer configuration.

## Resolution

Each axis is the caller's value when given, else the configuration's, where `auto` resolves from the session's facts:

- `presentEngines` are the engines whose executable is located, `moduleLanguages` maps each module to its code languages, and `knownLanguages`,
  `executableLanguages` and `handledLanguages` are language names of the languages configuration, in its order.
- With `auto` engines, every present engine is served and the rest are listed in `skipped_engines`. An explicit engine whose executable is
  absent stops the resolution.
- With `auto` languages, the executable languages that some loaded module uses are loaded. An explicit language outside the languages
  configuration, or one the importer has no handler for, stops the resolution.
- A module is in the mix when every code language of it is. The others are listed in `skipped_modules`.

## Properties

- **`languages`** — the languages the session loads, in the order the languages configuration declares them.
- **`engines`** — the execution engines the session serves, in the order of the engine model.
- **`modules`** — the modules the session loads, in ordinal order.
- **`skipped_engines`** — the engines `auto` left out because their executable is not present; empty for an explicit list.
- **`skipped_modules`** — the modules left out because one of their code languages is outside the mix, in ordinal order.
