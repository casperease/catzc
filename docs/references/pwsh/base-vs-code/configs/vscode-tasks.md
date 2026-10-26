# pwsh/Base.VSCode/configs/vscode-tasks.yml

The VS Code task registry: the one authored file that `.vscode/tasks.json` is rendered from, rendered by `New-VsCodeTasks`.

## The git topic flow

The tasks follow the git topic flow ([FDR-GIT](../../../../drs/flow/git-topic-flow.md)), each step at the user's hand: Sync rebases the
topic onto the sync point. Bind keys to these tasks in your user keybindings.
