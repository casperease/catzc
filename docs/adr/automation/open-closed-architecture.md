# ADR: Open/closed architecture

## Rules: ADR-EXTEND

### Rule ADR-EXTEND:1

Extend by adding, not editing: new functions, modules, and dependencies are new files and folders. Never modify infrastructure files
(`importer.ps1`, `Bootstrap.psm1`) to accommodate new content. The same shape holds one level up: a new root concern is a new **track** — a
new root folder with its own tech-stack — never an edit smuggled into an existing one (see [tracks](../design/tracks.md), code `ADR-TRACK`).

- [How the platform implements open/closed](#how-the-platform-implements-openclosed)

### Rule ADR-EXTEND:3

Keep infrastructure content-agnostic: the importer and bootstrap module must not reference specific module names, function names, or
business logic. They operate on conventions and treat all conforming content identically.

- [Patterns that violate open/closed](#patterns-that-violate-openclosed)

### Rule ADR-EXTEND:4

Conventions are mandatory, not suggestions: file name = function name, folder = module, root = public. Code that does not conform is not
discovered; the fix is to make the code conform, not to special-case the infrastructure.

- [Convention over configuration](#convention-over-configuration)

### Rule ADR-EXTEND:5

Special cases go in the module, not the loader: a module needing custom initialization handles it internally (e.g. a private helper). The
loader never gains module-specific branches.

- [Patterns that violate open/closed](#patterns-that-violate-openclosed)

## Context

The Open/Closed Principle (the O in SOLID) states that a system should be open for extension but closed for modification. In this platform,
that translates to a concrete rule: **you grow the system by adding files and folders, never by editing the infrastructure that discovers
them.**

Module systems typically require hand-maintained manifests, explicit import lists, or registration steps — edit-to-extend workflows that
create merge conflicts, stale registrations, and "I added it but forgot to register it" bugs. This platform eliminates that entire class of
problems: the bootstrap module derives every registration from the filesystem, and the importer discovers modules by convention. Adding
capability never requires touching existing code. The PowerShell mechanics — the generated `.psd1` manifests and the collision-free function
namespace — are the language layer, [dynamic-module-manifests](powershell/dynamic-module-manifests.md) (`ADR-MANIFEST`).

### How the platform implements open/closed

| Extension point            | How you extend it                        | What you never modify                    |
| -------------------------- | ---------------------------------------- | ---------------------------------------- |
| Add a function to a module | Create `Verb-Noun.ps1` in the module dir | No manifest, no export list, no loader   |
| Add a private helper       | Create `Verb-Noun.ps1` in `private/`     | No manifest, no export list, no loader   |
| Add a new module           | Create a folder under `automation/`      | Not `importer.ps1`, not `Bootstrap.psm1` |
| Add a vendor dependency    | Drop the module in `.vendor/`            | Not `importer.ps1`, not `Bootstrap.psm1` |

Every row follows the same pattern: the extension is a new file or folder, and the infrastructure discovers it automatically.

### Patterns that violate open/closed

| Pattern                                                         | Problem                                                    | Fix                                                                        |
| --------------------------------------------------------------- | ---------------------------------------------------------- | -------------------------------------------------------------------------- |
| Adding an `if` branch in `importer.ps1` for a special module    | Infrastructure now has module-specific knowledge           | Make the module conform to the convention, or add a general-purpose hook   |
| Hand-maintaining a `.psd1` with an explicit `FunctionsToExport` | Second source of truth that drifts from the filesystem     | Let `New-DynamicManifest` generate it                                      |
| A loader script that lists modules in a specific order          | Adding a module requires editing the loader                | If ordering matters, encode it in naming convention or dependency metadata |
| A central "registry" hashtable mapping names to functions       | Every new function requires editing the registry           | Use `Get-Command -Module` or convention-based lookup                       |
| Checking module names in conditionals (`if ($mod -eq 'Foo')`)   | Infrastructure is coupled to a specific module's existence | Use a capability check or convention instead of a name check               |

### Convention over configuration

The open/closed guarantee rests on conventions:

- **File name = function name.** `Get-Foo.ps1` exports `Get-Foo`. No mapping table needed.
- **Folder = module.** A directory under `automation/` with `.ps1` files is a module. No registration needed.
- **Root = public, `private/` = private.** Export visibility is determined by file location. No attribute or annotation needed.

These conventions are rigid by design. Rigidity is what makes the system predictable and extensible. If every module followed its own
structure, the bootstrap module could not derive registrations automatically, and you would be back to hand-maintained configuration.

Convention-as-source-of-truth carries one assumption: that a name means exactly one thing. That is the one open/closed seam where
"non-conforming code is invisible" does not hold — two definitions of one name are both discovered, and one quietly wins. The import
therefore fails fast on any collision; the mechanics live in
[dynamic-module-manifests](powershell/dynamic-module-manifests.md#one-global-collision-free-function-namespace).

### Module dependency graph

The allowed inter-module dependency graph is declared in `Catzc.Base.ModuleSystem/configs/dependencies.yml` and enforced by
`Assert-ModuleDependency`. The file has two sections: `groups:` and `modules:`. A `groups:` entry declares a named set of on-disk modules
with its own internal member→member DAG — a group is a concept, not a disk module; its name is a logical handle, not a folder. A consumer
module's allowed-deps in `modules:` may name a GROUP (permitting an edge to any member of that group) and/or a specific MODULE (tight
coupling). Integrity is group-aware: actual edges must fall within the resolved allow-set, each group's internal DAG must be acyclic, and
actual intra-group edges must be a subset of the declared internal map. The ex-`Catzc.Base.Utils` cluster is held together as the `Base`
group — its eleven successor modules are the group's members, each with its own intra-group layering declared in `dependencies.yml`.

## Decision

The platform must remain open for extension and closed for modification. Concretely:

## Disambiguation

The module-dependency graph this ADR references (`dependencies.yml`, `groups:`/`modules:`, `Assert-ModuleDependency`) is owned by
[controlling-module-dependencies](controlling-module-dependencies.md) (`ADR-MODDEPS`).

## Consequences

- Adding a function is a one-step operation: create the file.
- Parallel development never conflicts on infrastructure files.
- The bootstrap module and importer are stable — they change only when the conventions themselves change, which is rare.
- Onboarding is trivial: "put a file here, it works."
- Debugging module loading issues reduces to "is the file in the right place with the right name?" — never "is it registered in three
  different places?"
- One name means one thing repo-wide: a collision fails the import with a named error instead of silently shadowing
  ([dynamic-module-manifests](powershell/dynamic-module-manifests.md)).
- The tradeoff is rigidity: modules that do not follow convention are invisible to the system. This is intentional — the cost of one naming
  fix is far lower than the cost of maintaining special-case infrastructure.

## Dora explains:

Convention-driven discovery eliminates merge conflicts and hand-maintained registrations, letting teams extend the system without
coordinating around shared infrastructure. This is foundational to scaling development velocity without bottlenecks.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — conventions make extension predictable and reduce
  special-case infrastructure.
- [Loosely coupled teams](https://dora.dev/capabilities/loosely-coupled-teams/) — adding capability never requires touching shared bootstrap
  code.
- [Platform engineering](https://dora.dev/capabilities/platform-engineering/) — self-service extension through stable conventions.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
