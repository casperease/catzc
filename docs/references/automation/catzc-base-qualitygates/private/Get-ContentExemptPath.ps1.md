# automation/Catzc.Base.QualityGates/private/Get-ContentExemptPath.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists which of the given paths the content tools leave as written.

### description

The one predicate the tools that rewrite or check tracked-file content (the link tools, the Markdown-title tools)
ask before they touch a file. A path is exempt when .gitattributes puts it in one of five classes:
linguist-vendored (third-party code, kept as shipped), linguist-generated (files the automation writes, aligned at
their authored input instead), catzc-fixture (test fixture trees, data on purpose), catzc-contract (contract
assets under `contracts/<unit>/<version>/`, whose bytes are what a contract check compares —
[ADR-REPO-CONTRACT#6](../../../../adr/repository/api-contracts.md#rule-adr-repo-contract6)), and catzc-unordered (imports
under the unordered track, not yet sorted —
[ADR-DSGN-TRACK#17](../../../../adr/design/tracks.md#rule-adr-dsgn-track17)). The classes are declared
in the authored .gitattributes that Build-RootConfig renders to the root
([ADR-REPO-ROOTCFG#1](../../../../adr/repository/generated-root-configs.md#rule-adr-repo-rootcfg1)), never in a list of a
tool's own; this function only names which classes mean "leave as written".

### parameter RepositoryRoot

The repository root the paths are relative to.

### parameter Path

Repository-relative, '/'-separated paths.

### outputs

`[string[]]` The given paths that are exempt, in the given order.
