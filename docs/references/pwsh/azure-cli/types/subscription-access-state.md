# pwsh/Azure.Cli/types/SubscriptionAccessState.cs

The typed record of whether the current az CLI login can reach a given subscription. It is established by a real, read-only ARM probe, not
by inspecting local session state, and is a point-in-time access check.

## Properties

- **`logged_in`** — true when there is any active az login at all. On the failure path it separates "not logged in" from "logged in but no
  access to this subscription".
