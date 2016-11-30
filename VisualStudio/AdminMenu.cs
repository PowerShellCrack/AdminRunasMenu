using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Xml;
using System.Windows.Forms;
using System.Reflection;
using MahApps.Metro.Controls;

namespace PSAdminMenu
{
    static class AdminMenu
    {
        [STAThread]
        public static void Main()
        {
            try
            {
                // Set up variables
                int processExitCode = 60010;
                string currentAppPath = new Uri(Assembly.GetExecutingAssembly().CodeBase).LocalPath;
                string currentAppFolder = Path.GetDirectoryName(currentAppPath);
                string appScriptPath = Path.Combine(currentAppFolder, "AdminMenu.ps1");
                string appExtensionFolder = Path.Combine(currentAppFolder, "Extensions");
                string appXamlFolder = Path.Combine(currentAppFolder, "Resources");
                string appXMLPath = Path.Combine(currentAppFolder, "AdminMenu.ps1.config");
                string powershellExePath = Path.Combine(Environment.GetEnvironmentVariable("WinDir"), "System32\\WindowsPowerShell\\v1.0\\PowerShell.exe");
                string powershellArgs = "-ExecutionPolicy Bypass -NoProfile -NoLogo -sta -WindowStyle Hidden";
                List<string> commandLineArgs = new List<string>(Environment.GetCommandLineArgs());
                bool isForceX86Mode = false;
                bool isRequireAdmin = false;

                // Load Metro Assemblys
                AppDomain.CurrentDomain.AssemblyResolve += (sender, args) => {
                    var resourceName = Assembly.GetExecutingAssembly().GetName().Name + ".Assemblies." + new AssemblyName(args.Name).Name + ".dll";
                    using (var stream = Assembly.GetExecutingAssembly().GetManifestResourceStream(resourceName))
                    {
                        if (stream != null)
                        {
                            var assemblyData = new Byte[stream.Length];
                            stream.Read(assemblyData, 0, assemblyData.Length);
                            return Assembly.Load(assemblyData);
                        }
                    }
                    return null;
                };

                // Get OS Architecture. Check does not return correct value when running in x86 process on x64 system but it works for our purpose.
                // To get correct OS architecture when running in x86 process on x64 system, we would also have to check environment variable: PROCESSOR_ARCHITEW6432.
                bool is64BitOS = false;
                if (Environment.GetEnvironmentVariable("PROCESSOR_ARCHITECTURE").Contains("64"))
                    is64BitOS = true;

                // Trim ending & starting empty space from each element in the command-line
                commandLineArgs = commandLineArgs.ConvertAll(s => s.Trim());
                // Remove first command-line argument as this is always the executable name
                commandLineArgs.RemoveAt(0);

                // Check if x86 PowerShell mode was specified on command line
                if (commandLineArgs.Exists(x => x == "/32"))
                {
                    isForceX86Mode = true;
                    WriteDebugMessage("'/32' parameter was specified on the command-line. Running in forced x86 PowerShell mode...");
                    // Remove the /32 command line argument so that it is not passed to PowerShell script
                    commandLineArgs.RemoveAll(x => x == "/32");
                }

                if (commandLineArgs.Exists(x => x.StartsWith("-ForceLocal")))
                {
                    WriteDebugMessage("'-ForceLocal' parameter was specified on the command-line. Running in forced config local mode...");
                }

                // Check for the App Config file being specified
                string commandLineAppXMLPathArg = String.Empty;
                if (commandLineArgs.Exists(x => x.StartsWith("-Config ")))
                {
                    commandLineAppXMLPathArg = commandLineArgs.Find(x => x.StartsWith("-Config "));
                    appXMLPath = commandLineAppXMLPathArg.Replace("-Config ", String.Empty).Replace("\"", String.Empty);
                    if (!Path.IsPathRooted(appXMLPath))
                        appXMLPath = Path.Combine(currentAppFolder, appXMLPath);
                    // commandLineArgs.RemoveAt(commandLineArgs.FindIndex(x => x.StartsWith("-Config")));
                    WriteDebugMessage("'-Config' parameter specified on command-line. Passing command-line untouched...");
                }
                else if (commandLineArgs.Exists(x => x.EndsWith(".config") || x.EndsWith(".config\"")))
                {
                    appXMLPath = commandLineArgs.Find(x => x.EndsWith(".config") || x.EndsWith(".config\"")).Replace("\"", String.Empty);
                    if (!Path.IsPathRooted(appXMLPath))
                        appXMLPath = Path.Combine(currentAppFolder, appXMLPath);
                    // commandLineArgs.RemoveAt(commandLineArgs.FindIndex(x => x.EndsWith(".config") || x.EndsWith(".config\"")));
                    WriteDebugMessage(".config file specified on command-line. Appending '-Config' parameter name...");
                }
                else
                {
                    WriteDebugMessage("No '-Config' parameter specified on command-line. Adding parameter '-Config \"" + appXMLPath + "\"'...");
                }

                // Define the command line arguments to pass to PowerShell
                powershellArgs = powershellArgs + " -Command & { & '" + appScriptPath + "'";
                if (commandLineArgs.Count > 0)
                {
                    powershellArgs = powershellArgs + " " + string.Join(" ", commandLineArgs.ToArray());
                }
                powershellArgs = powershellArgs + "; Exit $LastExitCode }";

                // Verify if the App Script file exists
                if (!File.Exists(appScriptPath))
                {
                    throw new Exception("A critical component of the Admin Run-As Menu is missing." + Environment.NewLine + Environment.NewLine + "Unable to find the 'AdminMenu.ps1' Script file: " + appScriptPath + "." + Environment.NewLine + Environment.NewLine + "Please ensure you have all of the required files available to start the installation.");
                }

                // Verify if the Admin Run-As Menu Extensions folder exists
                if (!Directory.Exists(appExtensionFolder))
                {
                    throw new Exception("A critical component of the Admin Run-As Menu is missing." + Environment.NewLine + Environment.NewLine + "Unable to find the 'Extensions' folder." + Environment.NewLine + Environment.NewLine + "Please ensure you have all of the required folders available to start the installation.");
                }

                // Verify if the Admin Run-As Menu Resources exists
                if (!Directory.Exists(appXamlFolder))
                {
                    throw new Exception("A critical component of the Admin Run-As Menu is missing." + Environment.NewLine + Environment.NewLine + "Unable to find the 'Resources' folder." + Environment.NewLine + Environment.NewLine + "Please ensure you have all of the required folders available to start the installation.");
                }

                // Verify if the Admin Run-As Menu Extensions Config XML file exists
                if (!File.Exists(appXMLPath))
                {
                    throw new Exception("A critical component of the Admin Run-As Menu is missing." + Environment.NewLine + Environment.NewLine + "Unable to find the 'AdminMenu.ps1.config' file." + Environment.NewLine + Environment.NewLine + "Please ensure you have all of the required files available to start the installation.");
                }
                else
                {
                    // Read the XML and determine whether we need Admin Rights
                    XmlDocument xml = new XmlDocument();
                    xml.Load(appXMLPath);
                    XmlNode xmlNode = null;
                    XmlElement xmlRoot = xml.DocumentElement;
                    xmlNode = xmlRoot.SelectSingleNode("/AdminMenu_Configs/Menu_Options/Option_RequireAdmin");
                    isRequireAdmin = Convert.ToBoolean(xmlNode.InnerText);
                    if (isRequireAdmin)
                    {
                        WriteDebugMessage("Administrator rights are required...");
                    }
                }

                // Switch to x86 PowerShell if requested
                if (is64BitOS & isForceX86Mode)
                {
                    powershellExePath = Path.Combine(Environment.GetEnvironmentVariable("WinDir"), "SysWOW64\\WindowsPowerShell\\v1.0\\PowerShell.exe");
                }

                // Define PowerShell process
                WriteDebugMessage("PowerShell Path: " + powershellExePath);
                WriteDebugMessage("PowerShell Parameters: " + powershellArgs);
                ProcessStartInfo processStartInfo = new ProcessStartInfo();
                processStartInfo.FileName = powershellExePath;
                processStartInfo.Arguments = powershellArgs;
                processStartInfo.WorkingDirectory = Path.GetDirectoryName(powershellExePath);
                processStartInfo.WindowStyle = ProcessWindowStyle.Hidden;
                processStartInfo.UseShellExecute = true;
                // Set the RunAs flag if the XML specifically calls for Admin Rights and OS Vista or higher
                if (((isRequireAdmin) & (Environment.OSVersion.Version.Major >= 6)))
                {
                    processStartInfo.Verb = "runas";
                }

                // Start the PowerShell process and wait for completion
                processExitCode = 60011;
                Process process = new Process();
                try
                {
                    process.StartInfo = processStartInfo;
                    process.Start();
                    process.WaitForExit();
                    processExitCode = process.ExitCode;
                }
                catch (Exception)
                {
                    throw;
                }
                finally
                {
                    if ((process != null))
                    {
                        process.Dispose();
                    }
                }

                // Exit
                WriteDebugMessage("Exit Code: " + processExitCode);
                Environment.Exit(processExitCode);
            }
            catch (Exception ex)
            {
                WriteDebugMessage(ex.Message, true, MessageBoxIcon.Error);
                Environment.Exit(processExitCode);
            }
        }

        public static void WriteDebugMessage(string debugMessage = null, bool IsDisplayError = false, MessageBoxIcon MsgBoxStyle = MessageBoxIcon.Information)
        {
            // Output to the Console
            Console.WriteLine(debugMessage);

            // If we are to display an error message...
            IntPtr handle = Process.GetCurrentProcess().MainWindowHandle;
            if (IsDisplayError == true)
            {
                MessageBox.Show(new WindowWrapper(handle), debugMessage, Application.ProductName + " " + Application.ProductVersion, MessageBoxButtons.OK, (MessageBoxIcon)MsgBoxStyle, MessageBoxDefaultButton.Button1);
            }
        }

        public class WindowWrapper : System.Windows.Forms.IWin32Window
        {
            public WindowWrapper(IntPtr handle)
            {
                _hwnd = handle;
            }

            public IntPtr Handle
            {
                get { return _hwnd; }
            }

            private IntPtr _hwnd;
        }

        public static int processExitCode { get; set; }
    }
}
