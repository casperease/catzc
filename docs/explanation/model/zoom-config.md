# Zooming in on Catzc.Base.Config: one module among its neighbours, and its files

```text
One module at C3 and C4: among the modules it calls and that call it, and as its own tracked files by kind.

C3  components   Catzc.Base.Config and its neighbours, from the dependency query
C4  code         the module's tracked files but its tests, each in the kind its layout row gives it

Supports DDR-VISUAL-ZOOMISANAXIS, ADR-AUTO-DEPM-UNIFIEDGRAPH and ADR-AUTO-MODULE-EXISTSBYLAYOUT.
```

The fourth ladder stands at `pwsh/Catzc.Base.Config/`, one module of the [pwsh ladder](zoom-pwsh.md).

## C3: the module among its neighbours

![The config module and the modules that call it](.assets/zoom-config-c3.drawio.png)

The slide holds only the modules an edge joins to this one, the modules it calls and the many that call it, each with a chip counting its
calls, from `Get-ModuleDependencyEdges`
([ADR-AUTO-DEPM-UNIFIEDGRAPH](../../drs/automation/controlling-module-dependencies.md#rule-adr-auto-depm-unifiedgraph)).

## C4: the module's files

![The config module's tracked files, by kind](.assets/zoom-config-c4.drawio.png)

Each tracked file but the tests is drawn in the kind its layout row gives it
([ADR-AUTO-MODULE-EXISTSBYLAYOUT](../../drs/automation/module-model.md#rule-adr-auto-module-existsbylayout)): configs, code units, private
helpers and C# types. A file linked to another file of the module carries a chip counting those links, from `Get-LinkEdge`; the module's
links run from its tests, so its files carry none.
