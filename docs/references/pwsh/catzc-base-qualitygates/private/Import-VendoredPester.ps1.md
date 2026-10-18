# automation/Catzc.Base.QualityGates/private/Import-VendoredPester.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Loads the vendored Pester into the session on first use, and makes sure it is the one in use.

### description

Pester's import is deferred at import time for speed
([ADR-PWSH-VENDOR#5](../../../../adr/pwsh/vendor-toolset-dependencies.md#rule-adr-pwsh-vendor5)); the test entry points that need it in the
parent session — for a discovery pass, or an in-session run — load it here, once. It is vendored inside the code tree, so it resolves from
the code root ([ADR-AUTO-ASSETDEP#1](../../../../adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1)), and the load is
announced ([ADR-AUTO-CONSOLE#11](../../../../adr/automation/console-output-matters.md#rule-adr-auto-console11)). A session that already has
the vendored version loaded from the vendor folder is left as it is — a check of a few milliseconds; any other Pester in the session (a
system install, another version) is removed and replaced, and the replacement is named in the announcement.

### outputs

None.
