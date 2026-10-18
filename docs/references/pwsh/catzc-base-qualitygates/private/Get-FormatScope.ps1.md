# pwsh/Catzc.Base.QualityGates/private/Get-FormatScope.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The files Format-Code formats: the repository's tracked files, or the given paths, minus vendored code, contract assets and binary files.

### description

One scope for every formatter engine ([ADR-PRIN-CONFIG-VARYINGBEHAVIOURISCONFIG](../../../../adr/principles/configure-not-program.md#rule-adr-prin-config-varyingbehaviourisconfig)):
without -Path, every file git tracks (Get-GitTrackedPath); with -Path, each given file as it is (tracked or not, inside the repository or
not — a build output manifest is formatted the same way), and each given folder's tracked files. Fixture files are formatted like any other
file. Third-party code that .gitattributes marks `linguist-vendored` is never formatted: it stays as its publisher shipped it. Nor is a
contract asset, which .gitattributes marks `catzc-contract`: its bytes are what a contract check compares
([ADR-REPO-CONTRACT-CONTRACTASSET](../../../../adr/repository/api-contracts.md#rule-adr-repo-contract-contractasset)), and a released contract version stays
byte-frozen ([ADR-REPO-CONTRACT-RELEASEDIMMUTABLE](../../../../adr/repository/api-contracts.md#rule-adr-repo-contract-releasedimmutable)), so a formatter upgrade must never
rewrite one. Nor is a file .gitattributes marks `binary`, such as the generated output under pwsh/.compiled: git stores its bytes as they
are, so no text formatter rewrites them. The classes are declared once, in the .gitattributes source
([ADR-PRIN-CONFIG-EXCEPTIONISCONFIGENTRY](../../../../adr/principles/configure-not-program.md#rule-adr-prin-config-exceptionisconfigentry)). A tracked file deleted from the working
tree is left out.

### parameter `RepositoryRoot`

The repository root.

### parameter `Path`

Files or folders to narrow the scope to. Omitted: every tracked file.

### outputs

`[string[]]` Absolute paths.
