# pwsh/Base.ModuleSystem/configs/importer.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `languages: auto`, written with `#`.

```text
Every key is optional: an omitted key takes the default declared once on ImporterConfig, and the importer's -Languages and -Engines
switches override it. A value is auto, or a list of names.
```
