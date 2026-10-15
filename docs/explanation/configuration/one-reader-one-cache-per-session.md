---
catzc:
  derived:
    path: docs/explanation/configuration/one-reader-one-cache-per-session.md
    kind: explanation
    body_sha: c2da6a7a9882
    adrs:
      - ADR-CONF-LOADING#1
      - ADR-CONF-LOADING#3
---

# Every config read goes through one reader and one session cache

```text
Every config read goes through one reader and one cache for the session.

1  one reader            the single way in, by a config's name or by an address into it
2  session cache         looked up first; a config read before is already there
3  same object           what every read returns, shared by every later reader
4  config file           opened on a miss, and only then
5  parse and type once   the file becomes its typed object once per session

Supports ADR-CONF-LOADING#1 and #3 (meta lens).
```

Config reading in cats has exactly one reader and one cache for the whole session. Cats keeps its settings in config files, and any function
in any module may need one of them, so instead of letting each function open the file it wants, every read goes the same way. The first read
of a config parses and types the file; every later read gets the same object back from the cache, and only a re-import clears it.

![Every config read goes through one reader and one session cache](../../.assets/explanation/adr-conf-loading--one-reader-one-cache-per-session--meta.drawio.png)

The diagram is described element by element in
[its asset description](../../.assets/explanation/adr-conf-loading--one-reader-one-cache-per-session--meta.drawio.md).

## Walkthrough

1. **One reader.** Every config read goes through one reader, whether it asks for a whole config by name or for one node by its address. The
   reader finds the file from the config's name alone; the caller never names the owning module.
2. **Session cache.** The reader looks in the session cache first. A config read before in this session is already there, and the read goes
   straight on to the result.
3. **Same object.** A read returns the same object on every call. It is a view to read, never to change, because every later reader shares
   it.
4. **Config file.** On a miss, and only then, the reader opens the config file.
5. **Parse and type once.** The file is parsed and turned into its typed object once per session, and that object goes into the cache. A
   malformed file never yields a value: the read throws instead. A wrong name or a wrong address throws too, never an empty value.

## Why it holds

- Every config read goes through the one reader; no function re-reads a config file or keeps its own config cache (ADR-CONF-LOADING#1).
- The parsed config is cached by its file path, and only a re-import invalidates it (ADR-CONF-LOADING#3).

## See also

- [Module config loading](../../adr/configuration/module-config-loading.md) — the decision this article explains.
- The other lenses on the same read path: [architecture](callers-depend-on-one-config-module.md),
  [implementation](three-caches-back-one-reader.md), [operations](ask-by-name-get-the-cached-object.md) and
  [governance](one-gate-guards-the-read-path.md).
- [The configuration explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
