# pwsh/Catzc.Base.ModuleSystem/private/Resolve-ImportMix.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
