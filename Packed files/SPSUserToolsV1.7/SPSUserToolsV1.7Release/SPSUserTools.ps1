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
Set-ExecutionPolicy -Scope CurrentUser unrestricted
cls
$done = $FALSE
while($done -eq $FALSE){
    #[console]::WindowTop
    $title = "SPS User Tools V1.7"
    $message = "`nThe tools included in this script are as follows:`nWallpaper Changer V8.4`nTaskViewer V1.6`nTaskKiller V1.4`nRuntask V1.1`n`n"
    ##options are:
    ###WallpaperChanger (COMPLETE)
    ###TaskViewer (COMPLETE)
    ###TaskKiller (COMPLETE)
    ###RunTask (COMPLETE)

    ##WebTrafficEncrypter

    #CURRENT OPTIONS BEGIN
    $WallpaperChanger = New-Object System.Management.Automation.Host.ChoiceDescription "&WallpaperChanger", `
    "Change the wallpaper or background on your computer, requires the image to be in the 'PicturesLibrary' directory"

    $TaskViewer = New-Object System.Management.Automation.Host.ChoiceDescription "&TaskViewer", `
    "View the currently running tasks in real time, sorted by process name"

    $TaskKiller = New-Object System.Management.Automation.Host.ChoiceDescription "Task&Killer", `
    "Kill a task visible from TaskViewer using its Process ID"

    $GenericRuntask = New-Object System.Management.Automation.Host.ChoiceDescription "&RunTask", `
    "Run a single task or command, such as restarting explorer if you accidentally killed it."

    $Exit = New-Object System.Management.Automation.Host.ChoiceDescription "&Exit", `
    "Exits the script safely"

    #OPTIONS END
    #AUX OPTIONS
    $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes"
    $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No"
    $blank = " "
    #UI PROMPT BEGIN
    $options = [System.Management.Automation.Host.ChoiceDescription[]]($WallpaperChanger, $TaskViewer, $TaskKiller, $GenericRuntask, $Exit)

    $result = $Host.UI.PromptForChoice($title, $message, $options, 0)
    #UI PROMPT END

    switch ($result)
    {
        #changing the wallpaper
        0 {
                $library = ".\PicturesLibrary\"
                Write-Host "`nYou have selected to change your wallpaper, so please input the full filename of your wallpaper, e.g. 'wallpaper.jpg'"
                cd $library
                Write-Host "`nCurrent available files are:"
                dir
                cd ..
                $file = Read-Host -Prompt "Filename"
                #Write-Host "`nPlease type the file type, such as .jpg, .bmp, .png, etc`n"
                #$filetype = Read-Host -Prompt "Filetype"
                if(-not $file.Contains(".")){
                Write-Host "Not a file, aborting..."
                Break
                }
                $fullfile = $file.Split(".")
                $filename = $fullfile[0]
                $filetype = "." + $fullfile[1]
                if ($fullfile[1] -eq $null -or $fullfile[1] -eq "" -or $fullfile[1].Contains(" ")){
                Write-Host "Not a file, aborting..."
                Break}
                $options = [System.Management.Automation.Host.ChoiceDescription[]]($yes,$no)
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
                            $bmptype = ".bmp"
                            
                            Add-Type -AssemblyName System.Windows.Forms
                            [System.Windows.Forms.SendKeys]::SendWait('F');
                            xcopy ($library + $filename + $filetype) ($library + $filename + "converted" + $bmptype) /Y

                            $filetype = ".bmp"
                            $filename = ($filename + "converted")
                            $FileFinal = ($library + $filename + $filetype)
                            $ifconverted = "YES"
                            #remember to delete this file when script is done
                        }
                        if ($filetype -eq ".bmp" -and $ifconverted -ne "YES"){
                            Write-Host "Filetype is already BMP"
                            $FileFinal = ($library + $filename + $filetype)
                        }

                        #####currently incompatible with C drive systems

                        ### for H: drive systems, school systems
                        $fullpath = ($Drive + $filename + $filetype)
                        if (Test-Path $fullpath){
                            del $fullpath
                            xcopy ($FileFinal) $Drive /Y
                            #robocopy $library $Drive ($filename + $filetype)
                            [Wallpaper.Setter]::SetWallpaper( $fullpath, 2 )
                            del $fullpath
                        }
                        if (-Not (Test-Path $fullpath)){
                            xcopy ($FileFinal) $Drive /Y
                            #robocopy $library $Drive ($filename + $filetype)
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
        ##TASK VIEWER
        1 {
            $options = [System.Management.Automation.Host.ChoiceDescription[]]($yes,$no)
            $title = "TaskViewer V1.2"
            $message = "`nAre you sure you want to start the task viewer? Doing so will leave this script unresponsive, only to view the current processes. If you want to use other tools or kill a task, start another instance of the SPStools script and use another menu item."
            $result = $Host.UI.PromptForChoice($title,$message,$options, 0)
            switch ($result){
                0{
                    while ($true){
                    Write-Host "Starting Viewer"
                    #$saveY = [console]::CursorTop
                    $saveY = [console]::WindowTop
                    $saveX = [console]::CursorLeft
                    cls
                    #Get-Process | Select -First 1 | Format-Table
                    while ($true) {
                        Get-Process | Sort -Unique SI,ProcessName| Where-Object -FilterScript {$_.SessionId -ne 0} | Format-Table;
                        $seconds = $seconds + 1
                        Sleep -Seconds 1;
                        [console]::setcursorposition($saveX,$saveY)
                        if($seconds -ge 10){
                            $seconds = 0
                            Break
                        }
                    } 
                    } 
                    
                }
                1{
                    Write-Host "Aborting..."
                    Break
                }
            }
        }
        #TASKVIEWER END

        #TASKKILLER START
        2 {
            Write-Host "You have selected to kill a task, using it's Process Identifier found in TaskViewer, please enter the ID now."
            $KILLPID = ""
            $KILLPID = Read-Host -Prompt "PID:"
            if ($KILLPID -eq $null -or $KILLPID -eq "" -or $KILLPID -contains " "){
                Write-Host "Input is empty or non-numerical, Aborting..."
                Break
            }          
            Write-Host "Attempting to send SIGKILL..."
            TASKKILL /PID $KILLPID /F
        }
        #TASKKILLER END
        
        #RUNTASK START
        3{
            Write-Host "This Selection runs one task or command once, It can often be used to rescue the system in case you kill Explorer.exe or other vital yet non-fatal programs."
            $RUNTASKCOMMAND = Read-Host -Prompt "Command"
            & $RUNTASKCOMMAND
        }
        #RUNTASK END

        #Exiting Script
        4 {
        Write-Host "Thank you for using a Hypersleep Developments Tool, we wish you well in the future"
        $done = $TRUE
        Break
        }
    }  
}