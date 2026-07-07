# ADR: Install / Uninstall / Remove — the tool lifecycle and the destructive-eviction escalation

## Rules: ADR-REMOVE

### Rule ADR-REMOVE:1

Three verbs, three jobs, per tool: `Install-<Tool>` converges the machine to the configured, pinned install through the configured manager;
`Uninstall-<Tool>` reverses it through that **same** manager; `Remove-<Tool>` destructively evicts an **off-config** install the managed
path cannot touch. Install- and Uninstall- are the managed pair (the `ADR-SYSDEPS:2` triad); Remove- is the source-agnostic escape hatch
beside them.

- [The three verbs](#the-three-verbs)

### Rule ADR-REMOVE:2

`Uninstall-<Tool>` is managed-only and reversible in kind: it removes exactly what the configured manager installed (winget / brew / apt /
uv / script) and nothing else. It cannot evict a foreign install — winget does not know an apt package, a uv venv does not know a `pip`
leftover — and it does not try; that is `Remove-<Tool>`'s job.

- [Uninstall is managed, Remove is source-agnostic](#uninstall-is-managed-remove-is-source-agnostic)

### Rule ADR-REMOVE:3

`Remove-<Tool>` refuses a **managed** install and redirects to `Uninstall-<Tool>`. Whether an install is managed is decided by the single
oracle `Test-ExpectedPackageManager`, which both verbs consult — so Remove- only ever acts on an install the configured manager does not
own, and the destructive verb never fires on a cleanly-managed one.

- [Uninstall is managed, Remove is source-agnostic](#uninstall-is-managed-remove-is-source-agnostic)

### Rule ADR-REMOVE:4

Destructive removal is **double-gated**. `-Force` confirms the action — without it the function reports the plan and changes nothing (the
dry-run discipline of `ADR-DRYRUN`), so the destructive step never runs on host narration alone. Through the escalation, a separate
`-Remove` switch opts in, so neither switch alone deletes anything.

- [Default-safe by construction](#default-safe-by-construction)

### Rule ADR-REMOVE:5

The escalation is one call: **`Uninstall-<Tool> -Remove -Force`** runs the managed uninstall and then falls through to `Remove-<Tool>`,
evicting whatever the configured manager did not own. It is the sanctioned path when a plain `Uninstall-<Tool>` is unsuccessful or leaves a
shadowing binary — the operator escalates in place instead of hunting the foreign install by hand.

- [The escalation in one call](#the-escalation-in-one-call)

### Rule ADR-REMOVE:6

Elevation follows the mechanism, never the verb. A removal asserts Administrator / root only for the step that needs it — the Windows
machine `PATH`, an `apt-get remove` — while user-space evictions (`uv pip uninstall --system`, deleting a stray `~/.local/bin` binary)
assert nothing. A non-elevated run performs every user-space removal and asks for elevation only when a system step is unavoidable, matching
the all-user-space goal (`ADR-UVPY`).

- [Elevation follows the mechanism](#elevation-follows-the-mechanism)

### Rule ADR-REMOVE:7

Two platform cores carry the destructive mechanics, and `Remove-<Tool>` delegates to the one for the running OS: `Remove-SystemInstallation`
(Windows — delete the install directory, strip it from the machine `PATH`, clear its env vars) and `Remove-LinuxToolInstall` (Linux —
`apt-get remove` a dpkg-owned shadow, `uv pip uninstall --system` a package in the uv-managed Python, or delete a stray on-`PATH` binary).
macOS routes an off-config removal through `brew` or the owning file.

- [The platform cores](#the-platform-cores)

### Rule ADR-REMOVE:8

`Remove-<Tool>` exists only for tools that are **historically installed off-config** — a distro package, a `pip install`, an OS stub, a
hand-built binary — that would shadow the managed build. It is not minted for every tool (the `ADR-SYSDEPS:2` triad is); it is added where
an eviction hole exists. `Get-ToolsStatus` names the correct verb per state: `Uninstall-` for a managed wrong version, `Remove- -Force` for
an off-config shadow.

- [Not every tool needs a destructive Remove](#not-every-tool-needs-a-destructive-remove)

## Context

The toolchain converges a machine to a pinned, increasingly **user-space** set of tools
([controlling-systemwide-deps](controlling-systemwide-deps.md), [uv-python-handler](uv-python-handler.md)). But machines carry history. A
tool this repo once installed a different way; a distro package a developer `apt install`-ed; a `pip install` from before uv owned Python;
an OS-provided stub (the Windows Store `python`); a hand-built binary on `PATH`. Each is an **off-config install** — present, usually on
`PATH`, and shadowing or blocking the managed build the toolchain wants to own.

The managed `Uninstall-<Tool>` cannot clear these. It reverses `Install-<Tool>` through the configured manager, and a manager only knows its
own installs: winget cannot uninstall an apt package, a uv venv cannot remove a `pip` leftover, a script-installed `~/.dotnet` uninstall
does nothing to a system `dotnet`. So there has to be a second, blunter instrument — one that gets a tool **out** regardless of how it
arrived — and a clean way to reach for it when the managed uninstall was not enough.

`Uninstall-Chocolatey` is already that shape in the tree: a destructive eviction of an unwanted, off-config package manager, run without
ceremony as the first step of provisioning ([use-proper-package-managers](use-proper-package-managers.md)). This ADR generalizes it into a
per-tool verb and an escalation, so "make this the configured install, evicting whatever is in the way" becomes a first-class, uniform
operation.

## Decision

Every tool the toolchain manages is operated through three verbs — `Install-`, `Uninstall-`, `Remove-` — with a `-Remove` escalation on
`Uninstall-` that chains the managed uninstall into the destructive eviction.

### The three verbs

- **`Install-<Tool>`** converges the machine to the configured, pinned install through the configured manager. Idempotent
  ([idempotent-state-functions](idempotent-state-functions.md)) and re-runnable.
- **`Uninstall-<Tool>`** reverses `Install-` through the **same** manager — the managed, in-kind removal (`Uninstall-Tool` → winget / brew /
  apt; the uv and script equivalents).
- **`Remove-<Tool>`** is the source-agnostic, destructive eviction of an off-config install the managed pair cannot touch.

The verbs keep their PowerShell contracts ([respect-pwsh-verb-rules](powershell/respect-pwsh-verb-rules.md)): `Uninstall-` removes a
resource from a location the manager owns; `Remove-` deletes a resource from a container — the blunter delete, which is why the destructive
operation carries that verb rather than overloading `Uninstall-`.

### Uninstall is managed, Remove is source-agnostic

`Uninstall-<Tool>` knows exactly one mechanism: the configured manager's own uninstall. Handed an install that manager did not place, it has
nothing to do, and it does not guess. `Remove-<Tool>` is the opposite — it inspects how the install actually reached the machine and removes
it that way.

One oracle tells the two apart: `Test-ExpectedPackageManager`. If it reports the install **managed** (the configured manager owns it),
`Remove-<Tool>` refuses and points at `Uninstall-<Tool>`; if not, `Remove-<Tool>` owns the eviction. So the destructive verb never fires on
a cleanly-managed install, and the managed verb never pretends to evict a foreign one — each stays honest about what it can do.

### Default-safe by construction

Nothing destructive happens by default. `Remove-<Tool>` (and the escalation) is **double-gated**:

- **`-Force` confirms the action.** Without it, the function reports the plan — the directory it would delete, the package it would remove —
  and changes nothing. This is the dry-run discipline of [prefer-dryrun-over-shouldprocess](powershell/prefer-dryrun-over-shouldprocess.md):
  the plan is a returned, capturable value, not host narration, and the side effect is behind an explicit switch.
- **`-Remove` intends the escalation.** On `Uninstall-<Tool>`, the destructive fall-through runs only when `-Remove` is present, so a plain
  `Uninstall-<Tool>` can never delete off-config state as a surprise.

Neither switch alone deletes anything: `-Force` without `-Remove` on `Uninstall-` is still a managed uninstall; `-Remove` without `-Force`
is a dry-run plan.

### The escalation in one call

`Uninstall-<Tool> -Remove -Force` is the whole point of the pattern. It runs the managed uninstall, then falls through to `Remove-<Tool>`,
evicting whatever the configured manager did not own. It is the path for the common failure: _"I ran `Uninstall-<Tool>` and the tool is
still on `PATH`"_, or _"`Uninstall-<Tool>` errored because the install was foreign."_ Rather than diagnosing the off-config install and
removing it by hand, the operator escalates in place — one call that says "uninstall it the managed way, and if anything is left that the
manager did not own, evict that too."

`-Remove` reads as intent ("escalate to destructive eviction if the managed uninstall leaves something"); `-Force` confirms the destructive
step. A plain `Uninstall-<Tool>` stays managed-only and safe.

### Elevation follows the mechanism

A removal asserts elevation only for the step that genuinely needs it, never as a blanket precondition of the verb. Deleting a directory and
editing the machine `PATH` on Windows needs Administrator; an `apt-get remove` needs root. But a `uv pip uninstall --system`, or deleting a
stray binary under `~/.local/bin`, is entirely user-space and asserts nothing. So a non-elevated `Remove-<Tool>` still performs every
user-space eviction and asks for elevation only when a system step is unavoidable — which is what lets the pattern serve the migration
toward an all-user-space toolchain ([uv-python-handler](uv-python-handler.md)) instead of demanding root to do anything.

### The platform cores

`Remove-<Tool>` is a thin per-tool front over a platform core that carries the destructive mechanics:

- **`Remove-SystemInstallation` (Windows).** Deletes the install directory, strips it (and named subdirectories) from the machine `PATH`
  registry key, clears the tool's system env vars, and broadcasts `WM_SETTINGCHANGE`. Windows-only by construction (it edits `HKLM`).
- **`Remove-LinuxToolInstall` (Linux).** Evicts by the mechanism that placed the install: `apt-get remove` a shadow that `dpkg` owns (the
  one step that asserts root), `uv pip uninstall --system` a package sitting in the uv-managed Python (user-space — the uv-scoped uninstall,
  not a foreign system `pip`), or delete a stray on-`PATH` binary the managers do not own (user-space).

macOS off-config removal routes through `brew` or the owning file. A `Remove-<Tool>` selects the core for the running OS, exactly as
`Install-<Tool>` selects the installer.

### Not every tool needs a destructive Remove

The `Install-` / `Uninstall-` pair is universal (the `ADR-SYSDEPS:2` triad); `Remove-<Tool>` is not. It is added only where a tool has
**historically been installed off-config** and so has a real eviction hole — the tools a machine tends to already carry a foreign copy of: a
distro `nodejs`, a `pip`-installed CLI, a Store `python`, a system `dotnet`. Minting a `Remove-` for a tool that only ever arrives through
its configured manager would be dead ceremony ([one-living-version](../principles/one-living-version.md)). `Get-ToolsStatus` is the guide:
it reports each tool's state and names the verb — `Uninstall-` when the configured manager owns a wrong version, `Remove- -Force` when an
off-config binary shadows the managed install — and only recommends `Remove-` for a tool that actually has one.

## How this is enforced

- **`Test-ExpectedPackageManager`** is the managed / off-config oracle both `Uninstall-` (implicitly, via `Uninstall-Tool`) and `Remove-`
  consult; `Remove-<Tool>` throws and redirects to `Uninstall-<Tool>` when it reports the install managed.
- **`Remove-SystemInstallation` (Windows) and `Remove-LinuxToolInstall` (Linux)** are the platform cores; a `Remove-<Tool>` delegates to the
  one for the running OS and adds only the tool's own detection.
- **The `-Force` dry-run discipline** ([prefer-dryrun-over-shouldprocess](powershell/prefer-dryrun-over-shouldprocess.md)) and the `-Remove`
  escalation switch are the two gates; a removal with neither is a plan, not an action.
- **`Get-ToolsStatus`** names the correct verb per tool state, and recommends `Remove- -Force` only for a tool that defines a `Remove-`.
- **`Uninstall-Chocolatey`** is the exemplar eviction the pattern generalizes
  ([use-proper-package-managers](use-proper-package-managers.md)).
- **Code review** keeps the split honest: a `Uninstall-` that reaches past its manager to delete foreign state, or a `Remove-` that acts on
  a managed install, is rejected against this ADR.

## Consequences

- "Make this the configured install, evicting whatever is in the way" is one uniform operation across tools and platforms, instead of a
  hand-diagnosed cleanup each time.
- The safe and the destructive removals are named apart: `Uninstall-` is the reversible managed inverse of `Install-`; `Remove-` is the
  blunt eviction, and it cannot run without `-Force` (and, through the escalation, `-Remove`).
- The escalation gives one discoverable path when a managed uninstall is not enough — `Uninstall-<Tool> -Remove -Force` — rather than
  leaving the operator to find and remove the foreign install by hand.
- Elevation is paid only where a system step demands it, so user-space evictions run unprivileged and the pattern advances the
  all-user-space migration rather than fighting it.
- The cost is one more verb to maintain for the tools that need it, plus the two platform cores — bounded, because `Remove-` is added only
  where an off-config eviction hole actually exists.

## Related

- [controlling-systemwide-deps](controlling-systemwide-deps.md) (`ADR-SYSDEPS`) — the `Install-` / `Invoke-` / `Uninstall-` triad this
  extends, and `Test-ExpectedPackageManager`.
- [use-proper-package-managers](use-proper-package-managers.md) (`ADR-PKGMGR`) — `Uninstall-Chocolatey`, the exemplar eviction.
- [prefer-dryrun-over-shouldprocess](powershell/prefer-dryrun-over-shouldprocess.md) (`ADR-DRYRUN`) — the `-Force` dry-run gate.
- [respect-pwsh-verb-rules](powershell/respect-pwsh-verb-rules.md) (`ADR-VERBS`) — the `Uninstall-` vs `Remove-` verb contracts.
- [uv-python-handler](uv-python-handler.md) (`ADR-UVPY`) — the user-space goal the scoped-elevation rule serves.
- [idempotent-state-functions](idempotent-state-functions.md) (`ADR-IDEM`) — `Install-`/`Uninstall-`/`Remove-` are idempotent.
