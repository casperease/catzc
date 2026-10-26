# A thin platform, not a framework

cats is the **Thinnest Viable Platform** of Team Topologies: a reusable command-line surface over a vendor substrate. It standardises _how_
the organisation uses the vendor — it never reimplements it ([an abstraction over the vendor, not a copy of it](../../drs/design/thin-platforms.md)).

- **Delegate, don't reimplement** — Bicep does ARM templating, the az CLI does the control plane; cats harmonises one calling convention,
  one auth path and one set of defaults on top. _Abstractions, not illusions._
- **The platform is a CLI** — `Verb-Noun` commands plus configuration _are_ the API. Consumers edit config and compose commands; they never
  touch the vendor wiring.
- **Everything is code** — automation, configs, pinned tool versions, vendored dependencies and vendor bindings, in one living version
  ([no legacy, no back-compat, history in git](../../drs/principles/one-living-version.md)).
- **Swappable substrate** — the vendor sits behind the CLI; the consequential choices (cost, region, scale, blast radius) stay visible in
  configuration.
- **Safe self-service** — consumers provision through the repository, and every delivery travels as one immutable artifact
  ([consumers provision themselves](../../drs/design/self-service.md)).
