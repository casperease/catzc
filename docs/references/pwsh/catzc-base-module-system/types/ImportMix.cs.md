# pwsh/Base.ModuleSystem/types/ImportMix.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public static ImportMix Resolve(ImporterConfig config, string[]...`, written with `//`.

```text
Each axis is the caller's value when given, else the configuration's, where auto resolves from the session's facts:
presentEngines are the engines whose executable is located, moduleLanguages maps each module to its code languages, and
knownLanguages, executableLanguages and handledLanguages are the language names of the languages configuration, in its order. A
module is in the mix when every code language of it is; an explicit language without a handler stops the resolution.
```
