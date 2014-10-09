/*
YOLO (The Mod) by Headdy
Original mod maker: Braxi
Thanks to: NiNJA; Lossy
*/


main()
{
	// setup stuff from vanila cod4
	level.splitscreen = isSplitScreen();
	level.xenon = false;
	level.ps3 = false;
	level.onlineGame = true;
	level.console = false;
	level.rankedMatch = getDvarInt( "sv_pure" );
	level.teamBased = true;
	level.oldschool = false;
	level.gameEnded = false;
}