# PowerShell engine decision records

The records here govern PowerShell 7 as one of catzc's execution engines ([execution-engines](../execution-engines.md)): how the
engine-agnostic rules of `automation/` are realised in pwsh, and the rules that only mean something in pwsh — module files and manifests,
the session the importer sets up, parameters, errors and streams, caching in script scope, working-directory and environment mechanics,
cross-platform pwsh, the analyzer, and Pester. The domain's anchor is [pwsh-engine](pwsh-engine.md). A rule here applies an `automation/`
rule to one engine and cites it; it never redefines it. The full code↔DRS registry is the [DRS index](../../index.md).
