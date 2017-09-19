Add-Type @"
using System;
using System.Runtime.InteropServices;
using Microsoft.Win32;
namespace Wallpaper
{
   public enum Style : int
   {
       Tile, Center, Stretch, NoChange
   }
   public class Setter {
      public const int SetDesktopWallpaper = 20;
      public const int UpdateIniFile = 0x01;
      public const int SendWinIniChange = 0x02;
      [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
      private static extern int SystemParametersInfo (int uAction, int uParam, string lpvParam, int fuWinIni);
      public static void SetWallpaper ( string path, Wallpaper.Style style ) {
         SystemParametersInfo( SetDesktopWallpaper, 0, path, UpdateIniFile | SendWinIniChange );
         RegistryKey key = Registry.CurrentUser.OpenSubKey("Control Panel\\Desktop", true);
         switch( style )
         {
            case Style.Stretch :
               key.SetValue(@"WallpaperStyle", "2") ; 
               key.SetValue(@"TileWallpaper", "0") ;
               break;
            case Style.Center :
               key.SetValue(@"WallpaperStyle", "1") ; 
               key.SetValue(@"TileWallpaper", "0") ; 
               break;
            case Style.Tile :
               key.SetValue(@"WallpaperStyle", "1") ; 
               key.SetValue(@"TileWallpaper", "1") ;
               break;
            case Style.NoChange :
               break;
         }
         key.Close();
      }
   }
}
"@
#del H:\wallpaper.bmp
#xcopy .\wallpaper.bmp H:\
#[Wallpaper.Setter]::SetWallpaper( 'H:\wallpaper.bmp', 2 )
#del H:\wallpaper.bmp

##this stuff is for test machine in virtualbox at home, do not mess with
#del C:\Users\TEST\Documents\
#xcopy .\wallpaper.bmp C:\Users\TEST\Documents\
#[Wallpaper.Setter]::SetWallpaper( 'C:\Users\TEST\Documents\wallpaper.bmp', 2 )

Set-ExecutionPolicy -Scope CurrentUser unrestricted
cls
$done = $FALSE
while($done -eq $FALSE){
    $title = "Wallpaper Changer and other Tools Menu, Version 6.5"
    $message = "`nThe tools included in this script are as follows:`nWallpaper Changer`n`n"

    #CURRENT OPTIONS BEGIN
    $WallpaperChanger = New-Object System.Management.Automation.Host.ChoiceDescription "&WallpaperChanger", `
    "Change the wallpaper or background on your computer, requires 'wallpaper.bmp' to be present in the same folder as this script"

    $Exit = New-Object System.Management.Automation.Host.ChoiceDescription "&Exit", `
    "Exits the script safely"

    #OPTIONS END
    #AUX OPTIONS
    $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes"
    $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No"
    $blank = ""
    #UI PROMPT BEGIN
    $options = [System.Management.Automation.Host.ChoiceDescription[]]($WallpaperChanger, $Exit)

    $result = $Host.UI.PromptForChoice($title, $message, $options, 0)
    #UI PROMPT END

    switch ($result)
    {
        #changing the wallpaper
        0 {
            Write-Host "`nYou have selected to change your wallpaper, so please input the filename of your wallpaper. WARNING, the image file MUST be in BMP format or it will not work. ALSO, only type the filename, and do not at the extension, as in 'wallpaper' instead of 'wallpaper.bmp'`n"
            $filename = Read-Host -Prompt "Filename"
            $options = [System.Management.Automation.Host.ChoiceDescription[]]($yes,$no)
            $title = "Is this filename correct?"
            $result = $Host.UI.PromptForChoice($title,$filename,$options, 0)
            $Drive = ""
            switch ($result){
                0 {
                    Write-Host "Initiating Changes..."
                    $ifdone = $FALSE
                    if ((Test-Path H:\) -and ($ifdone -eq $FALSE)){
                        Write-Host "`nH:\ Drive exists, Writing...`n"
                        $Drive = "H:\"
                    }
                    if ((Test-Path C:\) -and -Not (Test-Path H:\)){
                        Write-Host "`nH:\ Drive does not exist, using C:\ drive ...`n"
                        $Drive = "C:\"
                    }
                    else {
                        Write-Host "`nPath testing failed, aborting...`n"
                        $Drive = ""
                    }
                    ### for H: drive systems, school systems
                    #del H:\wallpaper.bmp
                    #xcopy .\wallpaper.bmp H:\
                    #[Wallpaper.Setter]::SetWallpaper( 'H:\wallpaper.bmp', 2 )
                    #del H:\wallpaper.bmp

                    ### for C drive systems, testing system
                    #del C:\Users\$env:USERNAME\Documents\$filename.bmp
                    #xcopy .\$filename.bmp C:\Users\$env:USERNAME\Documents\$filename.bmp
                    #[Wallpaper.Setter]::SetWallpaper( ('C:\Users\' + $env:USERNAME + '\Documents\' + $filename + '.bmp'), 2 )
                    #del C:\Users\$env:USERNAME\Documents\$filename.bmp
                }
                1 {
                    Write-Host "`nAborting..."
                    Break
                }
            }
        }
        #Exiting Script
        1 {
        Write-Host "Thank you for using a Hypersleep Developments Tool, we wish you well in the future"
        $done = $TRUE
        Break
        }
    }  
}

