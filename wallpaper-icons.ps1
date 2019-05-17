Function Set-WallPaper($Image) {
<#
.SYNOPSIS
Applies a specified wallpaper to the current user's desktop
   
.PARAMETER Image
Provide the exact path to the image
 
.EXAMPLE
Set-WallPaper -Image "C:\Wallpaper\Default.jpg"
 
#>
 
Add-Type -TypeDefinition @' 
using System; 
using System.Runtime.InteropServices;
 
public class Wallpaper
{ 
    [DllImport("User32.dll",CharSet=CharSet.Unicode)] 
    public static extern int SystemParametersInfo (Int32 uAction, 
                                                   Int32 uParam, 
                                                   String lpvParam, 
                                                   Int32 fuWinIni);
}
'@ 
 
$SPI_SETDESKWALLPAPER = 0x0014
$UpdateIniFile = 0x01
$SendChangeEvent = 0x02
 
$fWinIni = $UpdateIniFile -bor $SendChangeEvent
 
$ret = [Wallpaper]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $Image, $fWinIni)
}

Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;

namespace DesktopUtility
{
	class Win32Functions
	{
		[DllImport("user32.dll")]
		public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);
		[DllImport("user32.dll")]
		public static extern IntPtr GetWindow(IntPtr hWnd, uint uCmd);
		[DllImport("user32.dll")]
		public static extern IntPtr FindWindowEx(IntPtr hwndParent, IntPtr hwndChildAfter, string lpszClass, string lpszWindow);
		[DllImport("user32.dll")]
		public static extern IntPtr GetDesktopWindow();
		[DllImport("user32.dll")]
		public static extern IntPtr SendMessage(IntPtr hWnd, uint Msg, IntPtr wParam, IntPtr lParam);
		[DllImport("user32.dll")]
		public static extern IntPtr GetForegroundWindow();
		[DllImport("user32.dll")]
		public static extern bool GetWindowInfo(IntPtr hwnd, ref WINDOWINFO pwi);
		[DllImport("user32.dll")]
		public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
		[DllImport("user32.dll")]
		public static extern bool IsWindowVisible(IntPtr hWnd);

		[StructLayout(LayoutKind.Sequential)]
		public struct RECT
		{
			private int _Left;
			private int _Top;
			private int _Right;
			private int _Bottom;
		}

		[StructLayout(LayoutKind.Sequential)]
		public struct WINDOWINFO
		{
			public uint cbSize;
			public RECT rcWindow;
			public RECT rcClient;
			public uint dwStyle;
			public uint dwExStyle;
			public uint dwWindowStatus;
			public uint cxWindowBorders;
			public uint cyWindowBorders;
			public ushort atomWindowType;
			public ushort wCreatorVersion;

			public WINDOWINFO(bool? filler) : this()
			{
				cbSize = (uint)Marshal.SizeOf(typeof(WINDOWINFO));
			}
		}

		public const int SW_HIDE = 0;
		public const int SW_SHOWNORMAL = 1;
		public const int SW_SHOWMINIMIZED = 2;
		public const int SW_SHOWMAXIMIZED = 3;
		public const int SW_SHOWNOACTIVATE = 4;
		public const int SW_RESTORE = 9;
		public const int SW_SHOWDEFAULT = 10;
	}

	public class Desktop
	{
		public static IntPtr GetHandle()
		{
			IntPtr hDesktopWin = Win32Functions.GetDesktopWindow();
			IntPtr hProgman = Win32Functions.FindWindow("Progman", "Program Manager");
			IntPtr hWorkerW = IntPtr.Zero;

			IntPtr hShellViewWin = Win32Functions.FindWindowEx(hProgman, IntPtr.Zero, "SHELLDLL_DefView", "");
			if (hShellViewWin == IntPtr.Zero)
			{
				do
				{
					hWorkerW = Win32Functions.FindWindowEx(hDesktopWin, hWorkerW, "WorkerW", "");
					hShellViewWin = Win32Functions.FindWindowEx(hWorkerW, IntPtr.Zero, "SHELLDLL_DefView", "");
				} while (hShellViewWin == IntPtr.Zero && hWorkerW != null);
			}
			return hShellViewWin;
		}

		public static bool IsActiveWindow()
		{
			return Win32Functions.GetWindow(Win32Functions.GetForegroundWindow(), 5)
				== Win32Functions.GetWindow(Desktop.GetHandle(), 3);
		}

		public static bool IsDesktopIconsVisible()
		{
			IntPtr hWnd = Win32Functions.GetWindow(Desktop.GetHandle(), 5);
			Win32Functions.WINDOWINFO info = new Win32Functions.WINDOWINFO();
			info.cbSize = (uint)Marshal.SizeOf(info);
			Win32Functions.GetWindowInfo(hWnd, ref info);
			return (info.dwStyle & 0x10000000) == 0x10000000;
		}

		public static void ToggleDesktopIcons()
		{
			Win32Functions.SendMessage(Desktop.GetHandle(), 0x0111, (IntPtr)0x7402, (IntPtr)0);
		}

		public static bool IsDesktopControlsVisible()
		{
			return Win32Functions.IsWindowVisible(Desktop.GetHandle());
		}

		public static void ToggleDesktopControls()
		{
			if (Desktop.IsDesktopControlsVisible())
				Win32Functions.ShowWindowAsync(Desktop.GetHandle(), Win32Functions.SW_HIDE);
			else
				Win32Functions.ShowWindowAsync(Desktop.GetHandle(), Win32Functions.SW_SHOWNORMAL);
		}
	}
}
'@

Invoke-WebRequest https://raw.githubusercontent.com/ncarusso/pmi/master/serveimage.jpg -outfile $env:temp\hacked.jpg
Get-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallPaper | Select-Object wallpaper | Out-File -FilePath $env:temp\wallpaper.txt
Set-WallPaper -Image "$env:temp\hacked.jpg"
[DesktopUtility.Desktop]::ToggleDesktopIcons()
# Set-WallPaper -Image "C:\WINDOWS\web\wallpaper\Windows\img0.jpg"
