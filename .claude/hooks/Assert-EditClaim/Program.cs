using System;
using Catzc.Tooling.Claude;

namespace Catzc.Hooks;

public static class AssertEditClaim
{
    public static int Main()
    {
        try
        {
            string reason = EditorClaimGuard.Decide(Console.In.ReadToEnd(), EditorClaim.DefaultFolder(), DateTime.UtcNow);
            if (reason != null)
            {
                Console.Out.Write(EditorClaimGuard.DenyOutput(reason));
            }
        }
        catch (Exception e)
        {
            // A broken claim check never stops every edit of every session: the call goes on, and the failure is said on stderr.
            Console.Error.WriteLine("Assert-EditClaim: the editor-claim check failed, so the call goes on: " + e.Message);
        }
        return 0;
    }
}
