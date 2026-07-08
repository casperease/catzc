# Catzc.Base.Exporter

The module that packages the catzc platform into an installable, versioned, content-addressed bundle. It owns the exported artifact's
**identity** — the version every install carries and the durable content hash that proves an export is reproducible — so a bundle built from
one commit is byte-identical wherever it is built and can be traced back to its source. It is the platform-level expression of a
reproducible, content-addressed, self-service artifact (see [self-service](../../adr/design/self-service.md)); the hash it computes is the
durable-SHA identity the globsets also use (see [durable-sha-globs](../../adr/pipelines/durable-sha-globs.md)). It is a member of the `Base`
group and depends on [Catzc.Base.Config](catzc-base-config.md) (to read its config), [Catzc.Base.Globs](catzc-base-globs.md) (the
durable-SHA primitives), and [Catzc.Base.Asserts](catzc-base-asserts.md).

## Domains

| Domain   | Area     | Name                                                               |
| -------- | -------- | ------------------------------------------------------------------ |
| domain:1 | version  | [Bundle version](#domain1--bundle-version)                         |
| domain:2 | identity | [Content-addressed identity](#domain2--content-addressed-identity) |

### domain:1 — Bundle version

The version a bundle carries, read from the single export config `exporter.yml`. `Get-CatzcVersion` returns the **direct-install sentinel**
(`6.6.666`) by default — the fixed, obviously-not-published number every on-disk install uses, overwritten in place on re-install — and the
**published version** under `-Published`, the number the future package artifact ships under. Both are numeric `MAJOR.MINOR.PATCH` strings,
a shape the config validator enforces. `exporter.yml` is the one place the repository states how it wants to export itself (the version,
plus the scope options a build reads); every read routes through `Get-Config`, so a test can substitute a fixture config through the same
seam.

### domain:2 — Content-addressed identity

The reproducible identity of a built tree. `Get-CatzcContentHash` applies the durable-SHA recipe to every file under a directory — a SHA-256
over each file's bytes with carriage returns stripped (so a CRLF and an LF working tree agree), folded as `path|digest` lines in ordinal
path order, then one combined SHA-256 over the fold. The result is a 64-character identity that is stable wherever the tree is copied and
changes on any content, addition, removal, or rename. This is the proof an exported bundle is reproducible: build the same commit twice and
the hash is identical.

## What the module does

The module gives the exported artifact a stable identity, which is what makes an export trustworthy: a consumer can name exactly which
version they installed, and anyone can rebuild that version from source and confirm the bytes match. The two responsibilities are the two
halves of that identity. The version (domain 1) is the human-facing label — a fixed sentinel for the fast on-disk install path, a real
number for a published artifact — and it is configuration, so changing how the repository exports is a reviewed edit to one file rather than
a code change. The content hash (domain 2) is the machine-checkable half — a durable, end-to-end-verifiable digest of what a build actually
produced — reusing the same durable-SHA primitives the globsets rest on rather than a second hashing scheme.

Both halves route through the platform's own seams: the version through `Get-Config` (so it is validated on load and swappable in tests),
the hash through the native durable-SHA type (so a large binary like the committed type assembly hashes in milliseconds). Keeping the
identity in this `Base`-layer module is what lets the higher-level build, export, and install work rest on a version and a hash without
re-deriving either.

## Division

The module's public functions, sorted into the domains above.

| Domain                                | Function               |
| ------------------------------------- | ---------------------- |
| domain:1 — Bundle version             | `Get-CatzcVersion`     |
| config                                | `exporter.yml`         |
| domain:2 — Content-addressed identity | `Get-CatzcContentHash` |
