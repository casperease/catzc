// The Bash time safeguard's verdict on one Claude Code Bash call
// ([ADR-AUTO-FAILFAST#7](/docs/adr/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast7)). The PreToolUse hook
// (.claude/hooks/Assert-BashTimeout/) compiles this same file, so the hook's decision and its L0 tests in
// Catzc.Base.Timeouts are one implementation.
//
// Every Bash call runs inside a limit from TimeoutsConfig for the run environment (devbox | pipeline):
//   - a foreground call passes `timeout` (ms) no larger than limits.<env>.bash.foreground;
//   - a background call — whose `timeout` the Bash tool ignores — starts with a coreutils `timeout <duration>`
//     no longer than limits.<env>.bash.background, around a single command. A compound command (&&, ||, ;, |, &,
//     newline) would leave the commands after the first unbounded, so it is denied: put longer work in a script.
// A call that breaks this is denied. The hook never rewrites a command: a hook "allow" skips the permission prompt
// and a rewritten command can slip past deny rules, so denial is the only verdict that leaves every other
// safeguard in place. What the context changes is the reason: the main session raises the blocker with the user,
// a subagent (payload `agent_id`) reports it to its coordinator, a pipeline fixes the call or the limit.

using System;
using System.Globalization;
using System.Text.Json;
using System.Text.RegularExpressions;

namespace Catzc.Base.Timeouts;

public static class BashSafeguard
{
    public const string ConfigRelativePath = "automation/Catzc.Base.Timeouts/configs/timeouts.yml";

    private static readonly Regex Duration = new Regex(@"^(\d+(?:\.\d+)?)([smhd]?)$", RegexOptions.CultureInvariant);

    // The run environment, by the same test as Test-IsRunningInPipeline: either variable set to any non-empty
    // value means a pipeline.
    public static string EnvironmentOf(string tfBuild, string githubActions)
    {
        return string.IsNullOrEmpty(tfBuild) && string.IsNullOrEmpty(githubActions) ? "Devbox" : "Pipeline";
    }

    // The verdict for one hook payload: null to let the call through, or the reason to deny it. logLine is a
    // tab-separated record of a denial (null when allowed) — the tuning list of blockers.
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
            double? seconds;
            string rest;
            if (!TryParseTimeoutPrefix(command, out seconds, out rest))
            {
                requested = "no timeout prefix";
                problem = "this background call has no `timeout <duration>` prefix (the Bash tool ignores `timeout` for background calls)";
            }
            else if (seconds.Value <= 0 || seconds.Value > limitSeconds)
            {
                requested = "timeout " + seconds.Value.ToString(CultureInfo.InvariantCulture) + " s";
                problem = "this background call has " + requested + "; the background limit is " + limitSeconds + " s";
            }
            else if (!IsSingleCommand(rest))
            {
                requested = "compound command";
                problem = "this background call wraps a compound command, so only its first command would be bounded";
            }
            else
            {
                return null;
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
            ? "In a pipeline nobody tunes it live: fix the call, or its limit in " + ConfigRelativePath + "."
            : actor == "main"
                ? "If the work legitimately needs longer, raise it with the user as a blocker to tune in " + ConfigRelativePath + "; never work around the safeguard."
                : "You are a subagent: report the blocker to your coordinator rather than retrying with a larger limit.";

        string snippet = (command ?? "").Replace('\t', ' ').Replace('\r', ' ').Replace('\n', ' ');
        if (snippet.Length > 120) { snippet = snippet.Substring(0, 120); }
        logLine = string.Join("\t", DateTime.UtcNow.ToString("o", CultureInfo.InvariantCulture), environment, actor,
            background ? "background" : "foreground", requested, limitSeconds + " s", snippet);

        return "Bash time safeguard (" + environment + ", " + (background ? "background" : "foreground") + "): " + problem +
            " (limits in " + ConfigRelativePath + "). " + fix + " " + escalation;
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

    // Parses a leading coreutils `timeout [options] <duration> <rest>`: options -k/--kill-after, -s/--signal,
    // --preserve-status, --foreground, -v/--verbose; a duration in seconds with an optional s|m|h|d suffix.
    public static bool TryParseTimeoutPrefix(string command, out double? seconds, out string rest)
    {
        seconds = null;
        rest = null;
        if (string.IsNullOrWhiteSpace(command)) { return false; }

        string text = command.TrimStart();
        int position = 0;
        string word = NextWord(text, ref position);
        if (word != "timeout") { return false; }

        while (true)
        {
            int before = position;
            word = NextWord(text, ref position);
            if (word == null) { return false; }
            if (word == "-k" || word == "--kill-after" || word == "-s" || word == "--signal")
            {
                if (NextWord(text, ref position) == null) { return false; }
                continue;
            }
            if (word.StartsWith("--kill-after=", StringComparison.Ordinal) || word.StartsWith("--signal=", StringComparison.Ordinal) ||
                word == "--preserve-status" || word == "--foreground" || word == "-v" || word == "--verbose")
            {
                continue;
            }

            Match match = Duration.Match(word);
            if (!match.Success) { return false; }
            double value = double.Parse(match.Groups[1].Value, CultureInfo.InvariantCulture);
            switch (match.Groups[2].Value)
            {
                case "m": value *= 60; break;
                case "h": value *= 3600; break;
                case "d": value *= 86400; break;
            }
            seconds = value;
            rest = text.Substring(position).Trim();
            return rest.Length > 0;
        }
    }

    // True when the text is one command: no command separator (&&, ||, ;, |, &, newline) outside quotes, `$(...)`
    // and backticks. The `&` of a redirection (2>&1, &>) is not a separator.
    public static bool IsSingleCommand(string text)
    {
        if (string.IsNullOrWhiteSpace(text)) { return false; }

        bool inSingle = false;
        bool inDouble = false;
        bool inBacktick = false;
        int substitution = 0;
        for (int i = 0; i < text.Length; i++)
        {
            char c = text[i];
            if (inSingle)
            {
                if (c == '\'') { inSingle = false; }
                continue;
            }
            if (c == '\\') { i++; continue; }
            if (c == '`') { inBacktick = !inBacktick; continue; }
            if (inBacktick) { continue; }
            if (c == '$' && i + 1 < text.Length && text[i + 1] == '(') { substitution++; i++; continue; }
            if (substitution > 0)
            {
                if (c == '(') { substitution++; }
                else if (c == ')') { substitution--; }
                continue;
            }
            if (c == '"') { inDouble = !inDouble; continue; }
            if (inDouble) { continue; }
            if (c == '\'') { inSingle = true; continue; }
            if (c == ';' || c == '|' || c == '\n' || c == '\r') { return false; }
            if (c == '&')
            {
                bool redirection = (i > 0 && text[i - 1] == '>') || (i + 1 < text.Length && text[i + 1] == '>');
                if (!redirection) { return false; }
            }
        }
        return !inSingle && !inDouble && !inBacktick && substitution == 0;
    }

    private static string NextWord(string text, ref int position)
    {
        while (position < text.Length && char.IsWhiteSpace(text[position])) { position++; }
        if (position >= text.Length) { return null; }
        int start = position;
        while (position < text.Length && !char.IsWhiteSpace(text[position])) { position++; }
        return text.Substring(start, position - start);
    }

    private static string StringOf(JsonElement element, string name)
    {
        JsonElement value;
        return element.TryGetProperty(name, out value) && value.ValueKind == JsonValueKind.String ? value.GetString() : null;
    }
}
