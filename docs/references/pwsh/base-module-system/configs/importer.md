# pwsh/Base.ModuleSystem/configs/importer.yml

The importer's own settings: which languages it loads and which execution engines it serves.

## Keys

Both keys are optional. An omitted key takes the default declared once on the `ImporterConfig` type, and the importer's `-Languages` and
`-Engines` switches override the file. A value is `auto` or a list of names.
