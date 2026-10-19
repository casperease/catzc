# ADR: Open/closed architecture

## Rules: ADR-AUTO-EXTEND

### Rule ADR-AUTO-EXTEND-ADDNOTEDIT

Extend by adding, not editing: new functions, modules, and dependencies are new files and folders. Never modify the infrastructure — the
importer entries and the bootstrap loader — to accommodate new content. The same shape holds one level up: a new root concern is a new
**track** — a new root folder with its own tech-stack — never an edit smuggled into an existing one (see [tracks](../design/tracks.md), code
`ADR-DSGN-TRACK`).

- [How the platform does it](#how-the-platform-does-it)

### Rule ADR-AUTO-EXTEND-CONTENTAGNOSTICINFRASTRUCTURE

Keep infrastructure content-agnostic: the importer and bootstrap module must not reference specific module names, function names, or
business logic. They operate on conventions and treat all conforming content identically.

- [Violations](#violations)

### Rule ADR-AUTO-EXTEND-MANDATORYCONVENTIONS

Conventions are mandatory, not suggestions: file name = function name, folder = module, root = public. Code that does not conform is not
discovered; the fix is to make the code conform, not to special-case the infrastructure.

- [Convention over configuration](#convention-over-configuration)

### Rule ADR-AUTO-EXTEND-SPECIALCASESINMODULE

Special cases go in the module, not the loader: a module needing custom initialization handles it internally (e.g. a private helper). The
loader never gains module-specific branches.

- [Violations](#violations)

## Context

The Open/Closed Principle (the O in SOLID) states that a system should be open for extension but closed for modification. In this platform,
that translates to a concrete rule: **you grow the system by adding files and folders, never by editing the infrastructure that discovers
them.**

Module systems typically require hand-maintained manifests, explicit import lists, or registration steps — edit-to-extend workflows that
create merge conflicts, stale registrations, and "I added it but forgot to register it" bugs. This platform eliminates that entire class of
problems: the bootstrap module derives every registration from the filesystem, and the importer discovers modules by convention. Adding
capability never requires touching existing code. The PowerShell mechanics — the generated module manifests and the collision-free function
namespace — are the language layer, [dynamic-module-manifests](pwsh/dynamic-module-manifests.md) (`ADR-PWSH-MANIFEST`).

### How the platform does it

`How the platform implements open/closed`

| Extension point            | How you extend it                                       | What you never modify                      |
| -------------------------- | ------------------------------------------------------- | ------------------------------------------ |
| Add a function to a module | Create the function's file, named for it, in the module | No manifest, no export list, no loader     |
| Add a private helper       | Create the function's file in `private/`                | No manifest, no export list, no loader     |
| Add a new module           | Create a folder under the engine's code root            | Not the importer, not the bootstrap module |
| Add a vendor dependency    | Drop the module in `.vendor/`                           | Not the importer, not the bootstrap module |

Every row follows the same pattern: the extension is a new file or folder, and the infrastructure discovers it automatically.

### Violations

`Patterns that violate open/closed`

| Pattern                                                         | Problem                                                    | Fix                                                                        |
| --------------------------------------------------------------- | ---------------------------------------------------------- | -------------------------------------------------------------------------- |
| Adding an `if` branch in the importer for a special module      | Infrastructure now has module-specific knowledge           | Make the module conform to the convention, or add a general-purpose hook   |
| Hand-maintaining a module manifest with an explicit export list | Second source of truth that drifts from the filesystem     | Let `New-DynamicManifest` generate it                                      |
| A loader script that lists modules in a specific order          | Adding a module requires editing the loader                | If ordering matters, encode it in naming convention or dependency metadata |
| A central registry map from names to functions                  | Every new function requires editing the registry           | Use the engine's command lookup by module, or a convention-based lookup    |
| Checking module names in conditionals (`if module == "Foo"`)    | Infrastructure is coupled to a specific module's existence | Use a capability check or convention instead of a name check               |

### Convention over configuration

The open/closed guarantee rests on conventions:

- **File name = function name.** The file named `Get-Foo` exports `Get-Foo`. No mapping table needed.
- **Folder = module.** A directory under the engine's code root that holds function files is a module. No registration needed.
- **Root = public, `private/` = private.** Export visibility is determined by file location. No attribute or annotation needed.

In PowerShell these conventions are [one-function-per-file](pwsh/one-function-per-file.md#rule-adr-pwsh-onefunc-onefunctionperfile) and the
location-based exports of [dynamic-module-manifests](pwsh/dynamic-module-manifests.md#rule-adr-pwsh-manifest-visibilityislocation).

These conventions are rigid by design. Rigidity is what makes the system predictable and extensible. If every module followed its own
structure, the bootstrap module could not derive registrations automatically, and you would be back to hand-maintained configuration.

Convention-as-source-of-truth carries one assumption: that a name means exactly one thing. That is the one open/closed seam where
"non-conforming code is invisible" does not hold — two definitions of one name are both discovered, and one quietly wins. The import
therefore fails fast on any collision; the mechanics live in
[dynamic-module-manifests](pwsh/dynamic-module-manifests.md#one-function-namespace).

### Module dependency graph

The allowed inter-module dependency graph is declared in `Catzc.Base.ModuleSystem/configs/dependencies.yml` and enforced by the
`Test-ModuleDependency` quality gate. The file has two sections: `groups:` and `modules:`. A `groups:` entry declares a named set of on-disk
modules with its own internal member→member DAG — a group is a concept, not a disk module; its name is a logical handle, not a folder. A
consumer module's allowed-deps in `modules:` may name a GROUP (permitting an edge to any member of that group) and/or a specific MODULE
(tight coupling). Integrity is group-aware: actual edges must fall within the resolved allow-set, each group's internal DAG must be acyclic,
and actual intra-group edges must be a subset of the declared internal map. The `Catzc.Base.*` cluster is held together as the `Base` group
— its modules are the group's members, each with its own intra-group layering declared in `dependencies.yml`.

## Decision

The platform must remain open for extension and closed for modification. Concretely:

- **Growth is additive.** A new function is a new function file named for it, a new module is a new folder under the engine's code root, a
  new vendor dependency is a new folder under `.vendor/`, and a new root concern is a new track. None of these edits the importer, the
  bootstrap module, or any other module's files (ADR-AUTO-EXTEND-ADDNOTEDIT).
- **The infrastructure knows conventions, not content.** The importer and the bootstrap module discover modules, exports, and visibility
  from names and locations alone; they never name a specific module, function, or business rule
  (ADR-AUTO-EXTEND-CONTENTAGNOSTICINFRASTRUCTURE).
- **Non-conforming code is fixed, not accommodated.** Code that does not follow file name = function name, folder = module, and root =
  public is not discovered; the remedy is to rename or move it, never to teach the loader an exception
  (ADR-AUTO-EXTEND-MANDATORYCONVENTIONS).
- **Special needs stay inside the module.** A module that needs custom initialization or extra wiring implements it with its own private
  helpers; the loader gains no module-specific branch (ADR-AUTO-EXTEND-SPECIALCASESINMODULE).

### How this is enforced

- **`Import-AllModules`** (`pwsh/.internal/Catzc.Internal.Bootstrap.psm1`) discovers every non-dot folder under `pwsh/` as a module and
  generates its manifest with `New-DynamicManifest`, so a new module or function needs no registration anywhere. Before any module loads it
  fails fast on a duplicate export or a shadowed shipped command, the one seam where convention alone cannot guarantee a single meaning per
  name ([dynamic-module-manifests](pwsh/dynamic-module-manifests.md)).
- **`Test-Automation.Tests.ps1`** and **`Test-FolderConventions.Tests.ps1`** fail the test run on a file, function, or folder that breaks
  the naming and placement conventions, so non-conforming code is caught rather than silently skipped
  ([one-function-per-file](pwsh/one-function-per-file.md), [conventional-folders](../repository/conventional-folders.md)).
- **Code review** rejects a module-specific branch, a hand-maintained registry, or a module-name check in the importer or bootstrap module
  against this ADR.

## Disambiguation

The module-dependency graph this ADR references (`dependencies.yml`, `groups:`/`modules:`, `Test-ModuleDependency`) is owned by
[controlling-module-dependencies](controlling-module-dependencies.md) (`ADR-AUTO-DEPM`).

## Consequences

- Adding a function is a one-step operation: create the file.
- Parallel development never conflicts on infrastructure files.
- The bootstrap module and importer are stable — they change only when the conventions themselves change, which is rare.
- Onboarding is trivial: "put a file here, it works."
- Debugging module loading issues reduces to "is the file in the right place with the right name?" — never "is it registered in three
  different places?"
- One name means one thing repo-wide: a collision fails the import with a named error instead of silently shadowing
  ([dynamic-module-manifests](pwsh/dynamic-module-manifests.md)).
- The tradeoff is rigidity: modules that do not follow convention are invisible to the system. This is intentional — the cost of one naming
  fix is far lower than the cost of maintaining special-case infrastructure.
