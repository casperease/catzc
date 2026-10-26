# pwsh/Tooling.Core/private/Test-ToolHomeProbe.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Tests whether a tool's install home satisfies one session_host_probes entry at the locked version.

### description

A probe is a home-relative path whose last segment is `{version}` (validated by ToolConfig). The home satisfies it when the probe's parent
folder holds a directory named exactly the version, or starting with "`<version>`." — so `sdk/{version}` at version 10.0 matches
sdk/10.0.201 but not sdk/10.01 or sdk/6.0.428. A pure filesystem check: no process is started, so it is safe on the importer's hot path.

### parameter `ToolHome`

The install home to probe (the directory holding the tool's executable).

### parameter `Probe`

One session_host_probes entry, for example 'sdk/{version}'.

### parameter `Version`

The tool's locked version (ToolConfig.version).
