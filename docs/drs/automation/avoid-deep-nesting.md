# ADR: Avoid deep nesting in statements and expressions

## Rules: ADR-AUTO-NONEST

### Rule ADR-AUTO-NONEST-ONEOPERATIONPERLINE

One operation per line — a pipeline, a method call, or an indexing operation per assignment. Chaining two is often fine; three or more
almost always needs splitting.

- [Easier debugging](#easier-debugging)
- [No performance cost](#no-performance-cost)

### Rule ADR-AUTO-NONEST-NAMEINTERMEDIATES

Name the intermediate result — the variable name documents what the value represents (a variable named `active` over a filter buried inside
a longer expression).

- [Easier debugging](#easier-debugging)

### Rule ADR-AUTO-NONEST-ASSERTBETWEENSTEPS

Assert between steps: once intermediate values have names, inject assertions that verify assumptions before the next step uses the value.

- [Room for assertions](#room-for-assertions)

### Rule ADR-AUTO-NONEST-FLATCONDITIONALS

Give conditionals the same treatment — do not bury logic inside a condition. Compute the value, optionally assert it, then test it.

- [Room for assertions](#room-for-assertions)

### Rule ADR-AUTO-NONEST-SIMPLEEXPRESSIONSEXEMPT

Simple expressions are exempt: a path join onto an anchor, a single property access, a straightforward cast, and other operations that
cannot fail in surprising ways do not need their own line.

- [When nesting is fine](#when-nesting-is-fine)

## Context

Every engine makes it easy to chain member access, method calls, indexing, pipelines, and subexpressions into a single line. The result
compiles and runs fine, but quickly becomes unreadable. The examples below are pseudo-code, written the same way whatever the engine:

```text
# What does this do? You have to parse it inside-out to find out.
name = lower(first(filter(parse(read(path)).items, item -> item.status == "active")).name)
```

```text
# Conditional with buried logic — the reader must mentally evaluate the entire
# expression before understanding what the if-statement is actually testing.
if count(filter(list_files(path, "*.script"), file -> not is_test(file))) > 5:
```

The same logic, split into named steps, reads top-to-bottom:

```text
config = parse(read(path))
active = filter(config.items, item -> item.status == "active")
name   = lower(first(active).name)
```

```text
scripts = filter(list_files(path, "*.script"), file -> not is_test(file))
if count(scripts) > 5:
```

This is not about line length or aesthetics. Deep nesting has concrete costs for debugging, assertability, and code review. The engine
spellings of the step assertions (rule 3) and of the exempt simple expressions (rule 5) are in the engine twin.

### No performance cost

`Why splitting has zero performance cost`

In every engine catzc runs on, a variable holds a reference to an object that already exists, not a copy of it. When a step's result is
named, no data is duplicated; the only cost is the binding itself, nanoseconds against the milliseconds the read, the parse or the filter
takes.

This is true for strings, lists, maps and records alike. Splitting a deeply nested expression into three named steps does not allocate three
times the memory or run three times slower. It runs the same operations in the same order and produces the same objects — the names are just
names for things that already exist.

### Easier debugging

`Why splitting makes debugging easier`

When a deeply nested expression fails, the error points at the entire line: "cannot index into a null list, at line 42". Which part is null?
The parsed result? Its items? The filter's output? The first element? You cannot tell without attaching a debugger or adding temporary
output — both slow and error-prone.

When each step is on its own line, the error points at the exact operation that failed: "cannot index into a null list, at line 44". Line 44
is `name = lower(first(active).name)`, so `active` is empty. The previous line produced it. The diagnosis is immediate.

### Room for assertions

`Why splitting enables assertions`

The [fail-fast-with-asserts](fail-fast-with-asserts.md) ADR establishes that roughly every fifth line should be an assertion. You cannot
assert intermediate values that do not exist as names:

```text
# No way to assert that the file parsed, that it has items,
# or that the filter found anything — it is all one expression.
name = lower(first(filter(parse(read(path)).items, item -> item.status == "active")).name)
```

Split into steps, you can inject assertions exactly where assumptions are made:

```text
config = parse(read(path))
assert has_property(config, "items")

name = lower(first(active).name)
assert not blank(name)
```

An assertion can also sit inside a pipeline, passing its input through when the check holds, so a step stays one line without losing its
check.

Each assertion documents a precondition and catches failures at the source. Without the intermediate names, these checks are impossible
without restructuring the code anyway.

### When nesting is fine

Simple, well-known expressions that read naturally do not need splitting: a path joined onto the repository root, a single property access
on a known object, a short pipeline with two obvious stages. They are self-documenting and cannot fail in surprising ways.

The rule of thumb: if you have to scan backwards or count parentheses to understand a line, split it.

## Decision

Prefer flat, step-by-step code over deeply nested expressions. Assign intermediate results to descriptively named variables and use those
variables on the next line.

## Consequences

- Lines are shorter and each does one thing — code reviews can evaluate one step at a time.
- Error messages point at the exact operation that failed, not at a 200-character compound expression.
- Intermediate names create natural injection points for assertions, supporting the fail-fast pattern.
- Variable names serve as documentation for what each intermediate value represents.
- No performance cost — variables are references, not copies.
- Slightly more lines of code, which is a worthwhile trade for readability, debuggability, and assertability.
