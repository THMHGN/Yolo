/*
YOLO (The Mod) by Headdy
Original mod maker: Braxi
Thanks to: NiNJA; Lossy
*/


#include mod\_common;
#include mod\_mod;

init()
{
	LoadMenu( "about", "mod_about" );
	LoadMenu( "main", "mod_main" );
	LoadMenu( "shop", "mod_shop" );
	LoadMenu( "stats", "mod_stats" );
	LoadMenu( "credits", "credits" );
	LoadMenu( "yolocmd", "yolocmd" );
	LoadMenu( "help", "help" );
	LoadMenu( "options", "mod_options" );
	
	precacheMenu( "scoreboard" );
	precacheMenu( "hud" );
	precacheItem( "usp_mp" );
	precacheItem( "g3_mp" );
	precacheItem( "deserteagle_mp" );
	precacheItem( "m40a3_mp" );
	
	
	while( 1 )
	{
		level waittill( "connected", player );
		
		player setClientDvars( "ui_3dwaypointtext", "1", "ui_deathicontext", "1" );
		player.enable3DWaypoints = true;
		player.enableDeathIcons = true;
		
		player thread onMenuResponse();
		player openMenu( game["menu_main"] );
	}
}

LoadMenu( scrName, menuName )
{
	game[ "menu_"+scrName ] = menuName;
	precacheMenu( game["menu_"+scrName] );
}


onMenuResponse()
{
	self endon( "disconnect" );

	self setClientDvars( "g_scriptMainMenu", game["menu_main"] );
	wait 1;
	self openMenu( game["menu_main"] );

	while( 1 )
	{
		self waittill( "menuresponse", menu, response );
		
		//iprintln( self getEntityNumber() + " menuresponse: " + menu + " '" + response +"'" );
		//tokens = strTok( response, ":" );

		if ( response == "back" )
		{
			self closeMenu();
			self closeInGameMenu();
			continue;
		}
		 else if( response == "suicide_self" )
        {
            self suicide();
        }
		else if( response == "thirdpersononoff" )
				{
					self setClientDvar( "cg_thirdperson", 1 );
				}
			else
				{
					self setClientDvar( "cg_thirdperson", 0 );
				}

		if ( response == "usp" )
		{
			//thread usp();
		}
		if ( response == "deserteagle" )
		{
			self giveweapon("deserteagle_mp");
			self givemaxammo("deserteagle_mp");
			self switchtoweapon("deserteagle_mp");
			continue;
		}
		if ( response == "g3" )
		{
			self giveweapon("g3_mp");
			self givemaxammo("g3_mp");
			self switchtoweapon("g3_mp");
			continue;
		}
		if ( response == "m40a3" )
		{
			self giveweapon("m40a3_mp");
			self givemaxammo("m40a3_mp");
			self switchtoweapon("m40a3_mp");
			continue;
		}
		
		if( menu == game["menu_main"] )
		{
			switch(response)
			{
			case "allies":
			case "axis":
			case "autoassign":
				self closeMenu();
				self closeInGameMenu();

				//self mod\_teams::setTeam( "allies" );
				//self mod\_mod::spawnPlayer();

				if( game["state"] == "endmap" )
					continue;

				if( game["state"] == "playing" )
				{
					self mod\_teams::setTeam( "axis" );
					self mod\_mod::spawnPlayer();
				}
				else
				{
					self mod\_teams::setTeam( "allies" );
					self mod\_mod::spawnPlayer();
				}
				break;

			case "spectator":
				self closeMenu();
				self closeInGameMenu();
				self mod\_teams::setTeam( "spectator" );
				self mod\_mod::spawnSpectator();
				break;
			}
		}
	}
}