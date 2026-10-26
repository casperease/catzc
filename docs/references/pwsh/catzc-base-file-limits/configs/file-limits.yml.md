# pwsh/Base.FileLimits/configs/file-limits.yml

The length and width limits of every tracked file, by class, language, extension and file name, typed by `FileLimitsConfig`.

## Bounds

Every key is optional: an omitted key takes the default declared once on `FileLimitsConfig`. A language value wins over its class default,
and no value may leave the bounds; a value outside them fails the config load.
