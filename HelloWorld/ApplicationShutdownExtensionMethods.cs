using System;
using System.Threading.Tasks;
using Microsoft.Framework.Runtime;
using Mono.Unix;

namespace HelloMvc
{
    public static class ApplicationShutdownExtensionMethods
    {
        public static void OnUnixSignals(this IApplicationShutdown applicationShutdown)
        {
            Task.Factory.StartNew(() =>
            {
                var sigInt = new UnixSignal(Mono.Unix.Native.Signum.SIGINT);
                var sigTerm = new UnixSignal(Mono.Unix.Native.Signum.SIGTERM);
                Console.WriteLine("To terminate, send SIGINT or SIGTERM to the process");
                UnixSignal.WaitAny(new[] { sigInt, sigTerm });
                Console.WriteLine("Received signal");
                applicationShutdown.RequestShutdown();
            }, TaskCreationOptions.LongRunning);
        }
    }
}

