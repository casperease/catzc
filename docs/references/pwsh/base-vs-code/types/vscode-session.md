# pwsh/Base.VSCode/types/VscodeSession.cs

The result type of `Get-VsCodeSession`: what one pwsh session inside VS Code can say about its own binding. It holds the types instance the
session runs on, the hash of the code files, the committed builds with their holders, the variables the extensions contributed, and the
editor's log session.
