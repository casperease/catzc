# pwsh/Base.Drs/types/DrsCitationScanner.cs

Scans a text for the ADR codes it cites and the rules it defines.

## Citations

`Citations(text, withDomain)` returns the registered codes a text cites, minimized. A rule the text defines under a `### Rule` heading is no
citation, and a domain code counts only where the file's class takes domain codes.
