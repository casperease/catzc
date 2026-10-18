# Unboxing in PowerShell and C#: a reference

Written 2026-10-16 for catzc. Runtime for every measurement: .NET 10.0.12, PowerShell 7.6.6, 64-bit, Windows 11. A figure is **measured**
when it comes from `out/bench-unboxing.ps1` (this article) or `out/boxing-bench.ps1` (the 2026-10-15 analysis in `out/analysis-boxing.md`).
A statement marked **read from the code** comes from this repository's source. Anything else is general runtime knowledge, and the article
says so.

## 1. Words, used one way

| Term                     | Meaning here                                                                                                                                                                                                                                                                                                                 |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Box**                  | Copy a value type (int, bool, enum, struct) into a new heap object so it can be held as `object`, an interface, `ValueType` or `Enum`. This is the allocation.                                                                                                                                                               |
| **Unbox**                | Read the value back out of a box with a cast (`(int)o`) or a pattern (`o is int n`). A type check and a copy. No allocation.                                                                                                                                                                                                 |
| **Wrap**                 | PowerShell's own layer: a `PSObject` around any .NET object, carrying extra PowerShell members. A different thing from a box, and it can wrap a reference type.                                                                                                                                                              |
| **Unwrap**               | `psobject.BaseObject`, or `ContractValue.Unwrap` in this repository. Read the .NET object out of the wrapper.                                                                                                                                                                                                                |
| **Crossing**             | One call from PowerShell into a .NET method, or back. Every argument is converted and every result is held as `object`.                                                                                                                                                                                                      |
| **Bounded fast context** | A path where the item count N is small and fixed by design, and the per-item cost multiplies into something a person waits for: the import, a per-file scope loop, a config read, a console message. The time safeguard (3 s on a devbox for one foreground call) and the test roofs make these paths real constraints here. |

The user's phrase "reduce unboxing in a bounded fast context" therefore means: remove the type tests, conversions and boxes that sit on a
hot, bounded path, and prove the saving with a measurement before claiming it.

## 2. What the CLR does

### 2.1 The three IL operations

| IL            | Source form                          | Cost                                  | Failure                                                                        |
| ------------- | ------------------------------------ | ------------------------------------- | ------------------------------------------------------------------------------ |
| `box T`       | `object o = 5;`                      | allocates an object, copies the value | none                                                                           |
| `unbox.any T` | `(int)o`                             | one method-table compare, one copy    | `NullReferenceException` for null; `InvalidCastException` for a different type |
| `unbox`       | `ref readonly` access to the payload | a compare, returns a pointer          | same                                                                           |
| `isinst T`    | `o is int`                           | the compare, no copy                  | none                                                                           |

**Measured:** `(int)boxedInt` 2.5 ns, 0 B. `boxedInt is int v` 3.9 ns, 0 B. Box plus unbox in a loop 10.8 ns and 24 B. The unbox is the
cheap half. A bytes-per-iteration figure is the box.

### 2.2 The unbox is exact

`(int)(object)5L` throws, because the box holds a `long`. The runtime lets an enum unbox as its underlying type and the reverse (general
runtime knowledge). A `Nullable<T>` boxes to the underlying value or to null, never to a box of `Nullable<T>`, so `(int?)o` is the safe
unbox for "an int or nothing". This exactness is why code that receives numbers from YAML must test `is int`, `is long` and `is double`
separately: a YAML integer may arrive as either of the first two (read from the code: `ContractValue.IsIntegral` lists nine integral types
for this reason).

### 2.3 What a box costs

**Measured** (`out/analysis-boxing.md` §1): 24 B for int, uint, bool, char, long, double, DateTime and enum; 32 B for Guid and decimal; 40 B
and 56 B for the 24 B and 40 B structs. A boxed int held in an `object[]`, `List<object>` or `Dictionary<string, object>` retains 32 B (24 B
box plus 8 B reference) against 4 B in an `int[]`. The .NET 10 JIT did not remove a box that never escaped in the loop shape tested.

### 2.4 Where boxes hide

| Site                                                                                  | Why it boxes                                                                                                      |
| ------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| `object`, `ValueType`, `Enum` or interface-typed variable, field, parameter or return | assignment converts                                                                                               |
| `params object[]` call with value arguments                                           | one box per argument, plus the array (measured: 88 B for two integers)                                            |
| `string.Format("{0}", i)` and `string.Concat(object, ...)`                            | the `object` overload (measured: 63 B total, 24 B of it the box). Interpolation `$"{i}"` and `"a" + i` do not box |
| `PropertyInfo.GetValue`, `MethodInfo.Invoke`, `FieldInfo.GetValue`                    | the result is `object` (measured: 24 B per int, bool or enum read)                                                |
| non-generic collections: `ArrayList`, `Hashtable`, `IEnumerable` over a value array   | the element type is `object` (measured: 24 B per element enumerated)                                              |
| `enum.ToString()`, `IComparable c = i; c.CompareTo(3)`                                | the receiver is boxed (measured: 24 B and 48 B)                                                                   |
| a struct that does not override `Equals`, `GetHashCode`                               | the base implementation takes `object` (general knowledge)                                                        |
| a closed delegate over a struct instance method                                       | the receiver is boxed once (general knowledge)                                                                    |

Generics over value types are **not** boxing: `List<int>`, `Dictionary<string, int>` and `HashSet<int>` store the values inline, and a
constrained generic call (`where T : IFoo`) calls the interface method on the struct without a box. The repository has only five structs,
all in generic containers, none boxed (read from the code, `out/analysis-boxing.md` §2).

### 2.5 Where the cost is not the box

Three costs sit next to unboxing and are bigger. Mixing them up is the usual mistake.

1. **The type test.** `value is IDictionary` on a boxed int is not free: an interface test on a primitive is slower than a test for an exact
   type. **Measured:** `ContractValue.Kind(int)` 37 ns, against 9.5 ns for a string, because the int falls through two interface tests and a
   chain of integral tests before it is classified. The same method with the exact scalar types tested first: 9.6 ns. The 27 ns difference
   is the two interface tests plus the integral chain; this article did not split it further.
2. **The conversion helper.** `Convert.ToDecimal(object)` dispatches through `IConvertible` on the box. **Measured:**
   `ContractValue.Equal(int, int)` 107 ns, against 14 ns for an `a is int x && b is int y` test. No byte is allocated in either: the whole
   gap is type tests and helper calls.
3. **The reflection lookup.** **Measured** for `ConsoleText.ToConsoleString` on a five-property type (2,009 ns, 1,304 B): the
   `GetCustomAttribute<ConsoleDisplayAttribute>(true)` lookup 374 ns and 120 B, `GetCustomAttributes(true)` on the properties 223 ns,
   `GetProperties` 83 ns and 80 B. The reads that actually box (`GetValue` on all five, 95 ns, 72 B) are about 5 % of the call.

## 3. What PowerShell does

### 3.1 Every value is an `object`

PowerShell holds each variable, argument and result as `object`. A value type is therefore boxed each time it is produced: `$i++` creates a
new 24 B box, a `foreach` over `1..$n` yields 24 B per element, and a function parameter typed `[int]` costs far more than that because of
binding (all **measured** in `out/analysis-boxing.md` §3). Booleans are shared cached boxes, so `$i -eq 3` allocates nothing extra.

### 3.2 The PSObject wrapper

`PSObject` carries PowerShell's extended members (notes, script properties, the `PSPath` that `Get-Content` and `Get-ChildItem` attach). It
appears when the extended type system has something to attach, when a value is cast with `[psobject]`, and for `[pscustomobject]` itself.
Rules worth holding:

- `$x -is [string]` is true for a wrapped string, because `-is` looks through the wrapper. A C# `value is string` is false for the same
  object. That difference is the reason C# code that accepts `object` from PowerShell must unwrap.
- `$x.psobject.BaseObject` is the explicit unwrap. `[psobject]::AsPSObject($x)` is the explicit wrap.
- **Measured:** wrapping a string costs 46 ns and 152 B (`PSObject.AsPSObject`). Unwrapping costs 10 ns for a wrapped value and 5 ns for a
  raw one (`ContractValue.Unwrap`), with no allocation either way.
- Which call shapes hand a wrapper to a C# `object` parameter is a PowerShell binder rule that this article did not trace to its source. The
  repository's own `ContractValue.Unwrap` exists because wrapped values do reach those parameters, so treat "does this call pass a wrapper"
  as something to test with `-is [psobject]` before relying on either answer.

### 3.3 Pipelines and enumeration

A cmdlet's output is wrapped per item when the item has extended members, and a `ForEach-Object` or `Where-Object` runs a script block per
item. **Measured:** `1..$n | ForEach-Object { }` costs about 1,480 B per item; `[pscustomobject]@{ A = $i }` about 1,165 B; a function call
with an `[int]` parameter about 7,900 B; `$a += $i` about 8,000 B averaged over 2,000 appends, and it grows with the array. A function that
returns a collection is enumerated by the caller unless the caller wraps it in `@()` or uses the comma operator, so a one-element result and
a zero-element result lose their array-ness (general PowerShell knowledge).

### 3.4 A crossing costs thousands of times a box

**Measured** (`out/bench-unboxing.ps1` section D, noise about plus or minus 2 µs per call, so read the order of magnitude only):

| Call from a pwsh loop                                               | Per call                   |
| ------------------------------------------------------------------- | -------------------------- |
| empty script block, the loop's own baseline                         | about 6 µs, 5.2 KB         |
| `ContractValue.Kind($x)` for a raw string, a wrapped string, an int | about 9.5 to 10 µs, 7.8 KB |
| `ContractValue.Equal($int, 42)`                                     | about 10 µs, 7.9 KB        |
| `ContractSchema.Validate` on a two-property schema and document     | about 19 µs, 12.5 KB       |

Inside C# the same `Kind` and `Equal` calls cost 10 to 107 ns. The PowerShell call around them costs about 4 µs and 2.5 KB more than the
baseline. So the unbox inside a crossing is at most about 3 % of the crossing. **The lever in PowerShell is the number of crossings, not the
number of unboxes.** Passing the whole bounded list to one C# method removes N crossings.

### 3.5 Typed collections from PowerShell

`[List[int]]` stores 4 B per element where `[ArrayList]` stores 32 B. **Measured:** from PowerShell `List[int].Add($i)` allocates more per
call (about 570 B) than `ArrayList.Add($i)` (about 340 B), because the binder converts the argument to `int`. Choose a typed list for a
large **retained** collection, never to save call cost.

## 4. How to find and measure it

1. **Read the IL.** `box`, `unbox.any` and `isinst` in ILSpy or `ildasm` show every box in a method, including the ones the compiler inserts
   for `string.Format` and `params`.
2. **Count bytes, not milliseconds.** `GC.GetAllocatedBytesForCurrentThread()` before and after, in a loop, after a warm-up of about 20,000
   calls so the JIT has finished tiering. This is what the repository's two bench scripts do, and it needs no importer.
3. **Compile the repository's own source.** `Add-Type -Path` on the real `types/*.cs` files plus a harness file measures the code that
   ships, with no copy to drift (`out/bench-unboxing.ps1` does this).
4. **Prototype before planning.** A prototype class in the harness next to the real class answers "is it worth it" before any edit.
5. **Allocation share check.** A stage that allocates 480 MB in 830 ms cannot be explained by 24 B boxes: 480 MB is 20 million of them. If
   the arithmetic does not reach the observed bytes, the cost is elsewhere (in this repository: parsing, per-file function calls).
6. **Outside this repository:** BenchmarkDotNet's `MemoryDiagnoser` and the Roslyn heap-allocation analyzers (the `HAA06xx` rules flag
   implicit boxing) are the standard tools. Neither is a dependency here (`ADR-PWSH-TYPES-HOSTGUARANTEEDASSEMBLIES` allows no packages in
   `types/`).

## 5. How to reduce it, in order of payoff

1. **Cross less.** In PowerShell, one C# call over a bounded list beats a loop of calls. Measured crossing cost is about 4 µs against 10 to
   100 ns of work inside.
2. **Test the exact type first.** Before `IDictionary` or `IList`, test `string`, `int`, `long`, `bool`. A sealed or primitive type test is
   a single compare; an interface test on a primitive is not.
3. **Cache reflection metadata per type.** `GetProperties`, `GetCustomAttribute`, `GetCustomAttributes(true)` and `GetProperty(name)` are
   the expensive part of reflection reads, not the `GetValue` box. A static table keyed by `Type` pays once per process.
4. **Keep numbers typed.** A typed record (`int`, `bool`, enum fields) holds no boxes. The raw dictionary that feeds it is read once and
   dropped. This repository already does this: `Get-Config` caches the typed record, so the unbox happens once per file.
5. **Use generic collections and typed parameters in C# hot loops.** `List<int>` not `ArrayList`; an `int` parameter not `object`.
6. **Leave error paths alone.** A `string.Format("{0}", count)` that runs only when something has failed is not a bounded fast context.
7. **Do not unwrap more than once.** One `Unwrap` at the entry of a method that accepts `object`, as `ContractSchema.Check` does, is enough.
   It costs 5 to 10 ns.

What not to do: replace a boxed numeric comparison with `==` on `object` (reference equality, wrong); add a fast path whose result differs
from the general path for any input (int against long and double must stay equal by value); cache anything that can change inside a process
(a type cannot, `ADR-AUTO-TYPES-CHANGEDAFTERLOAD`; a guard's verdict can).

## 6. This repository, measured

### 6.1 Where unwrapping and unboxing live (read from the code)

| Place                                                                                                                | What happens                                                                                                                                                                                                               | Hot?                                                                                    |
| -------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| `Catzc.Base.Contracts` `ContractValue`, `ContractSchema`, `ContractFragment`                                         | The only structural `PSObject` unwrap in first-party code. Values are `object` trees (YAML or JSON), tested with `is`, compared through `Kind()` strings                                                                   | Bounded: one contract asset per call, but `Equal` recurses and `MatchArray` is O(n x m) |
| `DictionaryRecord` (`Contains`, indexer, `Keys`, `ToHashtable`)                                                      | `PropertyInfo.GetProperty` or `GetProperties` on every call, then `GetValue`                                                                                                                                               | Bounded, called from PowerShell, 24 B per int or bool read                              |
| `ConsoleText.ToConsoleString`                                                                                        | `GetCustomAttribute(true)`, `GetProperties`, and `GetCustomAttributes(true)` per property on every call                                                                                                                    | Every console message about a record; a message loop multiplies it                      |
| Config types reading raw YAML dictionaries (`Flag`, `TimeoutsConfig`, `ConfigsConfig`)                               | `is bool`, `(int)` on boxed values                                                                                                                                                                                         | Once per file; `Get-Config` caches                                                      |
| `Hashtable` and `List<Hashtable>` in `TimeoutsConfig`, `TimeoutExemptionsConfig`, `EngineCaseTable`, `ConfigsConfig` | Non-generic storage of boxed values for PowerShell callers                                                                                                                                                                 | Built once per config load                                                              |
| 678 `string.Format` calls in 132 type files                                                                          | About 58 pass an int-like value; nearly all on error paths                                                                                                                                                                 | No                                                                                      |
| PowerShell: `.BaseObject`, `AsPSObject`, `ArrayList`                                                                 | None in first-party `.ps1` or `.psm1` (the `.PSObject.Properties` uses are vendored Pester, tests, and two first-party member reads in `Resolve-ConfigKeyPath` and `Install-UvStandalone`, which read members, not unwrap) | No                                                                                      |

Correction to the 2026-10-15 analysis: it says `Hashtable` appears in the types only to hand a result to PowerShell. It is also the storage
type of four config types above. The conclusion (once per load, cached) stands.

### 6.2 What the measurements say

| Measured (C#, ns/op, B/op)                              | Current            | Prototype                                                         |
| ------------------------------------------------------- | ------------------ | ----------------------------------------------------------------- |
| `ContractValue.Unwrap`, raw / wrapped                   | 5.0 / 10.1 ns, 0 B | -                                                                 |
| `Kind(int)`                                             | 37.3 ns            | 9.6 ns (exact scalar types first)                                 |
| `Kind(string)`                                          | 9.5 ns             | 8.3 ns                                                            |
| `Equal(int, int)`                                       | 107.0 ns           | 14.0 ns                                                           |
| `Equal(string, string)`                                 | 63.5 ns            | 17.4 ns                                                           |
| `Equal(long, int)`                                      | 107.2 ns           | no fast path (falls to the general path)                          |
| `widget.Contains("Count")`                              | 73.3 ns, 24 B      | 54.7 ns, 24 B (cached property table)                             |
| `widget.ToHashtable()`                                  | 588 ns, 609 B      | not prototyped                                                    |
| `widget.ToString()` (`ConsoleText`)                     | 2,009 ns, 1,304 B  | not prototyped; its reflection lookups add up to about 680 ns     |
| `ContractSchema.Validate`, 5 properties, 11 value nodes | 7,588 ns, 11,016 B | not changed: its allocation is LINQ and list building, not boxing |

The box inside `GetValue` stays in the prototype (24 B before and after). Removing it would need a generated typed accessor per property,
which this repository has no reason to build at these call rates.

### 6.3 What this means

- **Unboxing itself is not a cost anywhere in the repository.** It is 2.5 ns. The boxes behind it total tens of bytes per call.
- **Three places spend measurable time on the way to an unbox**, all in C#, all bounded: `ContractValue.Kind`/`Equal` (type-test order and
  helper calls), `DictionaryRecord` and `ConsoleText` (reflection lookups repeated per call).
- **The wall-clock cost in this repository is not here.** The 2026-10-15 stage measurements put 1.48 GB of allocation in the three build
  stages, about 62 million boxes' worth, of which boxing is under 1 %. Parsing each file three times and a function call per file are the
  causes (`out/analysis-boxing.md` §4 and §6). A plan that reduces unboxing alone will save microseconds. The plan in `out/plan-unboxing.md`
  says so and ranks its changes by measured payoff.

## 7. Limits

- Section 6.2's numbers are single runs on one machine after a warm-up. Differences under about 15 % are inside run-to-run noise, which the
  two runs of the same code in this session showed (for example `Equal(string, string)` 61.4 and 63.5 ns).
- The PowerShell-boundary figures (3.4) carry plus or minus 2 µs per call: the typed-property read measured faster than the empty-loop
  baseline in one run. They support an order of magnitude, nothing finer.
- The prototypes preserve the current result for the inputs tested by reading the code, not by running the contract test suites. The plan
  runs those suites.
- The PowerShell binder rule for when a wrapper reaches an `object` parameter was not traced (3.2).
- Retained memory (what caches hold alive) was not measured.
