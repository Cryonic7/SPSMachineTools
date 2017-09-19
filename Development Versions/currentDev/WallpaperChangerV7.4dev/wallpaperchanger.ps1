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
    $title = "Wallpaper Changer and other Tools Menu, Version 7.1"
    $message = "`nThe tools included in this script are as follows:`nWallpaper Changer`n`n"
    ##options are:
    ###WallpaperChanger (COMPLETE)

    ##WebTrafficEncrypter
    ##TaskViewer


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
                Write-Host "`nYou have selected to change your wallpaper, so please input the filename of your wallpaper, and ONLY the filename without file type extension"# WARNING, the image file MUST be in BMP format or it will not work. ALSO, only type the filename, and do not at the extension, as in 'wallpaper' instead of 'wallpaper.bmp'`n"
                $filename = Read-Host -Prompt "Filename"
                Write-Host "`nPlease type the file type, such as .jpg, .bmp, .png, etc`n"
                $filetype = Read-Host -Prompt "Filetype"
                $options = [System.Management.Automation.Host.ChoiceDescription[]]($yes,$no)
                $library = ".\PicturesLibrary\"
                $title = "Is this filename correct?"
                $result = $Host.UI.PromptForChoice($title,($filename + $filetype),$options, 0)
                if (-Not (Test-Path ($library + $filename + $filetype))){
                    Write-Host "The selected file does not exist, aborting..."
                    Break
                }
                $Drive = ""
                $FileFinal = ""
                switch ($result){
                    0 {
                        $ifconverted = ""
                        Write-Host "Initiating Changes..."
                        $ifdone = $FALSE
                        if ((Test-Path H:\) -and ($ifdone -eq $FALSE)){
                            Write-Host "`nH:\ Drive exists, Writing...`n"
                            $Drive = "H:\"
                            $ifdone = $TRUE
                        }
                        if (((Test-Path C:\) -and -Not (Test-Path H:\)) -and ($ifdone -eq $FALSE)){
                            Write-Host "`nH:\ Drive does not exist, using C:\ drive ...`n"
                            $Drive = ("C:\Users\" + $env:USERNAME)
                            $ifdone = $TRUE
                        }
                        #else {
                        #    Write-Host "`nPath testing failed, aborting...`n"
                        #    $Drive = ""
                        #}

                        if ($filetype -ne ".bmp" ){
                            Write-Host "Filetype is not BMP, changing to support script...`n"
                            xcopy ($library + $filename + $filetype) ($library + $filename + "convert.bmp") /Y
                            $filetype = ".bmp"
                            $filename = ($filename + "convert")
                            $FileFinal = ($library + $filename + $filetype)
                            $ifconverted = "YES"
                            #remember to delete this file when script is done
                        }
                        if ($filetype -eq ".bmp" ){
                            Write-Host "Filetype is already BMP"
                            $FileFinal = ($library + $filename + $filetype)
                        }

                        #####currently incompatible with C drive systems

                        ### for H: drive systems, school systems
                        $fullpath = ($Drive + $filename + $filetype)
                        if (Test-Path $fullpath){
                            del $fullpath
                            xcopy ($FileFinal) $Drive /Y
                            [Wallpaper.Setter]::SetWallpaper( $fullpath, 2 )
                            del $fullpath
                        }
                        if (-Not (Test-Path $fullpath)){
                            xcopy ($FileFinal) $Drive /Y
                            [Wallpaper.Setter]::SetWallpaper( $fullpath, 2 )
                            del $fullpath
                        }
                        if ($ifconverted -ne ""){
                            del $FileFinal
                        }

                        $FileFinal = ""
                    
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

