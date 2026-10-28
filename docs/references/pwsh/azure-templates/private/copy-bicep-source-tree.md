# pwsh/Azure.Templates/private/Copy-BicepSourceTree.ps1

The private function that copies a template's `main.bicep` and every file it reaches into a build's output folder.

## help

### synopsis

Copies main.bicep and every file it reaches into the output folder's bicep/ folder and returns the copied main.bicep.

### description

Build-Bicep calls this so a built template is self-contained: no path in a built `.bicep` or `.bicepparam` file leaves the output folder.
Starting at main.bicep, it follows every local path a Bicep file names (a `module`, an import's `from`, a `using` or `extends`, and a
`load*` function's file argument), skipping a registry or template-spec reference such as `br/public:`. The reached files are copied under
`<OutputFolder>/bicep/`, relative to the deepest folder that holds them all, so each relative path stays as written and still resolves.
Every `bicepconfig.json` between a reached file and that folder is copied too, since the linter reads its rule levels from the nearest one.
A reached path that does not exist throws, naming the file that references it.

### parameter `Main`

The template's main.bicep in the source tree.

### parameter `OutputFolder`

The build's output folder; the copy goes under its `bicep/` folder.
