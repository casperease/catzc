---
catzc:
  immutable:
    with_body_sha: "6de303bdf0d4"
    path: docs/explanation/automation/a-type-keyed-reflection-table-is-not-a-session-cache.md
    folder: docs/explanation/automation
    name: a-type-keyed-reflection-table-is-not-a-session-cache
    filetype: md
    kind: explanation
    language: markdown
    track: docs
  edges:
    cites:
      - ADR-AUTO-CACHE#{1,4-7}
      - ADR-AUTO-TYPES#7
      - ADR-PWSH-CACHE#1
    links:
      - docs/adr/automation/BCL/native-csharp-types.md
      - docs/adr/automation/caching.md
      - docs/adr/pwsh/script-scope-caching.md
      - docs/explanation/automation/index.md
      - docs/explanation/automation/unboxing-is-cheap-and-crossings-are-not.md
---

# A static table keyed by Type is not a session cache, so ADR-AUTO-CACHE does not govern it

```text
ADR-AUTO-CACHE governs functions that cache a derivation of the file set; a Type-keyed reflection table in a C# type is neither.

1  scope        ADR-AUTO-CACHE caches static config reads and filesystem-derived information, in a function, in module $script: state
2  the table    a static ConcurrentDictionary<Type, Shape> inside a compiled type, filled on first use
3  its input    the compiled assembly, not the file set and not the runtime
4  its life     the process: a loaded type cannot change (ADR-AUTO-TYPES#7), so the key cannot go stale
5  invalidation none needed; the importer neither reaches it nor needs to
6  borrowed     read-only values, a session-stable key and lazy fill: the principles carry over, the rules do not apply
7  review       no ADR line is needed; the type states the rule in its own comment
```

This article answers one question that blocks the unboxing change plan: does `ADR-AUTO-CACHE` govern a static, `Type`-keyed reflection table
inside a C# type, such as the per-type property table proposed for `DictionaryRecord` and `ConsoleText`? It does not. The reasoning follows
from what the ADR and the type system define; the two are read here, and no rule has to be added. It is a prose article without a diagram.

## Walkthrough

1. **What the ADR governs.** `ADR-AUTO-CACHE` is about "static config reads" and "filesystem-derived information"
   ([caching](../../adr/automation/caching.md)): rule 1 is a function that loads and parses a checked-in file (`Get-Config`), rule 2 a
   function that scans the repository by convention (`Get-BicepTemplates`). Rule 9 covers git state, rule 10 a quality check's clean
   verdicts, rule 8 the committed type assembly itself. Its decision stores the cache in module `$script:` state
   ([script-scope-caching](../../adr/pwsh/script-scope-caching.md), `ADR-PWSH-CACHE#1`), and its one invalidation is re-running the importer
   (`ADR-AUTO-CACHE#6`).
2. **What the table is.** A `ConcurrentDictionary<Type, Shape>` in a static class under a module's `types/`, filled by `GetOrAdd` on the
   first use of a type. Its entries are the readable properties of a type, a name-to-property map, and the type's `[ConsoleDisplay]` list:
   facts about a compiled type.
3. **Its input is the assembly.** Every cached thing in the ADR is a pure function of files on disk that a person can change between
   sessions, or of runtime state. A `Type`'s metadata is a function of the loaded assembly, which is itself the rule-8 build named for the
   hash of every `types/*.cs`. The table caches nothing about the repository's content and nothing a person edits mid-session.
4. **Its life is the process, and it cannot go stale.** A loaded assembly cannot be swapped in a running process; on a devbox a changed type
   warns and the old types stay until restart, and in a pipeline the loader throws (`ADR-AUTO-TYPES#7`,
   [native-csharp-types](../../adr/automation/BCL/native-csharp-types.md)). The key is the `Type` object itself, so a type from a different
   assembly is a different key, and one type's metadata never changes. The cache cannot be wrong while the process lives.
5. **No invalidation, and no reach for the importer.** Re-running the importer discards module `$script:` state; it does not unload a type
   or a static field in a type. That is correct here: the entry would be rebuilt to the same answer. A new process starts with an empty
   table. This is the reason the ADR's rules 1, 2, 6, 9 and 10, which are about when a stored answer stops being true, do not apply.
6. **What carries over by sense.** Three ideas of the ADR are good practice for the table and are kept, as practice and not as a rule it is
   held to. A cached value is read-only to its callers (`ADR-AUTO-CACHE#5`): a `Shape` exposes read-only collections, never an array a
   caller can write. A key is a session-stable value, never a mutable object (`ADR-AUTO-CACHE#4`): a `Type` is. The fill is lazy
   (`ADR-AUTO-CACHE#7`): `GetOrAdd` on first use, never at import, so the importer budget is untouched.
7. **Review, not a new rule.** No ADR text speaks about static state in a type. The existing static tables in `types/` are constants:
   `SentenceGuid.Map`, `WinAnsi.Typographic`, the defaults of `TimeoutsConfig`, the compiled `Regex` fields of `LinkEngine`. A `Type`-keyed
   table is the first one filled at run time, so its type carries a short comment naming the rule that makes it safe (a loaded type cannot
   change) and why it is not a session cache. The comment is the whole record; an ADR line for one table would be a rule with one user.

## Why it holds

- The ADR's scope is a function's cached derivation of the file set or of the runtime; a reflection table is neither, so the rules about
  invalidation do not reach it (`ADR-AUTO-CACHE#1`, `#2`, `#6`).
- A loaded type cannot change inside a process, so a table keyed by that type cannot be stale (`ADR-AUTO-TYPES#7`).
- One living version of each behaviour: the two copies of "which properties are data" collapse into one table (`ADR-PRIN-ONELIVE`).

## Where the article and the code differ

- The ADR does not say that a static field in a type is outside it. This article reads its scope from the ADR's title, rules and examples,
  and the ADR is silent about type-level statics. If a reader holds that silence is not an exclusion, the one-sentence ADR addition is the
  fallback, and it is the user's decision.
- The table does not exist yet. The `Shape` and its comment are a proposal in the unboxing change plan (step C-2).
- Thread safety is by `ConcurrentDictionary.GetOrAdd`, which may run the factory twice for one key on a race. The factory is pure, so the
  duplicate is discarded and the answer is the same.
- Retained memory of the table, one small `Shape` per type that is ever read through it, was not measured.

## See also

- [Unboxing is cheap, the type tests and crossings around it are not](unboxing-is-cheap-and-crossings-are-not.md)
- [caching](../../adr/automation/caching.md) and [script-scope-caching](../../adr/pwsh/script-scope-caching.md)
- [Automation explanations](index.md)
