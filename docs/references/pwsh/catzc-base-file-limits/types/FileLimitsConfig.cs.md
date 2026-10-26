# pwsh/Base.FileLimits/types/FileLimitsConfig.cs

The typed record for `file-limits.yml`: it holds the length and width limits by class and language and resolves them for a file.

## Resolving a file

`ResolveFile` applies an override before the language lookup, an exact file name first and then the extension. An override takes its class's
defaults, never the language's own values. A file that no override and no language declares fails, so nothing tracked escapes unlimited.
