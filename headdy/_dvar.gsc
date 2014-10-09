/*    ````       `````````````````     `````     ``````..`    ``````..``    ````   ````   
  @@@@@@@`   @@@@@@@@@@@@@@@@@@@'` #@@@@@@.  `@@@@@@@@@@@;`@@@@@@@@@@@#.@@@@@@@@@@@@@@. 
 `@@@@@@@.   @@@@@@@@@@@@@@@@@@@@.`@@@@@@@@` @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@:`
 `@+@..@@,  `@#.,.@'@,:@,......@@.,@;....@@, @@,.........'@@....+.....,@@@..#.@@,;..'@;`
 `@@,,,@@,  `@#..:@#;,.@,......@@,@@.....;@;`@@...........,@....+.......@@,...+@..,.@@, 
 `@@,,,@@,  `@#,,,@,,,:@,,,,,,,@@,@@,,,,,,@@.@@,;,,,,,,,,,,@,,,,+:,,,,,,;@@,,,,',,,:@'. 
 `@+,+,@@,` `@#,,,@,:,,@@@@@@@@@+;@:,,,,,,@@,@@;;,,@@@@';,,;,',,@@@@@,,,,@@,,,@,,,,@@:` 
 `@++':@@@@@@@#,,,@#;,,@@@@@@@@',@@,,,:,,,:@'@@,,,,@';@@,,,,,,,,@@;@@,,,,@@@,,#,,:,@@.  
 `@+;,;@@@@@@@#,,,@;':,@@@@@@@@@:@@,,,#:,,,@@@@,,,,@;.@@,,,,;,,,@@..@,,,,@@@,#,',,@@:`  
 `@+,''@,:,,;,#,,,@,+,,@,,,,,,,@'@;,,,@@,,,@@@@,,,,@;`@@,,,,,,,,@@..@,,,,@@@+@,;,:@@,   
 `@@,,:@,,,,,,#,:,@:,#:@::,,:,,@@@:,,,@@,,,,@@@,,,,@;`@@,,,,,,,,@@..@,,,,@@@@,,,,#@;`   
 `@+##'@:,:,,,#,,:@,'':@:,,,;,,@@@,,,'@@,,,,@@@+,,,@;`@@,,,,,,:,@@..@,,,,@@@@,:,:@@,    
 `@+,,:@@@@@@@@,,:@:+:,@@@@@@@@@@:,,,@@@',,,#@@,,:;@;`@@,,,,,,,@@@..@,,,,@@@;,;@'@;`    
 `@+;::@@++++@@,,:@,,''@@+++++'@@,,:,+,,,,,,,@@,:,,@;`@@,,,,,:,,@@.,@,,;,@@@,,,,@@,`    
 `@+::#@@,``.@@;;:@::::@@@@@@@@@@:;::::::::::@@::;:@@@@@:::::;::@@@@@::::@@+::::@+.     
 `@+:::@@,  `@#:::@::::@@@@@@@@@:'::@::::::::+@::::@@@@::::+::::@@@@;::::@@::::@@:`     
 `@@:::@@,  `@@:::@+::#@:::;;::#;:::@@@@@@::::@::::''::::::@:::;+:::::::@@@::::@@.      
 `@+;''@@,  `@@:::@;@@:@@:+::':#:::;@#::@@::::@::'::::::::@@::::#:;::::#@@::::@@:`      
 `@@:::@@,  `@@'::@'@':@;':#:::#::;+@:``'@::::+:::::::::'@@@;;::#:::::@@@@::::@@,       
 `@@@@@@@.  `@@@@@@@@@@@@@@@@@@@@@@@@,  .@@@@@@@@@@@@@@@@@#@@@@@@@@@@@@@@@@@@@@;`       
  `:;+@@:`   .+@@@@;;+@@@+@@@@@@@@@#:`  `,@@@@@@@@#@@@#+;,.,@@@#@@@@+;:,,@@@@@;.        
    `````     ```````````````````````    ````````````````  ````````````  ``````
	Headdy's YOLO mod.
	
	Website: 3xp-clan.com or thimohagen.nl
	
	Mod version: 0.1a
*/


setupDvars()
{
	level.dvar = [];

	RegisterDvar( "timeLimit", "yolo_timeLimit", 15, 0, 60, "int" );
	RegisterDvar( "respawnDelay", "yolo_respawnDelay", 4, 0, 60, "int" );

	RegisterDvar( "flashlight", "yolo_flashlight", 0, 0, 1, "int" );
	
	// Max rounds (0.1a)
	RegisterDvar( "round_limit", "yolo_rounds", 15, 1, 30, "int" );
	RegisterDvar( "bunnyhoop", "yolo_bh", 0, 0, 1, "int" );
	RegisterDvar( "damage_messages", "yolo_damage_message", 1, 0, 1, "int" );
	
	RegisterDvar( "dyn_hostname", "yolo_dynamic_hostname", 0, 0, 1, "int" );

	RegisterDvar( "music", "yolo_music", 1, 0, 1, "int" );

	RegisterDvar( "anticamp", "yolo_anticamp", 1, 0, 1, "int" );
	RegisterDvar( "ac_dist", "yolo_anticamp_dist", 20, 5, 256, "float" );
	RegisterDvar( "ac_warn", "yolo_anticamp_warn", 10, 5, 60, "int" );
	RegisterDvar( "ac_time", "yolo_anticamp_kill", 15, level.dvar["ac_warn"], 90, "int" );

	RegisterDvar( "bots", "yolo_numBots", 3, 0, 63, "int" );

	if( getDvar( "last_picked_player" ) == "" )
		setDvar( "last_picked_player", ("yoloownu" + randomInt(100)) );
}


// Originally from Bell's AWE mod for CoD 1
RegisterDvar( scriptName, varname, vardefault, min, max, type )
{
	if(type == "int")
	{
		if(getdvar(varname) == "")
			definition = vardefault;
		else
			definition = getdvarint(varname);
	}
	else if(type == "float")
	{
		if(getdvar(varname) == "")
			definition = vardefault;
		else
			definition = getdvarfloat(varname);
	}
	else
	{
		if(getdvar(varname) == "")
			definition = vardefault;
		else
			definition = getdvar(varname);
	}

	if((type == "int" || type == "float") && min != 0 && definition < min)
		definition = min;

	if((type == "int" || type == "float") && max != 0 && definition > max)
		definition = max;

	if(getdvar( varname ) == "")
		setdvar( varname, definition );

	level.dvar[scriptName] = definition;
//	return definition;
}
