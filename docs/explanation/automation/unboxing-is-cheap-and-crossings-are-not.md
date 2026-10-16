---
catzc:
  derived:
    path: docs/explanation/automation/unboxing-is-cheap-and-crossings-are-not.md
    kind: explanation
    language: markdown
    filetype: md
    track: docs
    body_sha: dc4cf83cc6db
    links:
      - docs/adr/automation/BCL/native-csharp-types.md
      - docs/adr/pwsh/bounded-enumeration.md
      - docs/adr/pwsh/hosting-csharp-types.md
      - docs/explanation/automation/index.md
      - docs/explanation/index.md
---

# Unboxing is cheap, the type tests and crossings around it are not

```text
Reading a value out of an object costs a few nanoseconds and allocates nothing. What costs more is on the way to it.

1  box        a value type copied into a heap object so it can be held as object: the only allocation
2  unbox      (int)o or o is int n: a type check and a copy, 2.5 ns, no allocation
3  wrap       PowerShell's PSObject around any object: a different thing from a box
4  type test  an interface test on a primitive, tested before the exact type: the common waste in C#
5  reflection GetProperties and GetCustomAttribute repeated on every call: the common waste in a type that reads properties
6  crossing   one call from PowerShell into a .NET method: about 4 us, thousands of times a box
7  bounded    the cost is worth cutting only where N is small and fixed and a person waits for the total
```

This article explains where the time goes when cats code boxes, unboxes and unwraps values, and which of those costs a change is worth
making for. The numbers come from a benchmark that compiles the repository's own type sources next to a harness (.NET 10.0.12, PowerShell
7.6.6, 64-bit, Windows 11, one machine, 2026-10-16). It is a prose article without a diagram: the picture is the table in the walkthrough.

## The terms

| Term                     | Meaning here                                                                                                                                                                               |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Box**                  | A value type (int, bool, enum, struct) copied into a new heap object so it can be held as `object`, an interface, `ValueType` or `Enum`. This is the allocation.                           |
| **Unbox**                | Reading the value back out of a box with a cast or a pattern. A type check and a copy.                                                                                                     |
| **Wrap**                 | PowerShell's `PSObject` layer, carrying extra PowerShell members. It can wrap a reference type too, so it is not a box.                                                                    |
| **Unwrap**               | Reading the .NET object out of the wrapper: `.psobject.BaseObject` in PowerShell, `ContractValue.Unwrap` in the contract types.                                                            |
| **Crossing**             | One call from PowerShell into a .NET method. Every argument is converted and every result is held as `object`.                                                                             |
| **Bounded fast context** | A path whose item count is small and fixed by design, where the per-item cost multiplies into something a person waits for: the import, a per-file loop, a config read, a console message. |

## Walkthrough

1. **A box is the only allocation.** Assigning an `int`, `bool`, `long`, `double`, `DateTime` or enum to an `object` allocates 24 B (32 B
   for a `Guid` or `decimal`). The common hiding places are an `object`-typed parameter or field, a `params object[]` call, the `object`
   overloads of `string.Format` and `string.Concat`, and the result of `PropertyInfo.GetValue` or `MethodInfo.Invoke`. Generic collections
   over value types (`List<int>`, `Dictionary<string, int>`) store the values inline and do not box.
2. **An unbox is exact and cheap.** `(int)o` costs 2.5 ns and `o is int n` 3.9 ns, with no allocation. The unbox is exact: `(int)(object)5L`
   throws because the box holds a `long`. This is why code that receives a number from YAML tests `is int`, `is long` and `is double`
   separately, as `ContractValue.IsIntegral` does with its nine integral types.
3. **A wrap is not a box.** A string wrapped by PowerShell is a `PSObject`: `$x -is [string]` is true in PowerShell, while a C#
   `value is string` is false for the same object. A C# method that accepts `object` from PowerShell must unwrap first, once, at its entry.
   `ContractValue.Unwrap` costs 5 ns for a raw value and 10 ns for a wrapped one, with no allocation. Making the wrap costs 46 ns and 152 B.
   The repository has one structural unwrap in first-party code; no first-party `.ps1` or `.psm1` calls `.BaseObject`, `AsPSObject` or
   `ArrayList`.
4. **The type test around the unbox costs more than the unbox.** `ContractValue.Kind` classifies a value by testing `IDictionary` and
   `IList` before the scalar types. An interface test on a boxed primitive is slow, so `Kind(int)` takes 37 ns against 9.5 ns for a string.
   `ContractValue.Equal(int, int)` takes 107 ns against 14 ns for a plain `a is int x && b is int y`. No byte is allocated in either: the
   whole gap is type tests and conversion-helper calls. The rule is to test the exact type first.
5. **The reflection lookup around the read costs more than the box.** `ConsoleText.ToConsoleString` on a five-property type takes 2,009 ns
   and allocates 1,304 B. Its `GetCustomAttribute` lookup is 374 ns, its `GetCustomAttributes(true)` calls 223 ns and `GetProperties` 83 ns.
   The reads that really box, `GetValue` on five properties, are 95 ns and 72 B: about 5 % of the call. `DictionaryRecord.Contains` costs 73
   ns and 24 B; with a per-type property table built once it costs 55 ns, and the 24 B box in `GetValue` stays. The rule is to cache
   reflection metadata per type.
6. **A crossing costs thousands of boxes.** From a PowerShell loop a `ContractValue.Kind` call costs about 4 us and 2.5 KB more than the
   empty-loop baseline of about 6 us and 5.2 KB. The C# work inside is 10 to 107 ns, so the unbox inside a crossing is at most 3 % of the
   crossing. The PowerShell figures carry about plus or minus 2 us of noise, so only the order of magnitude holds. In PowerShell the lever
   is the number of crossings: hand the whole bounded list to one C# method.
7. **Only a bounded, waited-for path is worth it.** The saving per call is microseconds, so a change is worth making only where the call
   count is bounded and multiplies. The repository's wall-clock cost is elsewhere: each source file is parsed three times and a function is
   called per file, and boxing is under 1 % of the allocation of those stages. Reducing unboxing alone does not make a build or a test run
   visibly faster.

## Where in the repository

| Place                                                 | What happens                                                                              | Worth changing?                |
| ----------------------------------------------------- | ----------------------------------------------------------------------------------------- | ------------------------------ |
| `ContractValue`, `ContractSchema`, `ContractFragment` | `Kind` and `Equal` test interfaces before scalars; `MatchArray` calls `Equal` n x m times | Yes: exact scalar types first  |
| `DictionaryRecord`, `ConsoleText`                     | `GetProperty`, `GetProperties` and attribute lookups repeated on every call               | Yes: one cached per-type table |
| Config types reading raw YAML (`is bool`, `(int)`)    | One unbox per value, once per file, behind the `Get-Config` cache                         | No                             |
| `Hashtable` storage in four config types              | Boxed values built once per config load                                                   | No                             |
| 678 `string.Format` calls in 132 type files           | About 58 pass an int; nearly all run on an error path                                     | No                             |
| `ContractSchema.Validate`                             | 7.6 us and 11 KB for 11 nodes: list building and LINQ, not boxes                          | Not here                       |
| Internal `.psm1` modules                              | Bounded loops over about 250 type files and 60 modules, no unbox                          | No                             |

## Why it holds

- A compiled type is the hot-path form when a measurement says so, and the measurement decides, not the habit
  ([bounded-enumeration](../../adr/pwsh/bounded-enumeration.md), ADR-PWSH-ENUM).
- A type lives in a file under `types/` of its module and is compiled into one combined assembly that cannot change inside a running
  process, so a per-type table in a type is valid for the life of the process
  ([native-csharp-types](../../adr/automation/BCL/native-csharp-types.md), ADR-AUTO-TYPES;
  [hosting-csharp-types](../../adr/pwsh/hosting-csharp-types.md), ADR-PWSH-TYPES).
- There is one living version of each behaviour, so a faster `Kind` replaces the slower one in place: no `Fast` variant beside it
  (ADR-PRIN-ONELIVE).

## Where the article and the code differ

- The faster `Kind`, `Equal` and per-type table are measured as prototypes in the benchmark harness; they are not yet in the types. The rows
  above that say "yes" are a proposal until a change lands and its tests pass.
- The prototypes keep the current result by reading the code; the contract test suites have not been run against them.
- How PowerShell decides to hand a `PSObject` wrapper to an `object` parameter was not traced to its source. The existence of
  `ContractValue.Unwrap` shows that it happens; test with `-is [psobject]` before relying on either answer.
- Retained memory, what the caches would keep alive, was not measured. Single runs have a noise of about 15 %.

## See also

- [Automation explanations](index.md)
- [native-csharp-types](../../adr/automation/BCL/native-csharp-types.md)
- [Explanation index: how to read the articles](../index.md)
