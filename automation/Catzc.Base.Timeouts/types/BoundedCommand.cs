// Whether a command line runs inside a time limit, in either execution engine's grammar — the check behind the Bash
// hook's background rule (BashSafeguard) and the per-engine fixture table
// (tests/assets/engine-cases/bounded-command.yml, loaded by Get-EngineCaseTable).
//
// A command is bounded when its limit wraps all of it:
//   - bash: a leading GNU `timeout [options] <duration>` around ONE command — a compound command (&&, ||, ;, |, a
//     background &, a newline) would leave everything after its first command unbounded. A backtick runs a command
//     substitution, so its content belongs to the one command.
//   - pwsh: ONE call to Invoke-WithTimeout, Assert-CompletesWithin or Test-CompletesWithin whose script block holds
//     the work; the block may hold any number of statements, because the whole block is bounded. Without -Seconds the
//     call takes its configured default, which is bounded too. & is the call operator (not a separator), a backtick
//     escapes the next character, and '' is a quote inside a single-quoted string.
// The verdict is one of: allow, no-limit, over-limit, compound.

using System;
using System.Globalization;
using System.Text.RegularExpressions;

namespace Catzc.Base.Timeouts;

public static class BoundedCommand
{
    public const string Allow = "allow";
    public const string NoLimit = "no-limit";
    public const string OverLimit = "over-limit";
    public const string Compound = "compound";

    private static readonly Regex BashDuration = new Regex(@"^(\d+(?:\.\d+)?)(s|m|h|d)?$", RegexOptions.CultureInvariant);
    private static readonly Regex PwshBoundCall = new Regex(
        @"^\s*(Invoke-WithTimeout|Assert-CompletesWithin|Test-CompletesWithin)\b", RegexOptions.CultureInvariant | RegexOptions.IgnoreCase);
    private static readonly Regex PwshSeconds = new Regex(
        @"(?:^|\s)-Seconds(?::|\s+)(\d+)\b", RegexOptions.CultureInvariant | RegexOptions.IgnoreCase);
    private static readonly Regex PwshSecondsName = new Regex(
        @"(?:^|\s)-Seconds\b", RegexOptions.CultureInvariant | RegexOptions.IgnoreCase);

    // The verdict for a command in an engine (pwsh | bash) against a limit in seconds. requested describes what the
    // command asked for, for a log line.
    public static string Check(string command, string engine, int limitSeconds, out string requested)
    {
        double? seconds;
        string body;
        string kind = Engine(engine);
        if (!TryParseBound(command, kind, out seconds, out body))
        {
            requested = kind == "bash" ? "no timeout prefix" : "no Invoke-WithTimeout";
            return NoLimit;
        }
        if (seconds.HasValue && (seconds.Value <= 0 || seconds.Value > limitSeconds))
        {
            requested = (kind == "bash" ? "timeout " : "-Seconds ") + seconds.Value.ToString(CultureInfo.InvariantCulture) + " s";
            return OverLimit;
        }
        // bash: the one command after the prefix; pwsh: the call itself at the top level (the block's own statements
        // are inside the limit, so they never count).
        if (!IsSingleCommand(kind == "bash" ? body : command, kind))
        {
            requested = "compound command";
            return Compound;
        }
        requested = seconds.HasValue ? seconds.Value.ToString(CultureInfo.InvariantCulture) + " s" : "configured default";
        return Allow;
    }

    // Parses the engine's time-limit wrapper. bash: `timeout [options] <duration> <rest>`, with seconds the duration
    // and body the rest. pwsh: `Invoke-WithTimeout [params] { <body> } [params]`, with seconds the -Seconds value or
    // null for the configured default, and body the block's content. False when the command is not wrapped.
    public static bool TryParseBound(string command, string engine, out double? seconds, out string body)
    {
        seconds = null;
        body = null;
        if (string.IsNullOrWhiteSpace(command)) { return false; }
        return Engine(engine) == "bash" ? TryParseBash(command, out seconds, out body) : TryParsePwsh(command, out seconds, out body);
    }

    // True when the text is one command in the engine's grammar: no statement separator outside quotes and nested
    // expressions. bash separators: &&, ||, ;, |, a background &, newline (the & of 2>&1 or &> is a redirection).
    // pwsh separators: &&, ||, ;, |, newline (a single & is the call operator).
    public static bool IsSingleCommand(string text, string engine)
    {
        if (string.IsNullOrWhiteSpace(text)) { return false; }
        return Engine(engine) == "bash" ? IsSingleBash(text) : IsSinglePwsh(text);
    }

    private static string Engine(string engine)
    {
        // The execution engines, declared once ([ADR-AUTO-ENGINE#1](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine1)); Get
        // throws, naming them, for any other name.
        string normalized = engine == null ? "" : engine.Trim().ToLowerInvariant();
        return Catzc.Base.Engines.ExecutionEngines.Get(normalized).Name;
    }

    private static bool TryParseBash(string command, out double? seconds, out string rest)
    {
        seconds = null;
        rest = null;
        string text = command.TrimStart();
        int position = 0;
        if (NextWord(text, ref position) != "timeout") { return false; }

        while (true)
        {
            string word = NextWord(text, ref position);
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

            Match match = BashDuration.Match(word);
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

    private static bool TryParsePwsh(string command, out double? seconds, out string body)
    {
        seconds = null;
        body = null;
        Match call = PwshBoundCall.Match(command);
        if (!call.Success) { return false; }

        string afterName = command.Substring(call.Index + call.Length);
        int open = IndexOfTopLevelBrace(afterName);
        if (open < 0) { return false; }
        int close = MatchingBrace(afterName, open);
        if (close < 0) { return false; }

        string parameters = afterName.Substring(0, open) + " " + afterName.Substring(close + 1);
        body = afterName.Substring(open + 1, close - open - 1).Trim();
        if (body.Length == 0) { return false; }

        Match limit = PwshSeconds.Match(parameters);
        if (limit.Success)
        {
            seconds = double.Parse(limit.Groups[1].Value, CultureInfo.InvariantCulture);
        }
        else if (PwshSecondsName.IsMatch(parameters))
        {
            // -Seconds with no whole number after it: the call would not bind, so it is not a limit.
            return false;
        }
        return true;
    }

    // The first { outside quotes, or -1.
    private static int IndexOfTopLevelBrace(string text)
    {
        bool inSingle = false;
        bool inDouble = false;
        for (int i = 0; i < text.Length; i++)
        {
            char c = text[i];
            if (inSingle) { if (c == '\'') { inSingle = false; } continue; }
            if (c == '`') { i++; continue; }
            if (inDouble) { if (c == '"') { inDouble = false; } continue; }
            if (c == '\'') { inSingle = true; continue; }
            if (c == '"') { inDouble = true; continue; }
            if (c == '{') { return i; }
        }
        return -1;
    }

    // The } that closes the { at open, quote-aware, or -1.
    private static int MatchingBrace(string text, int open)
    {
        int depth = 0;
        bool inSingle = false;
        bool inDouble = false;
        for (int i = open; i < text.Length; i++)
        {
            char c = text[i];
            if (inSingle) { if (c == '\'') { inSingle = false; } continue; }
            if (c == '`') { i++; continue; }
            if (inDouble) { if (c == '"') { inDouble = false; } continue; }
            if (c == '\'') { inSingle = true; continue; }
            if (c == '"') { inDouble = true; continue; }
            if (c == '{') { depth++; }
            else if (c == '}') { depth--; if (depth == 0) { return i; } }
        }
        return -1;
    }

    private static bool IsSingleBash(string text)
    {
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

    private static bool IsSinglePwsh(string text)
    {
        bool inSingle = false;
        bool inDouble = false;
        int depth = 0;
        for (int i = 0; i < text.Length; i++)
        {
            char c = text[i];
            if (inSingle)
            {
                // '' inside a single-quoted string is a literal quote: it closes and reopens, so the toggle holds.
                if (c == '\'') { inSingle = false; }
                continue;
            }
            if (c == '`') { i++; continue; }
            if (inDouble)
            {
                if (c == '"') { inDouble = false; }
                continue;
            }
            if (c == '\'') { inSingle = true; continue; }
            if (c == '"') { inDouble = true; continue; }
            if (c == '(' || c == '{' || c == '[') { depth++; continue; }
            if (c == ')' || c == '}' || c == ']') { depth--; continue; }
            if (depth > 0) { continue; }
            if (c == ';' || c == '|' || c == '\n' || c == '\r') { return false; }
            if (c == '&' && i + 1 < text.Length && text[i + 1] == '&') { return false; }
        }
        return !inSingle && !inDouble && depth == 0;
    }

    private static string NextWord(string text, ref int position)
    {
        while (position < text.Length && char.IsWhiteSpace(text[position])) { position++; }
        if (position >= text.Length) { return null; }
        int start = position;
        while (position < text.Length && !char.IsWhiteSpace(text[position])) { position++; }
        return text.Substring(start, position - start);
    }
}
