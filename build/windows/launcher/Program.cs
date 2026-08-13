using System;
using System.Diagnostics;
using System.IO;
using System.Reflection;

[assembly: AssemblyTitle("Amnezia OpenCCK CIDR Converter")]
[assembly: AssemblyDescription("Interactive OpenCCK CIDR converter for Amnezia")]
[assembly: AssemblyProduct("Amnezia OpenCCK CIDR Converter")]
[assembly: AssemblyCopyright("Copyright © 2026")]
[assembly: AssemblyVersion("1.1.0.0")]
[assembly: AssemblyFileVersion("1.1.0.0")]

internal static class Program
{
    private static int Main()
    {
        string baseDirectory = AppDomain.CurrentDomain.BaseDirectory;
        string runtimeDirectory = Path.Combine(baseDirectory, "runtime");
        string scriptPath = Path.Combine(
            runtimeDirectory,
            "src",
            "convert-opencck-cidr-ui.ps1"
        );
        string gumPath = Path.Combine(runtimeDirectory, "gum.exe");

        if (!File.Exists(scriptPath))
        {
            Console.Error.WriteLine("Runtime script was not found:");
            Console.Error.WriteLine(scriptPath);
            Console.ReadKey();
            return 1;
        }

        if (!File.Exists(gumPath))
        {
            Console.Error.WriteLine("Bundled gum.exe was not found:");
            Console.Error.WriteLine(gumPath);
            Console.ReadKey();
            return 1;
        }

        string currentPath = Environment.GetEnvironmentVariable("PATH") ?? string.Empty;

        Environment.SetEnvironmentVariable(
            "PATH",
            runtimeDirectory + Path.PathSeparator + currentPath
        );

        string windowsDirectory =
            Environment.GetEnvironmentVariable("WINDIR") ?? @"C:\Windows";

        string powershellPath = Path.Combine(
            windowsDirectory,
            "System32",
            "WindowsPowerShell",
            "v1.0",
            "powershell.exe"
        );

        if (!File.Exists(powershellPath))
        {
            Console.Error.WriteLine("Windows PowerShell was not found:");
            Console.Error.WriteLine(powershellPath);
            Console.ReadKey();
            return 1;
        }

        ProcessStartInfo startInfo = new ProcessStartInfo
        {
            FileName = powershellPath,
            Arguments =
                "-NoLogo -NoProfile -ExecutionPolicy Bypass -File \"" +
                scriptPath +
                "\"",
            UseShellExecute = false
        };

        Process process = Process.Start(startInfo);

        if (process == null)
        {
            Console.Error.WriteLine("Unable to start the converter.");
            return 1;
        }

        process.WaitForExit();

        return process.ExitCode;
    }
}
