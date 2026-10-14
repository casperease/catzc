// Claude Code PreToolUse hook: denies a foreground Bash call that does not run inside the time safeguard
// ([ADR-AUTO-FAILFAST#7](/docs/adr/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast7)).
//
// Every Bash call an agent (the main session or any subagent) makes must either run in the background or pass a
// `timeout` no larger than the safeguard's default — `default_seconds` in
// automation/Catzc.Base.Timeouts/configs/timeouts.yml, the same value Get-TimeoutSeconds resolves. A call that
// omits `timeout`, or asks for more, is denied with a reason that says how to re-issue it. Nothing else is decided
// here, so the permission rules in settings.json still apply to every call this hook lets through.
//
// Reads the hook payload (JSON) from stdin. A compiled program because it runs before every Bash call: it starts
// in about a third of the time a pwsh script does. Build-BashTimeoutHook publishes it to .claude/hooks/bin/, from
// where the repository root is three folders up.

using System;
using System.IO;
using System.Text.Json;
using System.Text.RegularExpressions;

namespace Catzc.Hooks;

public static class AssertBashTimeout
{
    private const string ConfigRelativePath = "automation/Catzc.Base.Timeouts/configs/timeouts.yml";

    public static int Main()
    {
        try
        {
            string repositoryRoot = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, "..", "..", ".."));
            string denial = Decide(Console.In.ReadToEnd(), Path.Combine(repositoryRoot, ConfigRelativePath));
            if (denial != null)
            {
                Console.Out.Write(denial);
            }
            return 0;
        }
        catch (Exception e)
        {
            // A non-blocking hook error: the call goes ahead and the person sees why the safeguard did not run.
            Console.Error.WriteLine("Bash time safeguard hook failed: " + e.Message);
            return 1;
        }
    }

    // The hook's verdict for one payload: null to let the call through, or the PreToolUse deny JSON.
    public static string Decide(string payload, string configPath)
    {
        using JsonDocument document = JsonDocument.Parse(payload);
        JsonElement toolInput = default;
        bool hasInput = document.RootElement.ValueKind == JsonValueKind.Object &&
            document.RootElement.TryGetProperty("tool_input", out toolInput) && toolInput.ValueKind == JsonValueKind.Object;

        JsonElement background;
        if (hasInput && toolInput.TryGetProperty("run_in_background", out background) && background.ValueKind == JsonValueKind.True)
        {
            return null;
        }

        Match match = Regex.Match(File.ReadAllText(configPath), @"(?m)^default_seconds:\s*(\d+)\s*(#.*)?$");
        if (!match.Success)
        {
            throw new InvalidDataException("no 'default_seconds: <n>' line in " + configPath);
        }
        long limitMs = long.Parse(match.Groups[1].Value) * 1000;

        string asked = "no timeout";
        JsonElement timeout;
        if (hasInput && toolInput.TryGetProperty("timeout", out timeout) && timeout.ValueKind == JsonValueKind.Number)
        {
            double timeoutMs = timeout.GetDouble();
            if (timeoutMs <= limitMs)
            {
                return null;
            }
            asked = "timeout " + timeoutMs + " ms";
        }

        string reason =
            "Bash time safeguard: this foreground call has " + asked + "; every foreground Bash call must pass timeout <= " +
            limitMs + " ms (default_seconds in " + ConfigRelativePath + "). Re-issue it with timeout: " + limitMs +
            ", or run longer work with run_in_background: true and wait for its completion notification.";
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
}
