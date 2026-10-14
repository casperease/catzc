# docs/explanation/automation/what-gates-each-bundle-stage.md

`Every stage of the bundle has a rule, and two gates check it`

```text
Every stage of the bundle has a rule, and two gates check it.

1  Build-Modules            selection, merged payload and version (#1, #4, #7)
2  Assert-CatzcBundle       the integrity gate on every build (#5)
3  Temporary build          immutable and content-addressed (#5)
4  Installed, saved         idempotent placements of the verified build (#6)
5  Checked again            the install verifies its source with the same gate (#6)
6  Cached                   a code root the ADR names and no code makes (RUNMODE#7)
7  Test-CatzcBuild          the build run: the same tests, against a fresh build (TEST#30)

Supports ADR-AUTO-BUNDLE#1, #4, #5, #6 and #7, ADR-AUTO-TEST#30 and #31, and ADR-DSGN-RUNMODE#7 (governance lens).
```

ADR-AUTO-BUNDLE fixes every stage of a bundle, from the module selection to the place the build is copied to. Rules only hold when something
checks them, and two gates do the checking. `Assert-CatzcBundle` verifies every build and verifies it again before every placement, and the
build run `Test-CatzcBuild` runs the same tests against a fresh build that the source run runs against the source tree. One kind of code
root, cached, is stated by an ADR and made by no code.

![Every stage has a rule, two gates check it](../../.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.drawio.png)

The diagram is described element by element in
[its asset description](../../.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.drawio.md).

## Walkthrough

1. **Build-Modules.** Three rules shape the build. The selection is closure-expanded over the declared dependencies (ADR-AUTO-BUNDLE#1), the
   payload ships in merged form and never carries `tests/` (ADR-AUTO-BUNDLE#4), and the version is the devbox placeholder or a version
   calculated in the pipeline (ADR-AUTO-BUNDLE#7).
2. **Assert-CatzcBundle.** The gate on integrity checks the layout, that no test file leaked in, that exactly one types DLL is named for the
   recorded types hash, every module's manifest, merged file and exports, and the recorded content hash. It collects every violation and
   throws once.
3. **Temporary build.** The build is immutable and content-addressed: `build.json` records its content hash, which the gate re-verifies.
   That a second build of the same commit is byte-identical is the ADR's word alone; no test builds one commit twice and compares.
4. **Installed, saved.** A placement copies the verified build into a module path or into another root's `.vendor/`. It is idempotent: a
   destination that already holds the same content hash is not copied again.
5. **Checked again before placement.** The install verifies its source build with the same gate before it touches the destination.
6. **Cached.** ADR-DSGN-RUNMODE#7 names a cached code root, a build kept outside the repository and reused across sessions for the same
   commit and version. No code makes or reuses one, so it is drawn as ADR-only.
7. **Test-CatzcBuild.** The build run builds the selected modules with `Build-Modules` and runs the same tests as `Test-Automation` against
   the build. A test opts out only with the `source-only` tag, and the run lists every test it excludes.

## Why it holds

- A bundle is built from a selected set of modules, closure-expanded over the declared dependencies (ADR-AUTO-BUNDLE#1).
- The payload is merged and default-deny: the `tests/` surface never travels (ADR-AUTO-BUNDLE#4).
- A build is immutable and content-addressed, and `Assert-CatzcBundle` is its integrity guard, run by the build on its own output
  (ADR-AUTO-BUNDLE#5).
- An install verifies its source before it changes the destination, and a re-install with a matching hash does not copy (ADR-AUTO-BUNDLE#6).
- A devbox build carries the placeholder version, and a pipeline build gets a calculated, reproducible one (ADR-AUTO-BUNDLE#7).
- The same tests run in the source run and the build run (ADR-AUTO-TEST#30), and `source-only` is the one way out of the build run
  (ADR-AUTO-TEST#31).
- Build mode has four kinds of code root, cached among them (ADR-DSGN-RUNMODE#7).

## Where the code and the ADR differ

- ADR-AUTO-BUNDLE#5 lists the internal-asset presence check among the checks of `Assert-CatzcBundle`. The code runs that check in the
  engine, before it writes anything, as ADR-AUTO-ASSETDEP#4 says.
- ADR-DSGN-RUNMODE#7 says the build kind is derived from the code root. No code derives a kind, and none makes a cached build.
- ADR-DSGN-RUNMODE#1 names a root `build-catzc.ps1` entry. The file does not exist.

## See also

- [Platform bundle](../../adr/automation/platform-bundle.md) — the decision this article explains.
- [Test automation](../../adr/automation/test-automation.md) and [Run modes](../../adr/design/run-modes.md) — the build run and the build
  kinds.
- The other lenses on the same bundle: [meta](one-commit-one-immutable-package.md), [architecture](every-code-root-is-a-copy.md),
  [implementation](build-verify-then-copy-the-folder.md) and [operations](build-then-place-with-one-command.md).
- [The automation explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
