# pwsh/Base.QualityGates/private/Get-ContentExemptPath.ps1

The one predicate the tools that rewrite or check tracked-file content ask before they touch a file. It names which of the given paths
.gitattributes puts in a class that means leave as written, so no tool keeps a list of its own.

## help

### synopsis

Lists which of the given paths the content tools leave as written.

### description

The one predicate the tools that rewrite or check tracked-file content (the link tools, the Markdown-title tools) ask before they touch a
file. A path is exempt when .gitattributes puts it in one of five classes: linguist-vendored (third-party code, kept as shipped),
linguist-generated (files the automation writes, aligned at their authored input instead), catzc-fixture (test fixture trees, data on
purpose), catzc-contract (contract assets under `contracts/<unit>/<version>/`, whose bytes are what a contract check compares —
[ADR-REPO-CONTRACT-CONTRACTASSET](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-contractasset)), and catzc-unordered
(imports under the unordered track, not yet sorted —
[DDR-TRACK-UNORDEREDTRACK](../../../../drs/design/tracks.md#rule-ddr-track-unorderedtrack)). The classes are declared in the authored
.gitattributes that Build-RootConfig renders to the root
([ADR-REPO-ROOTCFG-FULLYMANAGED](../../../../drs/repository/generated-root-configs.md#rule-adr-repo-rootcfg-fullymanaged)), never in a list
of a tool's own; this function only names which classes mean "leave as written".

### parameter `RepositoryRoot`

The repository root the paths are relative to.

### parameter `Path`

Repository-relative, '/'-separated paths.

### outputs

`[string[]]` The given paths that are exempt, in the given order.
