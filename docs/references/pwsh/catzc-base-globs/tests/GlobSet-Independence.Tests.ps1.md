# pwsh/Base.Globs/tests/GlobSet-Independence.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'GlobSet independence'`, written with `#`.

```text
Integrity: per-layer independence
([FDR-CD-GLOBS-NOOVERLAPWITHINLAYER](/docs/drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-nooverlapwithinlayer)) holds in the REAL repository —
within every non-loose
layer, no two globsets (declared or derived) select a common file on their OWN contribution. The
'loose-fileset' layer is exempt: its sets are cross-cutting check surfaces (a track's root concern, a scan
scope, the reserved umbrellas) and overlap by design. A module or deployable-unit that starts containing
part of a peer — a mis-scoped include, an umbrella mis-declared as a module — fails here, locally and in
CI. L2 because the tracked-file universe comes from the real git CLI.
```
