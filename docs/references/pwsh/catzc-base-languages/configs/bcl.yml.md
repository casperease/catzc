# pwsh/Catzc.Base.Languages/configs/bcl.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `host_bindings:`, written with `#`.

```text
The BCL language's config: the one build configuration and platform of every non-vendored .sln and .csproj, omitted here so the
defaults on BclConfig apply, and the host bindings: the type sources that bind to a host, each with its reason; every other type
source stays in the BCL reference set.
```
