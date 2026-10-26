# pwsh/Base.ModuleSystem/private/Resolve-ImportMix.ps1

Gathers the session's facts and hands them to `ImportMix.Resolve`, the one place the import mix is decided.

## help

### synopsis

Resolves an import mix from the caller's values, the importer configuration and the facts of the session.

### description

Gathers the facts the resolution needs: the engines whose executable is located, each module's code languages, and the languages
configuration's known, executable and handled languages. It hands them to ImportMix.Resolve, the one place the mix is decided. A resolution
error (an unknown name, an absent engine, a language without a handler) surfaces as itself, so the importer stops with the NotImplemented
error ([ADR-AUTO-IMPORTER-UNHANDLEDLANGUAGESTOPS](../../../../drs/automation/importer.md#rule-adr-auto-importer-unhandledlanguagestops)).

### parameter `Languages`

The caller's languages; when not given, the configuration's.

### parameter `Engines`

The caller's engines; when not given, the configuration's.

### outputs

`[Catzc.Base.ModuleSystem.ImportMix]` The resolved mix.

## Code languages of a module

A module's code languages are the executable languages of the files that a language's own layout row places. The shared rows, assets and
tests, never count.

## Errors

The resolution's own error surfaces as itself, not as the call's wrapper, so the caller sees the unknown name, the absent engine or the
unhandled language directly.
