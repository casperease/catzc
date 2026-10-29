# Configuration explanations

```text
How cats reads, validates, caches and addresses its configuration.

The config read path   every read goes through one reader and one session cache
```

These articles explain decisions from the [configuration DRS domain](../../drs/index.md#configuration): one reader, one cache per session,
and addresses that point into committed config. Each article narrates one diagram; the [explanation index](../index.md) says how to read
them.

## The config read path

Every config read goes through one reader and one session cache ([module-config-loading](../../drs/configuration/module-config-loading.md)).

| Lens           | Article                                                                                                                |
| -------------- | ---------------------------------------------------------------------------------------------------------------------- |
| meta           | [Every config read goes through one reader and one session cache](how-a-config-read-is-cached.md)                      |
| architecture   | [Callers in any module read config through one module](how-callers-in-any-module-read-config.md)                       |
| implementation | [Three session caches back the one config reader](which-caches-back-the-config-reader.md)                              |
| operations     | [Ask for a config by name and get the cached object back](how-a-config-is-fetched-by-name.md)                          |
| governance     | [One quality gate guards the config read path, and it checks only the typed step](what-guards-the-config-read-path.md) |
