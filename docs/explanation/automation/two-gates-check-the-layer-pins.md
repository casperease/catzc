# docs/explanation/automation/two-gates-check-the-layer-pins.md

`Two gates check the layer pins, and one rule is left to review`

```text
Two gates check the layer pins, and one rule is left to review.

1  AzureExt            top layer: every member pins groups or single modules, never its own group
2  Tooling             middle layer: four members also pin their own group
3  Base                foundation: no member has its own pin list
4  Load check          the declaration's shape, checked when it loads
5  Quality gate        the real code and the on-disk modules, checked against the declaration
6  Same-change review  a new edge lands with its code; no gate checks it

Supports ADR-AUTO-DEPM#1, #2, #3, #4 and #5, and ADR-AUTO-TEST#35 (governance lens).
```

The layer pins of cats' module graph, the groups and modules each consumer may use, are held by the same ADR rules on every layer, and they
are checked twice. The load check validates the declaration itself, and the `Test-ModuleDependency` quality gate checks the real code
against it. One rule, declaring a new edge in the same change as the code, has no gate at all.

![Two gates check the layer pins](../../.assets/explanation/adr-auto-depm--two-gates-check-the-layer-pins--governance.drawio.png)

The diagram is described element by element in
[its asset description](../../.assets/explanation/adr-auto-depm--two-gates-check-the-layer-pins--governance.drawio.md).

## Walkthrough

1. **AzureExt.** Each member of the top group pins a group (Tooling, Base) or a single module (`Catzc.Azure`, `Catzc.Tooling.Core`). Its
   internal map is acyclic, and no member pins its own group, so every in-group edge stays within the internal map.
2. **Tooling.** Four members, Python, Node, Toolchain and Provisioning, also pin their own group. The code unions that pin with their
   in-group list, so they may reach any Tooling member, and the in-group rule holds for only two of the six members, Core and Environment.
   The internal map is still acyclic.
3. **Base.** No Base member has its own pin list, so each library's in-group list is its whole allow-set. The in-group rule holds, and the
   map is acyclic. `Catzc.Azure`, Github and KeyHandler, the single modules in the middle of the graph, pin Base alone.
4. **Load check.** The `DependenciesConfig` type checks the declaration when it loads, without reading the disk: every target resolves,
   every group is closed over its members, and the module graph and each group's map are acyclic. One throw lists every problem, and it runs
   before the quality gate checks anything.
5. **Quality gate.** `Test-ModuleDependency` checks that every function call and C# type reference stays within the allow-set, and that
   every declared module and group member exists on disk. It collects every issue, reports through `Write-QualityGateReport` and throws
   once. Its L1 integrity test, tagged `source-only`, runs it, so every default test run includes it; no gate runs at import.
6. **Same-change review.** Landing a new edge in the same change as the code is left to code review, because the integrity test sees only
   the end state. It stands alone: no code runs or checks it.

## Why it holds

- The declaration is the allow-list, and an undeclared edge fails the build (ADR-AUTO-DEPM#1).
- Function calls and C# type references are one graph, checked by one gate (ADR-AUTO-DEPM#2).
- Each consumer pins a group (loose) or a module (tight) (ADR-AUTO-DEPM#3).
- The declaration's shape is checked at load, and the real edges, on-disk modules and in-group edges by the gate (ADR-AUTO-DEPM#4).
- A new edge is declared in the same change as the code that introduces it (ADR-AUTO-DEPM#5).
- A quality gate is one `Test-<subject>` that collects every issue, writes its report and throws once, run by an integrity test at its tier
  (ADR-AUTO-TEST#35).

The remaining rules, which keep module and system dependencies apart and pin, vendor and stitch external code (ADR-AUTO-DEPM#6 to #10), lie
outside these two gates.

## Where the code and the ADR differ

- The ADR says actual in-group edges must stay within the group's declared internal map. The code unions a member's pins with its in-group
  list, so the four Tooling members that pin `Tooling` may reach any Tooling member.
- The ADR says a module absent from the pin lists is unconstrained. The code also constrains every group member.

## See also

- [Controlling module dependencies](../../adr/automation/controlling-module-dependencies.md) — the decision this article explains.
- [Test automation](../../adr/automation/test-automation.md) — the quality-gate rule, ADR-AUTO-TEST#35.
- The other lenses on the same graph: [meta](a-declared-allow-list-of-layers.md), [architecture](three-layers-edges-point-down.md),
  [implementation](two-sections-unioned-into-one-allow-set.md) and [operations](undeclared-edge-fails-with-one-line.md).
- [The automation explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
