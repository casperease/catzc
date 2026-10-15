---
catzc:
  derived:
    path: docs/references/automation/internal/Catzc.Internal.Types.psm1.md
    kind: comment-page
    body_sha: dc686acb955a
    adrs:
      - ADR-AUTO-TYPES#12
      - ADR-AUTO-TYPES#7
      - ADR-PWSH-PESTER#9
    links: []
---

# automation/.internal/Catzc.Internal.Types.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Both the loader (Import-CSharpTypes, in the bootstrap) and the janitor (Clear-ModuleTypeCache, a Catzc module)
must agree byte-for-byte on this hash, or the janitor plans the live build for deletion. The algorithm lives
here once, called from both layers via Import-InternalModule (see one-living-version). The one compile path
for the combined assembly (Build-CombinedTypeAssembly) lives here too, shared by the loader and a build, and so
does the one load path (Import-TypesAssembly — a per-user shadow copy, so no session ever locks .compiled),
shared by the loader and the analyzer rule that needs the types.

The hash is EOL-insensitive (every CR byte stripped before the per-file digest), so a CRLF vs LF working tree
keys the same DLL on every machine, and it folds in each file's <module>|<bare type> so a move between modules
or a rename re-keys even on byte-identical content. Deterministic, culture-independent ordering. This does NOT
validate namespaces or reject dotted filenames — that is the loader's concern; the janitor must never throw on
a source that is wrong.
```

## comment:2

Section `.PARAMETER Module` of the comment-based help.

```text
Restricts the hash to these module folders (a build of a module subset). Omitted, every non-dot module
folder is hashed, plus a build's .compiled/types/<module>/*.cs (the unselected modules' sources). A named
module without a types/ folder simply contributes nothing.
```

## comment:3

Above `$selected = $null`.

```text
Assigned directly, never through an if-expression: an empty HashSet emitted from a statement enumerates to
$null, which would silently widen an empty selection to every module.
```

## comment:4

Above `$files = [System.Collections.Generic.List[object]]::new()`.

```text
Enumerate every non-dot module's types/*.cs. Key = "<module>/<bare type>"; Path = the source file. No
namespace / dotted-name validation here (the loader's job). [System.IO] over Get-ChildItem for the
~20ms/call provider overhead the raw enumeration avoids
([ADR-PWSH-PESTER#9](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester9)).
```

## comment:5

Above `$compiledTypesDir = [System.IO.Path]::Combine($AutomationRoot, '.compiled',...`.

```text
A build ships the full type set but only the selected modules' folders; the other modules' sources sit
under .compiled/types/<module>/ so the importer never mistakes them for module folders. Keyed the same way,
so the hash equals the one over the full type set. A source tree has no .compiled/types, so this adds
nothing there.
```

## comment:6

Above `$sortedFiles = [object[]]$files.ToArray()`.

```text
Deterministic, culture-independent order: sort by <module>/<bare type> ORDINALLY (Sort-Object is
culture-aware — cross-platform ADR — so use an ordinal comparer over the keys).
```

## comment:7

Above `$latin1 = [System.Text.Encoding]::Latin1`.

```text
Per-file EOL-INSENSITIVE digest: hash the source bytes with every CR (0x0D) stripped, so a CRLF vs LF
working tree (git core.autocrlf, an editor's format-on-save) yields the same digest and never re-keys the
committed DLL on a pure line-ending flip. The combined hash folds in each file's <module>|<bare type>|digest.
One SHA instance is reused for the per-file digests and the final combined hash. First 8 hex, lowercase.
The CR strip round-trips through Latin1 — a byte-exact 1:1 byte<->char mapping — so it runs as one native
String.Replace instead of a per-byte pipeline (~1.2s per cold import). This runs before the combined
assembly loads, so Catzc.Base.Globs.DurableHash (the native equivalent) is not callable here.
```

## comment:8

Section `.DESCRIPTION` of the comment-based help.

```text
A loaded assembly cannot be unloaded or swapped in a running process, so a source changed after its types
loaded stays stale until a new process loads it
([ADR-AUTO-TYPES#7](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types7)). This is the one
place that limitation is measured; the loader (Import-CSharpTypes), the importer's restart, and the public
Test-LoadedTypesCurrent / Assert-LoadedTypesCurrent pair all read it.

It reads the session record the loader keeps per code root ($global:__CatzcTypes,
[ADR-AUTO-TYPES#12](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types12)) and compares it
with the sources on disk (Get-CombinedTypeHash):

  nothing loaded    no type of the root is in the process: current (the next import loads them);
  same root         loaded on behalf of this root: every source added, changed, or removed since is drift;
  another root      loaded on behalf of another root (the other run mode): a source whose digest differs
                    from that root's record is drift, and so is a type the process lacks.

Drift entries read 'added <module>/<type>', 'changed …', 'removed …', or 'not loaded …'. An added or not
loaded type is also listed as missing: code that uses it cannot run on the old types at all.
```

## comment:9

Above `$otherRoots = [System.Collections.Generic.List[string]]::new()`.

```text
Cross-root: the types are in the process, but loaded on behalf of a different root. Compare per-file
digests against the root that recorded each one; a type no recorded root claims is taken as it is.
```

## comment:10

Section `.DESCRIPTION` of the comment-based help.

```text
The one compile path for the combined types assembly: the loader (Import-CSharpTypes) calls it to restore
automation/.compiled/Catzc.Types.<hash>.dll, and a build calls it to produce the assembly of the modules it
ships. The hash comes from Get-CombinedTypeHash over the same module selection, so the file name always
keys exactly the sources compiled.

Add-Type -OutputAssembly writes the DLL and does NOT load it, so this works in a session that already holds
the types. Each .cs is a separate compilation unit (Add-Type -Path), so each file's file-scoped namespace
is legal while every type still lands in one assembly. The compile goes to a per-process temp file that is
then moved into place, so a concurrent writer never sees a half-written DLL; a lost race (same hash, same
sources) just discards the temp. A failed compile also removes its temp file before the compiler's error
propagates. An existing DLL of the same hash is kept as is (Compiled = $false).

The compile reads a frozen copy of the sources, never the live files: they are copied once into a per-process
folder in the same <module>/types/<file>.cs layout, and the copy is both hashed and compiled. A source another
session saves while the compiler runs can therefore neither break this compile nor land in a DLL whose name
keys the bytes from before the save: the DLL's name always hashes exactly the bytes compiled.

Source validation (bare filenames, the module's file-scoped namespace) is the loader's concern, not this
function's — a caller that compiles the sources before they are validated gets the compiler's own errors.
```

## comment:11

Section `.DESCRIPTION` of the comment-based help.

```text
%LOCALAPPDATA%\catzc\types on Windows, ~/.local/share/catzc/types on Unix — the same per-user catzc root
the tool venvs use. Shared by every session, clone, and installed version of the user: a copy is named
for the hash of the sources it was compiled from, so equal names mean equivalent types.
```

## comment:12

Section `.DESCRIPTION` of the comment-based help.

```text
A loaded assembly is locked on Windows for the life of the process, so loading
automation/.compiled/Catzc.Types.<hash>.dll in place would let any long-lived session — a console, the
editor's analyzer host, a test worker — pin a superseded build inside the repository. Every load goes
through here instead: the DLL is copied into the shadow root (Get-TypesShadowRoot) under its own name,
and the copy is loaded. The source file is only ever read, so .compiled can always be pruned.

A copy is named for its source hash, so it never changes once written: an existing copy is reused, and a
new one is written to a per-process temp file and moved into place (a concurrent writer that wins the
race leaves an equivalent copy, and the temp is discarded). A copy rather than a load from bytes, because
a byte-loaded assembly has no Location, and code that compiles against the types references it by path.

Each load refreshes its copy's write time; other copies untouched for -PruneAfter (a day by default) are
pruned, best-effort (a locked or vanished copy is skipped). The age bound keeps a copy that another process
has just written but not yet loaded from being pruned under it.
```

## comment:13

Section `.PARAMETER PruneAfter` of the comment-based help.

```text
How long another copy may go untouched before it is pruned. Defaults to one day: long enough that no
in-flight load loses its copy, short enough that superseded builds do not pile up.
```
