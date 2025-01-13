using System;
using System.Runtime.InteropServices;
using System.Text;

class Program
{
    [DllImport("user32.dll", SetLastError = true)]
    public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);

    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool EnumWindows(EnumWindowsProc lpEnumFunc, IntPtr lParam);

    [DllImport("user32.dll")]
    public static extern int GetWindowText(IntPtr hWnd, StringBuilder lpString, int nMaxCount);

    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

    // EnumWindows callback function
    public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);

    // Constants
    public const int SW_MINIMIZE = 6;

    static void Main()
    {
        // Enumerate all windows
        bool dockerFound = false;
        EnumWindows((hWnd, lParam) =>
        {
            StringBuilder windowTitle = new StringBuilder(256);
            GetWindowText(hWnd, windowTitle, windowTitle.Capacity);

            if (windowTitle.ToString().Contains("Docker Desktop"))
            {
                // Minimize the Docker Desktop window
                ShowWindow(hWnd, SW_MINIMIZE);
                dockerFound = true;
            }

            return true; // Continue enumerating
        }, IntPtr.Zero);

        if (!dockerFound)
        {
            Console.WriteLine("Docker Desktop not found.");
        }

        // Close the console window automatically after the task is done
        Environment.Exit(0);
    }
}
