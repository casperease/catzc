/*
---
catzc:
  immutable:
    with_body_sha: bec5774f95e5
  edges:
    test: pwsh/Catzc.Base.Timeouts/tests/types/BashSafeguard.Tests.ps1
    docs: "[BashSafeguard.cs.md](../../../docs/references/pwsh/catzc-base-timeouts/types/BashSafeguard.cs.md)"
    cites:
      - ADR-AUTO-FAILFAST-BOUNDEVERYWAIT
      - ADR-AUTO-LAYERS
---
*/

using System;
using System.Globalization;
using System.IO;
using System.Text.Json;

namespace Catzc.Base.Timeouts;

public static class BashSafeguard
{
    public const string ConfigModulePath = "Catzc.Base.Timeouts/configs/timeouts.yml";

    public static string FindConfig(string repositoryRoot)
    {
        if (string.IsNullOrEmpty(repositoryRoot)) { throw new ArgumentNullException("repositoryRoot"); }
        string found = null;
        foreach (string folder in Directory.GetDirectories(repositoryRoot))
        {
            string candidate = Path.Combine(folder, ConfigModulePath);
            if (!File.Exists(candidate)) { continue; }
            if (found != null)
            {
                throw new InvalidOperationException("More than one top-level folder of " + repositoryRoot + " holds " + ConfigModulePath + ": " + found + ", " + candidate + ".");
            }
            found = candidate;
        }
        if (found == null)
        {
            throw new FileNotFoundException("No top-level folder of " + repositoryRoot + " holds " + ConfigModulePath + ".");
        }
        return found;
    }

    public static string EnvironmentOf(string tfBuild, string githubActions)
    {
        return string.IsNullOrEmpty(tfBuild) && string.IsNullOrEmpty(githubActions) ? "Devbox" : "Pipeline";
    }

    public static string Decide(string payload, TimeoutsConfig config, string environment, out string logLine)
    {
        if (config == null) { throw new ArgumentNullException("config"); }
        logLine = null;

        using JsonDocument document = JsonDocument.Parse(payload);
        JsonElement root = document.RootElement;
        JsonElement input = default;
        bool hasInput = root.ValueKind == JsonValueKind.Object && root.TryGetProperty("tool_input", out input) &&
            input.ValueKind == JsonValueKind.Object;

        string command = hasInput ? StringOf(input, "command") : null;
        string agentId = root.ValueKind == JsonValueKind.Object ? StringOf(root, "agent_id") : null;
        string agentType = root.ValueKind == JsonValueKind.Object ? StringOf(root, "agent_type") : null;
        string actor = environment == "Pipeline" ? "pipeline" :
            !string.IsNullOrEmpty(agentId) ? "subagent:" + (string.IsNullOrEmpty(agentType) ? agentId : agentType) : "main";

        JsonElement flag;
        bool background = hasInput && input.TryGetProperty("run_in_background", out flag) && flag.ValueKind == JsonValueKind.True;

        string problem;
        string fix;
        string requested;
        int limitSeconds;
        if (background)
        {
            limitSeconds = config.SecondsFor(environment, "bash", true);
            switch (BoundedCommand.Check(command, "bash", limitSeconds, out requested))
            {
                case BoundedCommand.Allow:
                    return null;
                case BoundedCommand.NoLimit:
                    problem = "this background call has no `timeout <duration>` prefix (the Bash tool ignores `timeout` for background calls)";
                    break;
                case BoundedCommand.OverLimit:
                    problem = "this background call has " + requested + "; the background limit is " + limitSeconds + " s";
                    break;
                default:
                    problem = "this background call wraps a compound command, so only its first command would be bounded";
                    break;
            }
            fix = "Re-issue it as `timeout " + limitSeconds + " <one command>` (exit 124 means it was stopped), and put " +
                "multi-step work in a script under out/.";
        }
        else
        {
            limitSeconds = config.SecondsFor(environment, "bash", false);
            long limitMs = limitSeconds * 1000L;
            JsonElement timeout;
            if (hasInput && input.TryGetProperty("timeout", out timeout) && timeout.ValueKind == JsonValueKind.Number)
            {
                double timeoutMs = timeout.GetDouble();
                if (timeoutMs > 0 && timeoutMs <= limitMs)
                {
                    return null;
                }
                requested = "timeout " + timeoutMs.ToString(CultureInfo.InvariantCulture) + " ms";
            }
            else
            {
                requested = "no timeout";
            }
            problem = "this foreground call has " + requested + "; every foreground Bash call must pass timeout <= " + limitMs + " ms";
            fix = "Re-issue it with timeout: " + limitMs + ", or run longer work with run_in_background: true behind `timeout " +
                config.SecondsFor(environment, "bash", true) + " <one command>` and wait for its completion notification.";
        }

        string escalation = actor == "pipeline"
            ? "In a pipeline nobody tunes it live: fix the call, or its limit in " + ConfigModulePath + "."
            : actor == "main"
                ? "If the work legitimately needs longer, raise it with the user as a blocker to tune in " + ConfigModulePath + "; never work around the safeguard."
                : "You are a subagent: report the blocker to your coordinator rather than retrying with a larger limit.";

        string snippet = (command ?? "").Replace('\t', ' ').Replace('\r', ' ').Replace('\n', ' ');
        if (snippet.Length > 120) { snippet = snippet.Substring(0, 120); }
        logLine = string.Join("\t", DateTime.UtcNow.ToString("o", CultureInfo.InvariantCulture), environment, actor,
            background ? "background" : "foreground", requested, limitSeconds + " s", snippet);

        return "Bash time safeguard (" + environment + ", " + (background ? "background" : "foreground") + "): " + problem +
            " (limits in " + ConfigModulePath + "). " + fix + " " + escalation;
    }

    // The PreToolUse output that denies the call with a reason.
    public static string DenyOutput(string reason)
    {
        return JsonSerializer.Serialize(new
        {
            hookSpecificOutput = new
            {
                hookEventName = "PreToolUse",
                permissionDecision = "deny",
                permissionDecisionReason = reason
            }
        });
    }

    private static string StringOf(JsonElement element, string name)
    {
        JsonElement value;
        return element.TryGetProperty(name, out value) && value.ValueKind == JsonValueKind.String ? value.GetString() : null;
    }
}
