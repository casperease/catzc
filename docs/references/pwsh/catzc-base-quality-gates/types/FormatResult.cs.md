# pwsh/Base.QualityGates/types/FormatResult.cs

The outcome of formatting one file language (`Format-Code -PassThru`): the language, the engine `languages.yml` names for it, every file the
engine checked, and the files it changed, or, under `-DryRun`, would change.

Paths are absolute, since `Format-Code -Path` also formats files outside the repository, such as a built module manifest. `Test-Formatting`
turns each changed file into one issue naming its repository-relative path.
