# A change to one module fans out to every template that references it and every pipeline that deploys one

```text
A change to one module fans out to every template that references it and every pipeline that deploys one.

1  one module                          the edit: one .bicep file in the modules place of the infrastructure track
2  every template that references it   each main.bicep with a module declaration of it, which the build inlines
3  ci-infrastructure                   validates and builds every template on any change under infrastructure/
4  every CD pipeline                   each path filter includes the modules place, so every owner's pipeline runs

Supports ADR-AZ-IACKIND-THREEKINDS (operations lens).
```

A reusable module is the one kind of infrastructure code that never deploys on its own, and that is exactly why a change to it is the widest
change there is. Every template that references the module builds it in, so one edited file reaches every deployment of every one of those
templates, for the shared platform and for every customer. An operator changing a module should expect every pipeline to run.

![A change to one module fans out to every template that references it and every pipeline that deploys one](.assets/a-module-change-fans-out-to-its-templates/diagram.drawio.png)

## Walkthrough

1. **One module.** The operator edits one `.bicep` file in the track's `modules` place, such as the Log Analytics workspace.
2. **Every template that references it.** A template references a module from its `main.bicep` with a `module` declaration, and the build
   inlines it, so the next build of each referencing template carries the change.
3. **ci-infrastructure.** The infrastructure CI runs on any change under `infrastructure/`, and validates and builds every template, so a
   module that breaks one template fails before the merge.
4. **Every CD pipeline.** Each CD pipeline's path filter includes the modules place, so after the merge the shared pipeline and every
   customer's pipeline run and redeploy their templates.

## Why it holds

- A reusable module is one `.bicep` file used by templates and never deployed alone, and a change to it reaches every template that uses it
  (ADR-AZ-IACKIND-THREEKINDS).

## See also

- [Infrastructure code is of three kinds](three-kinds-of-infrastructure-code.md) — the three kinds and their places.
- [Changing one configuration slot](change-one-configuration-slot.md) — the narrowest change, for contrast.
- [The Azure explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
