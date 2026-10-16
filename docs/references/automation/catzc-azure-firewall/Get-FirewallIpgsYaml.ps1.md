---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-firewall/Get-FirewallIpgsYaml.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "7c8cddc9ef71"
---

# automation/Catzc.Azure.Firewall/Get-FirewallIpgsYaml.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Assert-AzCliExtension 'ip-group'`, written with `#`.

```text
Assert once that the ip-group extension is present (fail fast with remediation instead of an
exit-2 / hang). No connection assert: each target is hit explicitly with --subscription, so
there's no single active subscription to assert; a missing session surfaces on the first call.
```

## comment:2

Above `$addressSortKey = {`, written with `#`.

```text
Numeric sort key from an address's first IP (handles CIDR a.b.c.d/p, range a-b, or a single IP);
pad each byte to 3 digits so a string sort orders numerically. Unparseable -> lexical fallback.
```

## comment:3

Above `if ($allSources.Contains($ResourceGroupName)) {`, written with `#`.

```text
Register this target's source once (keyed by RG name). Two targets sharing an RG name but pointing
at different subscriptions would collide on the source key — surface that rather than overwrite.
```

## comment:4

Above `if ($allIpgs.Contains($g.name)) {`, written with `#`.

```text
IP Group names are unique within a source but not necessarily across sources — guard the
shared 'ipgs' map so one source's group can't silently overwrite another's.
```
