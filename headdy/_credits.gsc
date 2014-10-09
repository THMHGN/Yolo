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

main()
{
	level.creditTime = 6;

	headdy\_common::cleanScreen();

	thread showCredit( "Mod Created By:", 2.4 );
	wait 0.5;
	thread showCredit( "Headdy", 1.8 );
	wait 1.2;
	thread showCredit( "Additional Help:", 2.4 );
	wait 0.5;
	thread showCredit( "Wingzor", 1.8 );

    wait 1.2;
	thread showCredit( "Thanks for playing the yolo mod!", 2.4 );
	

	wait level.creditTime + 2;
}



showCredit( text, scale )
{
	end_text = newHudElem();
	end_text.font = "objective";
	end_text.fontScale = scale;
	end_text SetText(text);
	end_text.alignX = "center";
	end_text.alignY = "top";
	end_text.horzAlign = "center";
	end_text.vertAlign = "top";
	end_text.x = 0;
	end_text.y = 540;
	end_text.sort = -1; //-3
	end_text.alpha = 1;
	end_text.glowColor = (.1,.8,0);
	end_text.glowAlpha = 1;
	end_text moveOverTime(level.creditTime);
	end_text.y = -60;
	end_text.foreground = true;
	wait level.creditTime;
	end_text destroy();
}


neon()
{
	neon = addNeon( "You're playing Death Run 1.2 INDEV, leave comment at ^3headdy.org", 1.4 );
	while( 1 )
	{
		neon moveOverTime( 12 );
		neon.x = 800;
		wait 10;
		neon moveOverTime( 12 );
		neon.x = -800;
		wait 10;
	}
}

addNeon( text, scale )
{
	end_text = newHudElem();
	end_text.font = "objective";
	end_text.fontScale = scale;
	end_text SetText(text);
	end_text.alignX = "center";
	end_text.alignY = "top";
	end_text.horzAlign = "center";
	end_text.vertAlign = "top";
	end_text.x = -200;
	end_text.y = 8;
	end_text.sort = -1; //-3
	end_text.alpha = 1;
	//end_text.glowColor = (1,0,0.1);
	//end_text.glowAlpha = 1;
	end_text.foreground = true;
	return end_text;
}