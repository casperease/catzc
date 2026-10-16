/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Timeouts/types/BoundedCommand.cs
    kind: type
    language: csharp
    filetype: cs
    track: automation
    module: Catzc.Base.Timeouts
    moduletype: pwsh-folder-module
    bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-timeouts/types/BoundedCommand.cs.md
      test: automation/Catzc.Base.Timeouts/tests/types/BoundedCommand.Tests.ps1
    adrs:
      - ADR-AUTO-ENGINE#2
---
*/

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

    public static string Check(string command, string engine, int limitSeconds, out string requested)
    {
        double? seconds;
        string body;
        bool posix = IsPosix(engine);
        if (!TryParseBound(command, engine, out seconds, out body))
        {
            requested = posix ? "no timeout prefix" : "no Invoke-WithTimeout";
            return NoLimit;
        }
        if (seconds.HasValue && (seconds.Value <= 0 || seconds.Value > limitSeconds))
        {
            requested = (posix ? "timeout " : "-Seconds ") + seconds.Value.ToString(CultureInfo.InvariantCulture) + " s";
            return OverLimit;
        }
        if (!IsSingleCommand(posix ? body : command, engine))
        {
            requested = "compound command";
            return Compound;
        }
        requested = seconds.HasValue ? seconds.Value.ToString(CultureInfo.InvariantCulture) + " s" : "configured default";
        return Allow;
    }

    public static bool TryParseBound(string command, string engine, out double? seconds, out string body)
    {
        seconds = null;
        body = null;
        bool posix = IsPosix(engine);
        if (string.IsNullOrWhiteSpace(command)) { return false; }
        return posix ? TryParseBash(command, out seconds, out body) : TryParsePwsh(command, out seconds, out body);
    }

    public static bool IsSingleCommand(string text, string engine)
    {
        bool posix = IsPosix(engine);
        if (string.IsNullOrWhiteSpace(text)) { return false; }
        return posix ? IsSingleBash(text) : IsSinglePwsh(text);
    }

    private static bool IsPosix(string engine)
    {
        string normalized = engine == null ? "" : engine.Trim().ToLowerInvariant();
        return Catzc.Base.Engines.ExecutionEngines.Get(normalized).TimeSafeguard == Catzc.Base.Engines.ExecutionEngines.Bash.TimeSafeguard;
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
