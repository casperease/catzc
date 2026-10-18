# Configuration explanations

```text
How cats reads, validates, caches and addresses its configuration.

The config read path   every read goes through one reader and one session cache
```

These articles explain decisions from the [configuration ADR domain](../../adr/index.md#configuration): one reader, one cache per session,
and addresses that point into committed config. Each article narrates one diagram; the [explanation index](../index.md) says how to read
them.

## The config read path

Every config read goes through one reader and one session cache ([module-config-loading](../../adr/configuration/module-config-loading.md)).

| Lens           | Article                                                                                                             |
| -------------- | ------------------------------------------------------------------------------------------------------------------- |
| meta           | [Every config read goes through one reader and one session cache](one-reader-one-cache-per-session.md)              |
| architecture   | [Callers in any module read config through one module](callers-depend-on-one-config-module.md)                      |
| implementation | [Three session caches back the one config reader](three-caches-back-one-reader.md)                                  |
| operations     | [Ask for a config by name and get the cached object back](ask-by-name-get-the-cached-object.md)                     |
| governance     | [One quality gate guards the config read path, and it checks only the typed step](one-gate-guards-the-read-path.md) |
