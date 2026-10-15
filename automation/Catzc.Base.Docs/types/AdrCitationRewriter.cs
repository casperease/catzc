/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/types/AdrCitationRewriter.cs
    kind: type
    module: Catzc.Base.Docs
    adrs:
      - ADR-REPO-LINK#2
---
*/

// The rule map decides before the code map, and matching also runs inside fenced blocks, so the result depends only on text and maps.
// [comment:1](/docs/references/automation/catzc-base-docs/types/AdrCitationRewriter.cs.md#comment1)

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Text;
using System.Text.RegularExpressions;

namespace Catzc.Base.Docs;

public sealed class AdrCitationRewriter
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    const string AdrRoot = "docs/adr/";
    const string Segment = @"[\w<>*-]+(?:\.[\w<>*-]+)*";
    const string AnchorPattern = @"rule-adr(?:-[a-z]+)+[0-9]+(?![0-9])";
    const string Separator = @"(?:[ \t]*,[ \t\r\n]*(?:(?:and|or)[ \t\r\n]+)?|[ \t\r\n]+(?:and|or|to)[ \t\r\n]+|[ \t]*/[ \t]*|[ \t]*–[ \t]*)";

    static readonly Regex InlineDestination = new Regex(@"\]\((?<dest><[^>\r\n]*>|[^)\s]+)", RegexOptions.Compiled);
    static readonly Regex ReferenceDestination = new Regex(@"^ {0,3}\[[^\]\r\n]+\]:[ \t]*(?<dest><[^>\r\n]*>|\S+)", RegexOptions.Compiled | RegexOptions.Multiline);
    static readonly Regex Scheme = new Regex(@"^[a-zA-Z][a-zA-Z0-9+.\-]*:", RegexOptions.Compiled);
    static readonly Regex RuleAnchor = new Regex(@"^rule-(?<code>adr(?:-[a-z]+)+)(?<rule>[0-9]+)$", RegexOptions.Compiled);
    static readonly Regex RuleId = new Regex(@"^(?<code>ADR(?:-[A-Z]+)+):(?<rule>[0-9]+)$", RegexOptions.Compiled);
    static readonly Regex Code = new Regex(@"^ADR(?:-[A-Z]+)+$", RegexOptions.Compiled);
    static readonly Regex ContinuationItem = new Regex("(?<sep>" + Separator + ")#(?<rule>[0-9]+)", RegexOptions.Compiled);
    static readonly string[] CodeMapColumns = { "old_code", "new_code", "old_path", "new_path", "kind" };
    static readonly string[] RuleMapColumns = { "old_rule", "new_rule", "kind" };
    static readonly HashSet<string> CodeMapKinds = new HashSet<string>(StringComparer.Ordinal) { "move", "path", "new", "folder" };
    static readonly HashSet<string> RuleMapKinds = new HashSet<string>(StringComparer.Ordinal) { "move", "collapse" };

    readonly Dictionary<string, string> codeMap = new Dictionary<string, string>(StringComparer.Ordinal);
    readonly Dictionary<string, (string Code, int Rule)> ruleMap = new Dictionary<string, (string, int)>(StringComparer.Ordinal);
    readonly Dictionary<string, string> pathMap = new Dictionary<string, string>(StringComparer.Ordinal);
    readonly List<(string Old, string New)> folderMap = new List<(string, string)>();
    readonly Dictionary<string, string> newPathByCode = new Dictionary<string, string>(StringComparer.Ordinal);
    readonly Dictionary<string, string> oldPathByCode = new Dictionary<string, string>(StringComparer.Ordinal);
    readonly AdrCitationMap citations;
    readonly Regex reference;

    // citations may be null only when the code map names every path; otherwise it supplies a moved rule's new path.
    // [comment:2](/docs/references/automation/catzc-base-docs/types/AdrCitationRewriter.cs.md#comment2)
    public AdrCitationRewriter(IEnumerable codeRows, IEnumerable ruleRows, AdrCitationMap citations)
    {
        if (codeRows == null) { throw new ArgumentNullException(nameof(codeRows)); }
        if (ruleRows == null) { throw new ArgumentNullException(nameof(ruleRows)); }
        this.citations = citations;

        foreach (object row in codeRows) { AddCodeRow(Cells(row, CodeMapColumns, "code map")); }
        foreach (object row in ruleRows) { AddRuleRow(Cells(row, RuleMapColumns, "rule map")); }
        folderMap.Sort((left, right) => right.Old.Length.CompareTo(left.Old.Length));

        var literals = new List<string>(pathMap.Keys);
        foreach ((string old, string _) in folderMap) { literals.Add(old); }
        literals.Sort((left, right) => right.Length.CompareTo(left.Length));
        string path = Segment + "(?:/" + Segment + ")*/?";
        var alternatives = new List<string>
        {
            @"(?<![\w./-])(?<repo>/?docs/adr/" + path + ")(?:#(?<repoAnchor>" + AnchorPattern + "))?",
            @"(?<![\w./-])(?<relative>(?:\.\.?/)+" + path + ")(?:#(?<relativeAnchor>" + AnchorPattern + "))?",
        };
        if (literals.Count > 0)
        {
            alternatives.Add(@"(?<![\w./-])(?<bare>(?:" + string.Join("|", literals.ConvertAll(Regex.Escape)) + ")(?:/" + Segment + @")*/?)(?![\w-])(?:#(?<bareAnchor>" + AnchorPattern + "))?");
        }
        alternatives.Add(@"(?<![\w-])(?<code>ADR(?>(?:-[A-Z]+)+))(?<sep>[#:])(?<rule>[0-9]+)(?![0-9])(?<more>(?:" + Separator + "#[0-9]+(?![0-9]))*)");
        alternatives.Add(@"(?<![\w-])(?<bareCode>ADR(?>(?:-[A-Z]+)+))(?!\w)");
        alternatives.Add(@"(?<![\w-])(?<anchor>" + AnchorPattern + ")");
        reference = new Regex(string.Join("|", alternatives), RegexOptions.Compiled);
    }

    // The text with every mapped reference rewritten, as seen from the file at repoPath (repository-relative).
    public AdrCitationRewrite Rewrite(string text, string repoPath)
    {
        if (text == null) { throw new ArgumentNullException(nameof(text)); }
        string self = Normalize(repoPath);
        if (self.Length == 0) { throw new ArgumentException("the file's repository-relative path is required", nameof(repoPath)); }

        var edits = new List<(int Start, int Length, AdrCitationChangeKind Kind, string Replacement)>();
        var unhandled = new List<(int Start, string Old)>();

        var destinations = new List<Group>();
        foreach (Match link in InlineDestination.Matches(text)) { destinations.Add(link.Groups["dest"]); }
        if (self.EndsWith(".md", StringComparison.OrdinalIgnoreCase))
        {
            foreach (Match definition in ReferenceDestination.Matches(text)) { destinations.Add(definition.Groups["dest"]); }
        }
        destinations.Sort((left, right) => left.Index.CompareTo(right.Index));

        int scanned = 0;
        foreach (Group destination in destinations)
        {
            if (destination.Index < scanned) { continue; }
            Scan(text, scanned, destination.Index - scanned, self, edits, unhandled);
            string replacement = RewriteDestination(destination.Value, self);
            if (replacement != null) { edits.Add((destination.Index, destination.Length, AdrCitationChangeKind.Link, replacement)); }
            scanned = destination.Index + destination.Length;
        }
        Scan(text, scanned, text.Length - scanned, self, edits, unhandled);

        List<int> lineStarts = LineStarts(text);
        var found = new List<(int Start, AdrCitationChange Change)>();
        var output = new StringBuilder(text.Length);
        int copied = 0;
        edits.Sort((left, right) => left.Start.CompareTo(right.Start));
        foreach ((int start, int length, AdrCitationChangeKind kind, string replacement) in edits)
        {
            output.Append(text, copied, start - copied).Append(replacement);
            copied = start + length;
            found.Add((start, new AdrCitationChange(self, LineOf(lineStarts, start), kind, text.Substring(start, length), replacement)));
        }
        output.Append(text, copied, text.Length - copied);
        foreach ((int start, string old) in unhandled)
        {
            found.Add((start, new AdrCitationChange(self, LineOf(lineStarts, start), AdrCitationChangeKind.Unhandled, old, null)));
        }
        found.Sort((left, right) => left.Start.CompareTo(right.Start));
        var changes = new List<AdrCitationChange>(found.Count);
        foreach ((int _, AdrCitationChange change) in found) { changes.Add(change); }

        return edits.Count == 0
            ? new AdrCitationRewrite(text, false, changes)
            : new AdrCitationRewrite(output.ToString(), true, changes);
    }

    void Scan(string text, int start, int length, string self, List<(int, int, AdrCitationChangeKind, string)> edits, List<(int, string)> unhandled)
    {
        if (length <= 0) { return; }
        for (Match match = reference.Match(text, start, length); match.Success; match = match.NextMatch())
        {
            AdrCitationChangeKind kind;
            string replacement;
            if (match.Groups["repo"].Success)
            {
                string written = match.Groups["repo"].Value;
                Form form = written.StartsWith("/", StringComparison.Ordinal) ? Form.Rooted : Form.Repository;
                kind = AdrCitationChangeKind.Path;
                replacement = RewriteReference(written, Fragment(match.Groups["repoAnchor"]), form, self);
            }
            else if (match.Groups["relative"].Success)
            {
                kind = AdrCitationChangeKind.Path;
                replacement = RewriteReference(match.Groups["relative"].Value, Fragment(match.Groups["relativeAnchor"]), Form.Relative, self);
            }
            else if (match.Groups["bare"].Success)
            {
                kind = AdrCitationChangeKind.Path;
                replacement = RewriteReference(match.Groups["bare"].Value, Fragment(match.Groups["bareAnchor"]), Form.AdrRelative, self);
            }
            else if (match.Groups["code"].Success)
            {
                kind = AdrCitationChangeKind.Citation;
                replacement = RewriteCitation(match);
                if (replacement == null && SplitsRange(match))
                {
                    unhandled.Add((match.Index, match.Value));
                    continue;
                }
            }
            else if (match.Groups["bareCode"].Success)
            {
                kind = AdrCitationChangeKind.Code;
                replacement = codeMap.TryGetValue(match.Value, out string code) ? code : null;
            }
            else
            {
                kind = AdrCitationChangeKind.Anchor;
                replacement = RewriteAnchor(match.Value);
            }
            if (replacement != null && replacement != match.Value) { edits.Add((match.Index, match.Length, kind, replacement)); }
        }
    }

    // An inherited bare rule number keeps the code before it, and takes its own code only when its rule moved elsewhere.
    // [comment:3](/docs/references/automation/catzc-base-docs/types/AdrCitationRewriter.cs.md#comment3)
    string RewriteCitation(Match match)
    {
        if (SplitsRange(match)) { return null; }
        string oldCode = match.Groups["code"].Value;
        (string headCode, int headRule) = MapRule(oldCode, Number(match.Groups["rule"].Value));
        var output = new StringBuilder();
        output.Append(headCode).Append(match.Groups["sep"].Value).Append(headRule.ToString(CultureInfo.InvariantCulture));
        string current = headCode;
        foreach (Match item in ContinuationItem.Matches(match.Groups["more"].Value))
        {
            (string code, int rule) = MapRule(oldCode, Number(item.Groups["rule"].Value));
            output.Append(item.Groups["sep"].Value);
            if (code != current) { output.Append(code); }
            output.Append('#').Append(rule.ToString(CultureInfo.InvariantCulture));
            current = code;
        }
        string rewritten = output.ToString();
        return rewritten == match.Value ? null : rewritten;
    }

    // A range spanning a moved rule cannot be rewritten endpoint by endpoint, so it is reported and left as written.
    // [comment:4](/docs/references/automation/catzc-base-docs/types/AdrCitationRewriter.cs.md#comment4)
    bool SplitsRange(Match match)
    {
        string oldCode = match.Groups["code"].Value;
        int previous = Number(match.Groups["rule"].Value);
        foreach (Match item in ContinuationItem.Matches(match.Groups["more"].Value))
        {
            int rule = Number(item.Groups["rule"].Value);
            string separator = item.Groups["sep"].Value;
            bool range = separator.Contains("–") || separator.Trim() == "to";
            if (range)
            {
                for (int inner = Math.Min(previous, rule); inner <= Math.Max(previous, rule); inner++)
                {
                    if (ruleMap.ContainsKey(RuleKey(oldCode, inner))) { return true; }
                }
            }
            previous = rule;
        }
        return false;
    }

    string RewriteAnchor(string anchor)
    {
        Match match = RuleAnchor.Match(anchor);
        if (!match.Success) { return null; }
        string oldCode = match.Groups["code"].Value.ToUpperInvariant();
        int oldRule = Number(match.Groups["rule"].Value);
        (string code, int rule) = MapRule(oldCode, oldRule);
        return code == oldCode && rule == oldRule ? null : Anchor(code, rule);
    }

    // A link destination as written, (<target>) or (target): its path resolved by the link's form and mapped.
    string RewriteDestination(string written, string self)
    {
        bool angle = written.StartsWith("<", StringComparison.Ordinal) && written.EndsWith(">", StringComparison.Ordinal);
        string destination = angle ? written.Substring(1, written.Length - 2) : written;
        if (destination.Length == 0 || Scheme.IsMatch(destination)) { return null; }

        int hash = destination.IndexOf('#');
        string fragment = hash >= 0 ? destination.Substring(hash + 1) : null;
        string beforeFragment = hash >= 0 ? destination.Substring(0, hash) : destination;
        int question = beforeFragment.IndexOf('?');
        string query = question >= 0 ? beforeFragment.Substring(question) : string.Empty;
        string pathPart = question >= 0 ? beforeFragment.Substring(0, question) : beforeFragment;

        Form form = pathPart.Length == 0 ? Form.InFile : pathPart.StartsWith("/", StringComparison.Ordinal) ? Form.Rooted : Form.Relative;
        string rewritten = RewriteReference(pathPart, fragment, form, self);
        if (rewritten == null) { return null; }
        int rewrittenHash = rewritten.IndexOf('#');
        string result = rewrittenHash >= 0
            ? rewritten.Substring(0, rewrittenHash) + query + rewritten.Substring(rewrittenHash)
            : rewritten + query;
        return angle ? "<" + result + ">" : result;
    }

    // Null means leave the text alone: the reference points outside docs/adr/ or mapping it changes nothing.
    // [comment:5](/docs/references/automation/catzc-base-docs/types/AdrCitationRewriter.cs.md#comment5)
    string RewriteReference(string pathPart, string fragment, Form form, string self)
    {
        string target;
        switch (form)
        {
            case Form.InFile: target = self; break;
            case Form.Rooted: target = Join(Resolve(new List<string>(), pathPart)); break;
            case Form.Repository: target = Join(Resolve(new List<string>(), pathPart)); break;
            case Form.AdrRelative: target = Join(Resolve(new List<string>(), AdrRoot + pathPart)); break;
            default: target = Join(Resolve(Segments(ParentOf(self)), pathPart)); break;
        }
        if (target == null || !target.StartsWith(AdrRoot, StringComparison.Ordinal)) { return null; }

        string adrPath = target.Substring(AdrRoot.Length);
        bool trailing = pathPart.EndsWith("/", StringComparison.Ordinal);
        (string newAdrPath, string newFragment) = MapTarget(adrPath, fragment, form == Form.InFile);
        if (newAdrPath == adrPath && newFragment == fragment) { return null; }

        string slash = trailing ? "/" : string.Empty;
        string newPathPart;
        if (newAdrPath == adrPath)
        {
            newPathPart = pathPart;
        }
        else
        {
            switch (form)
            {
                case Form.Rooted: newPathPart = "/" + AdrRoot + newAdrPath + slash; break;
                case Form.Repository: newPathPart = AdrRoot + newAdrPath + slash; break;
                case Form.AdrRelative: newPathPart = newAdrPath + slash; break;
                default: newPathPart = MarkdownLinkRebaser.RelativeLink(ParentOf(self), AdrRoot + newAdrPath) + slash; break;
            }
        }
        return newFragment == null ? newPathPart : newPathPart + "#" + newFragment;
    }

    // A rule anchor follows its rule, even to another file; any other path follows the file and folder map.
    // [comment:6](/docs/references/automation/catzc-base-docs/types/AdrCitationRewriter.cs.md#comment6)
    (string Path, string Fragment) MapTarget(string adrPath, string fragment, bool inFile)
    {
        string newPath = MapPath(adrPath);
        if (fragment == null) { return (newPath, null); }
        Match anchor = RuleAnchor.Match(fragment);
        if (!anchor.Success) { return (newPath, fragment); }

        string oldCode = anchor.Groups["code"].Value.ToUpperInvariant();
        int oldRule = Number(anchor.Groups["rule"].Value);
        (string code, int rule) = MapRule(oldCode, oldRule);
        if (code == oldCode && rule == oldRule) { return (newPath, fragment); }
        if (code != oldCode && !(inFile && !IsFileOf(oldCode, adrPath)))
        {
            newPath = PathOfCode(code);
        }
        return (newPath, Anchor(code, rule));
    }

    string MapPath(string adrPath)
    {
        string bare = adrPath.TrimEnd('/');
        if (pathMap.TryGetValue(bare, out string mapped)) { return mapped; }
        foreach ((string old, string replacement) in folderMap)
        {
            if (bare == old) { return replacement; }
            if (bare.StartsWith(old + "/", StringComparison.Ordinal)) { return replacement + bare.Substring(old.Length); }
        }
        return bare;
    }

    (string Code, int Rule) MapRule(string code, int rule)
    {
        if (ruleMap.TryGetValue(RuleKey(code, rule), out (string, int) moved)) { return moved; }
        return codeMap.TryGetValue(code, out string renamed) ? (renamed, rule) : (code, rule);
    }

    bool IsFileOf(string code, string adrPath)
    {
        if (oldPathByCode.TryGetValue(code, out string oldPath) && oldPath == adrPath) { return true; }
        if (citations != null && citations.PathOf(code) == AdrRoot + adrPath) { return true; }
        return codeMap.TryGetValue(code, out string renamed) && newPathByCode.TryGetValue(renamed, out string newPath) && newPath == adrPath;
    }

    string PathOfCode(string code)
    {
        if (newPathByCode.TryGetValue(code, out string path)) { return path; }
        string indexed = citations?.PathOf(code);
        if (indexed != null && indexed.StartsWith(AdrRoot, StringComparison.Ordinal)) { return indexed.Substring(AdrRoot.Length); }
        throw new InvalidOperationException(string.Format(CultureInfo.InvariantCulture,
            "no ADR path for '{0}': neither the code map nor the ADR index names it", code));
    }

    void AddCodeRow(Dictionary<string, string> cells)
    {
        string oldCode = cells["old_code"], newCode = cells["new_code"], oldPath = cells["old_path"], newPath = cells["new_path"], kind = cells["kind"];
        if (!CodeMapKinds.Contains(kind)) { throw Invalid("code map", "kind '" + kind + "' is not one of move, path, new, folder"); }
        foreach (string code in new[] { oldCode, newCode })
        {
            if (code != "-" && !Code.IsMatch(code)) { throw Invalid("code map", "'" + code + "' is not an ADR code"); }
        }
        if (oldCode != "-")
        {
            if (newCode == "-") { throw Invalid("code map", "'" + oldCode + "' has no new code"); }
            if (codeMap.ContainsKey(oldCode) || oldPathByCode.ContainsKey(oldCode)) { throw Invalid("code map", "'" + oldCode + "' appears twice"); }
            if (oldCode != newCode) { codeMap[oldCode] = newCode; }
            if (oldPath != "-") { oldPathByCode[oldCode] = Normalize(oldPath); }
        }
        if (newCode != "-" && newPath != "-") { newPathByCode[newCode] = Normalize(newPath); }
        if (oldPath != "-" && newPath != "-" && oldPath != newPath)
        {
            pathMap[Normalize(oldPath)] = Normalize(newPath);
            if (kind == "folder") { folderMap.Add((ParentOf(Normalize(oldPath)), ParentOf(Normalize(newPath)))); }
        }
    }

    void AddRuleRow(Dictionary<string, string> cells)
    {
        Match old = RuleId.Match(cells["old_rule"]);
        Match moved = RuleId.Match(cells["new_rule"]);
        if (!old.Success || !moved.Success) { throw Invalid("rule map", "'" + cells["old_rule"] + "' -> '" + cells["new_rule"] + "' is not ADR-<CODE>:<n> -> ADR-<CODE>:<n>"); }
        if (!RuleMapKinds.Contains(cells["kind"])) { throw Invalid("rule map", "kind '" + cells["kind"] + "' is not one of move, collapse"); }
        string key = RuleKey(old.Groups["code"].Value, Number(old.Groups["rule"].Value));
        if (ruleMap.ContainsKey(key)) { throw Invalid("rule map", "'" + cells["old_rule"] + "' appears twice"); }
        ruleMap[key] = (moved.Groups["code"].Value, Number(moved.Groups["rule"].Value));
    }

    static Dictionary<string, string> Cells(object row, string[] columns, string map)
    {
        if (!(row is IDictionary values)) { throw Invalid(map, "a row is not a dictionary"); }
        var cells = new Dictionary<string, string>(StringComparer.Ordinal);
        foreach (string column in columns)
        {
            string value = values.Contains(column) ? Convert.ToString(values[column], CultureInfo.InvariantCulture) : null;
            if (string.IsNullOrWhiteSpace(value)) { throw Invalid(map, "a row has no '" + column + "'"); }
            cells[column] = value.Trim();
        }
        return cells;
    }

    static ArgumentException Invalid(string map, string reason) =>
        new ArgumentException(string.Format(CultureInfo.InvariantCulture, "{0}: {1}", map, reason));

    static string Fragment(Group anchor) => anchor.Success ? anchor.Value : null;

    static string RuleKey(string code, int rule) => code + ":" + rule.ToString(CultureInfo.InvariantCulture);

    static string Anchor(string code, int rule) => "rule-" + code.ToLowerInvariant() + rule.ToString(CultureInfo.InvariantCulture);

    static int Number(string digits) => int.Parse(digits, NumberStyles.None, CultureInfo.InvariantCulture);

    static List<int> LineStarts(string text)
    {
        var starts = new List<int> { 0 };
        for (int index = text.IndexOf('\n'); index >= 0; index = text.IndexOf('\n', index + 1)) { starts.Add(index + 1); }
        return starts;
    }

    static int LineOf(List<int> lineStarts, int offset)
    {
        int found = lineStarts.BinarySearch(offset);
        return found >= 0 ? found + 1 : ~found;
    }

    // folder + a relative path, with '.' and '..' applied; null when it climbs above the repository root.
    static List<string> Resolve(List<string> folder, string relativePath)
    {
        var result = new List<string>(folder);
        foreach (string segment in relativePath.Split('/'))
        {
            if (segment.Length == 0 || segment == ".") { continue; }
            if (segment == "..")
            {
                if (result.Count == 0) { return null; }
                result.RemoveAt(result.Count - 1);
                continue;
            }
            result.Add(segment);
        }
        return result;
    }

    static string Join(List<string> segments) => segments == null ? null : string.Join("/", segments);

    static string ParentOf(string repoPath)
    {
        int slash = repoPath.LastIndexOf('/');
        return slash < 0 ? string.Empty : repoPath.Substring(0, slash);
    }

    static List<string> Segments(string repoPath)
    {
        var segments = new List<string>();
        foreach (string segment in repoPath.Split('/'))
        {
            if (segment.Length > 0 && segment != ".") { segments.Add(segment); }
        }
        return segments;
    }

    static string Normalize(string path) => (path ?? string.Empty).Replace('\\', '/').Trim('/');

    enum Form
    {
        InFile,
        Rooted,
        Repository,
        Relative,
        AdrRelative
    }
}
