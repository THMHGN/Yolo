main()
{
	// this is a MUST HAVE in every map script
	maps\mp\_load::main();
 
	// Set an image for mini map, please make one for your map !
	//maps\mp\_compass::setupMiniMap( "compass_map_mp_yolo_MYMAPNAME" ); Ill make one later. Too lazy.
 
	// Set Suicider model
	level.suiciderModel = "com_barrel_benzin"; 
	
	//Map maker
	level.mapmaker = "Headdy";
 
}