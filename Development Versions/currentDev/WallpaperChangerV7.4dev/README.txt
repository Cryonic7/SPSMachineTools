SPS User Tools V1.7 includes:
WallpaperChangerV8.5
TaskViewerV1.7
TaskKillerV1.8
RunTaskV1.1

The Readme directions for each tool are below.

Wallpaper Changer for SPS systems V8.5:

	This script only changes the current wallpaper for the current user, on this PC only, IF YOU LOG INTO ANOTHER MACHINE, YOU WILL HAVE TO RUN
	THIS SCRIPT AGAIN

	ALL DESIRED WALLPAPER IMAGES MUST BE PLACED IN THE \PICTURESLIBRARY\ FOLDER TO BE ABLE TO SELECT THEM WITH THE SCRIPT,
	OTHERWISE, THE SCRIPT WILL FAIL

	WARNING:
	--------
	PLEASE DO NOT ABUSE THIS SCRIPT, this should be used only to change from the default background to a nicer background of
	your choice, not to change it to something sexually explicit or otherwise.

	DISCLAIMER:
	------------------
	WARNING: BY USING THIS SCRIPT, YOU HEREBY RELEASE THE AUTHOR AND/OR DISTRIBUTOR OR DISTRIBUTORS FROM ANY AND ALL DISCIPLINARY ACTION 
	THAT MAY RESULT FROM THE USE OF A SEXUALLY EXPLICIT, DISTRACTING, OR OTHERWISE INAPPROPRIATE WALLPAPER. IF AT ANY POINT YOU USE THIS
	SCRIPT IN ANY WAY FOR ANY MALICIOUS ACTION, YOU HEREBY TAKE FULL RESPONSIBILITY FOR ALL CONSEQUENCES INCURRED.

	IF YOU DO NOT WANT TO GET CAUGHT, AND DO NOT WANT TO GET IN TROUBLE, DO NOT USE THIS SCRIPT

	Directions:
	-----------
	1. Make sure the desired wallpaper is inside the folder "PicturesLibrary".

	2. Right click "wallpaperchanger.ps1" and click "Run with Powershell".

	3. Select [W] for WallpaperChanger.

	4. Follow the instructions and enter the filename of the wallpaper you'd like and then after that the filetype of the desired file.

	5. Confirm that it's the desired file, and if so, let the script complete.

	6. The script will now run, and change your wallpaper to that of the desired file.

	7. Enjoy your new wallpaper.

	TO SET ANOTHER, DIFFERENT WALLPAPER:
	------------------------------------
	1. Repeat previous directions

	2. ?????

	3. Profit.

End of WallpaperChanger Readme

Realtime Task and Thread Viewer for SPS Systems V1.6
	
	Fairly Self explanatory ugh i hate writing readmes

	Use this tool to view what each process or thread is doing on the machine
	It filters by unique so if you have multiple processes under one name like Chrome or whatever it'll only show one
	Use the ID printed there to plug into Task Kill if something is unresponsive or you want to kill it
	
	Good luck

Task Killer V1.4
	
	Use this tool to Kill a task
	Simply takes in one PID, found with the ID column in TaskViewer, or however else you want to do it,
	And runs taskkill with /force option on to kill whatever it is you needed to kill

	Use sparingly, this could cause instability

	Use the RunTask Command to restart something vital like Explorer.exe if you kill it on accident or whatever

RunTask V1.1

	Takes one single command or program and runs it then return to menu

	I added this solely so that if you kill explorer.exe or whatever you can restart it without having to log back in and restart

	Use Sparingly
