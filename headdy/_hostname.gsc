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


init()
{
	if( !level.dvar["dyn_hostname"] || getDvar( "sv_newhostname" ) == "^5Yolo 0.1 - ^7Players: ^1 $PLAYERS / $MAXPLAYERS" )
		return;

	level.dynhostname = getDvar( "sv_newhostname" );
	newhostname = undefined;

	while(1)
	{
		newhostname = GetNewHostname();
		if( isDefined( newhostname ) )
			setDvar( "sv_hostname", newhostname );
		wait 15;
	}
}

/*
Useable paramaters:

$PLAYERS			-	Amount of players
$MAXPLAYERS			-	Slots
$ROUND				-	Round Number

*/

GetNewHostname()
{
	string = level.dynhostname;
	check = strTok( "$PLAYERS;$MAXPLAYERS", ";" );
	for(i=0;i<check.size;i++)
		string = CheckString( check[i], string );

	return string;
}

CheckString( search, string )
{
	if( !isDefined( search ) || !isDefined( string ) )
		return;
	
	if( !isSubStr( string, search ) )
		return string;
	
	cont = false;
	mark = [];
	
	for(i=0;i<string.size;i++)
	{
		if( string[i] != search[0] )
			continue;
		
		mark[0] = i;
		for(ii=0;ii<search.size;ii++)
		{
			if( search[ii] != string[i+ii] )
			{
				cont = true;
				break;
			}
			mark[1] = int(i+ii)+1;
		}
		if( cont )		//we are not done yet
		{
			cont = false;
			continue;
		}
		break;
	}
	return GetSubStr( string, 0, mark[0] ) + ReplaceString( search ) + GetSubStr( string, mark[1], string.size );
}

ReplaceString( replace )
{
	if( !isDefined( replace ) )
		return;
	
	switch( replace )
	{
		case "$PLAYERS":
			players = getEntArray( "player", "classname" );
			return players.size;
		case "$MAXPLAYERS":
			return getDvarInt( "sv_maxClients" );
		case "default":
			return replace;
	}
}