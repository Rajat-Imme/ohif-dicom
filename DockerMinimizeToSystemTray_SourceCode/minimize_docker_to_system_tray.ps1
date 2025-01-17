# Find the Docker Desktop process by title
$dockerWindow = Get-Process | Where-Object { $_.MainWindowTitle -like "*Docker Desktop*" }

# Minimize the window to the system tray by sending WM_CLOSE
if ($dockerWindow) {
    $hwnd = $dockerWindow.MainWindowHandle
    Add-Type @"
        using System;
        using System.Runtime.InteropServices;
        public class WindowHelper {
            [DllImport("user32.dll", CharSet = CharSet.Auto)]
            public static extern int SendMessage(IntPtr hWnd, int Msg, IntPtr wParam, IntPtr lParam);

            public const int WM_CLOSE = 0x0010;
        }
"@

    [WindowHelper]::SendMessage($hwnd, [WindowHelper]::WM_CLOSE, [IntPtr]::Zero, [IntPtr]::Zero)
}
