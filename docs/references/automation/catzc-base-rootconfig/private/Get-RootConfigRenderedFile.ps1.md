# automation/Catzc.Base.RootConfig/private/Get-RootConfigRenderedFile.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Renders a generator entry of the root-config registry into one { Target; Content } record per file.

### description

Calls the entry's generator through the dispatch (Invoke-RootConfigGenerator, passing the entry's target) and normalises its output to
records, so Build-RootConfig writes every generated file the same way and Test-RootConfigFiles expands a wildcard entry into its files:

- a single-file generator returns one string: the content of the entry's one target;
- a multi-file generator returns { Target; Content } records (e.g. Catzc.Base.Languages.GoWorkspaceFile), each for one repository-relative
  path that must match the entry's target (case-sensitive wildcard match; a literal target matches only itself).

A wildcard target (`go/tests/*/go.mod`) needs records and may render none (no folder yet); a literal target must render exactly one file.
Any other shape throws, naming the entry and the generator. See [ADR-REPO-ROOTCFG](../../../../adr/repository/generated-root-configs.md).

### parameter Entry

An opted-in generator entry of rootconfig.yml (a RootConfigFile, or any object with target and generator).

### outputs

`[pscustomobject]` One { Target; Content } record per rendered file, in the generator's order.
