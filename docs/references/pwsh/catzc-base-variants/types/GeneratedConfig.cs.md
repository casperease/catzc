# pwsh/Base.Variants/types/GeneratedConfig.cs

One module's declaration of what its generators write: each target a repository path or glob, with the generator that writes it. Every
generating module keeps its own `configs/generated.yml`, and `Get-GeneratedTarget` reads every owner's file alongside `rootconfig.yml`.
