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
	Some credits to: Lossy, Braxi & Wingzor. Thanks.
*/

#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

#include headdy\_common;
#include headdy\_dvar;

main()
{
	if( !isDefined( level.suiciderModel ) )
		level.suiciderModel = "com_barrel_benzin"; // Default one, lol
		
		if( !isDefined( level.mapmaker ) )
		level.mapmaker = "Unknown";


	headdy\_dvar::setupDvars(); // all dvars are there
	precache();
	headdy\_cod4stuff::main(); // setup vanilla cod4 variables --> lol
	thread headdy\_bots::addTestClients();
	thread headdy\_hostname::init();
	thread headdy\_menus::init();
	thread headdy\_killstreak::init();
	thread initScoreboard(); // Idk if it was needed to thread it.

	level.mapName = toLower( getDvar( "mapname" ) ); // Just... Coz ye
	level.tempEntity = spawn( "script_model", (0,0,0) ); // entity used to link players
	
	game["timeLeft"] = 60 * level.dvar["timeLimit"];	
	game["round"] = 0;
	game["state"] = "readyup";

	level.spawns = [];
	level.spawns["axis"] = getEntArray( "mp_yolo_suicider", "classname" );
	level.spawns["allies"] = getEntArray( "mp_yolo_soldier", "classname" ); // Spawns, if they are not yolo_suicider/soldier, fuck you and change your spawns. <3
	level.spawns["spectator"] = getEntArray( "mp_global_intermission", "classname" );

	level.wins["axis"] = 0;
	level.wins["allies"] = 0;	

	setDvar( "jump_slowdownEnable", 0 );
	
	visionSetNaked( level.mapName, 0 );

	thread timeLimit();
	thread endRound( "allies", "..." );

	if( level.dvar["music"] )
		thread music();
}


music() // Just.. I need to find some "good" sounds for this.
{
	i = 0;
	while(1)
	{
		sng = "slow_music_"+i;
		//iprintln( sng );
		ambientstop( 2 );
		ambientplay( "slow_music_"+i, 2 );
		i++;
		if( i > 7 )
			i = 0;
		wait 120 + randomInt(60);
	}
}
menus()
{
	self setClientDvar( "yolotext", "Yolo mod is made by Headdy. This mod is in beta stage. Feel free to report bugs on xfire: ^1headdygaming. ^7Thanks in advance and have fun!" );
}
initScoreboard()
{
	precacheShader( "faction_128_sas" );
	precacheShader( "killiconsuicide" );

  setdvar("g_TeamName_Allies", "^2Humans");
  setdvar("g_TeamIcon_Allies", "faction_128_sas");
  setdvar("g_TeamColor_Allies", "0 0.8 0");
  setdvar("g_ScoresColor_Allies", "1 0.203 0 1");

  setdvar("g_TeamName_Axis", "^1Suiciders");
  setdvar("g_TeamIcon_Axis", "killiconsuicide");
  setdvar("g_TeamColor_Axis", "0.8 0 0");
  setdvar("g_ScoresColor_Axis", "0 0.570 1 1" );

  setdvar("g_ScoresColor_Spectator", "0.969 0 0 1");
  setdvar("g_ScoresColor_Free", "0.621 0 0.980 1");
  setdvar("g_teamColor_MyTeam", ".6 .8 .6" );
  setdvar("g_teamColor_EnemyTeam", "1 .45 .5" );
  setdvar("cg_scoreBoardMyColor", "1 1 1 1" );
	setdvar("cg_scoreboardHeight", "350" );
	setdvar("cg_scoreboardWidth", "500" );
	setdvar("cg_scoreboardPingGraph", "1" );

}



precache()
{
	level.fx = [];
	precacheModel( "tag_origin" );
	precacheModel( "body_mp_usmc_cqb" );
	precacheModel( "fake" );
	precacheModel( level.suiciderModel );


	precacheModel( "com_flashlight_on" ); // Flashlight is for gayz.

	level.fx["embers"] = loadFx( "yolo/embers" );
	level.fx["explosion"] = loadFx( "yolo/explosion" );
	level.fx["flashlight_fake"] = loadFx( "yolo/flashlight" );
	level.fx["flashlight"] = loadFx( "yolo/flashlight2" );

	precacheItem( "brick_mp" );
	precacheItem( "colt45_mp" );
	//precacheItem( "knife_mp" );
	//precacheItem( "flashlight_mp" );

	precacheStatusIcon( "hud_status_connecting" );
	precacheStatusIcon( "hud_status_dead" );

	precacheShader( "black" );
	precacheShader( "white" );
}


playerConnect() // Called when player is connecting to server
{
	level notify( "connected", self );
	self.statusicon = "hud_status_connecting";
	
	self.guid = self getGuid();
	self.number = self getEntityNumber();
	self setClientDvar("name",self.name);
	self setClientDvar( "yolo_alive", "Survivors left: ^5" + level.alivePlayers[ "axis" ].size );
	self setClientDvar( "yolo_health", "Health: ^5" + self.health );
	
	//Tracers
	self setClientDvar( "cg_tracerspeed", "2000");
	self setClientDvar( "cg_tracerlength", "500");
	self setClientDvar( "cg_tracerwidth", "3" );
	self setClientDvar( "cg_firstPersonTracerChance", "1" );
	
	self.sessionstate = "spectator";
	self.team = "spectator";
	self.pers["team"] = "spectator";

	self.pers["score"] = 0;
	self.pers["kills"] = 0;
	self.pers["deaths"] = 0;
	self.pers["assists"] = 0;

	//self spawnSpectator();
	//self.pers["team"] = "axis";
	self spawnPlayer();////debug only !

	logPrint( "J;" + self getGuid() + ";" + self getEntityNumber() + ";" + self.name + "\n" );
	iprintln( "^1Player: ^5" + self.name +" ^7has joined the server!" );
	thread mapby();
}


playerDisconnect() // Called when player disconnect from server
{
	level notify( "disconnected", self );
	self thread cleanUp();

	logPrint( "Q;" + self getGuid() + ";" + self getEntityNumber() + ";" + self.name + "\n" );
	iprintln( "Player: " + self.name +" has left the server!" ); // No guid here, I dont like showing guids to everyone.
}


PlayerLastStand( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	self suicide();
}

PlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	if( self.sessionteam == "spectator" || game["state"] == "endmap" )
		return;

	if( isPlayer( eAttacker ) && eAttacker.pers["team"] == self.pers["team"] && eAttacker != self )
		return;

	if( eAttacker.pers["team"] == "allies" && self.pers["team"] == "axis" && sMeansOfDeath != "MOD_UNKNOWN" )
		return;

	if( !isDefined(vDir) )
		iDFlags |= level.iDFLAGS_NO_KNOCKBACK;

	if( !(iDFlags & level.iDFLAGS_NO_PROTECTION) )
	{
		if(iDamage < 1)
			iDamage = 1;

		self finishPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
	}
}

PlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	self endon( "spawned" );
	self notify( "killed_player" );
	self notify( "death" );

	if(self.sessionteam == "spectator" || game["state"] == "endmap" )
		return;

	if(sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE")
	{
		sMeansOfDeath = "MOD_HEAD_SHOT";
	}

	self thread cleanUp();

	if( game["state"] == "playing" )
	{
		obituary( self, attacker, sWeapon, sMeansOfDeath );

		self.pers["deaths"] ++;
		self.deaths = self.pers["deaths"];

		if( self.pers["team"] == "allies"  )
		{
			body = self clonePlayer( deathAnimDuration );

			if( isDefined( body ) )
			{
				if ( self isOnLadder() || self isMantling() )
					body startRagDoll();
				thread delayStartRagdoll( body, sHitLoc, vDir, sWeapon, eInflictor, sMeansOfDeath );
			}
		}
		else
		{
			if( isPlayer( attacker ) && attacker != self )
			{
				attacker setWeaponAmmoClip( self getCurrentWeapon(), 15 );
				playFx( level.fx["embers"], self.origin );
			}
		}
	}

	if( isPlayer( attacker ) && attacker != self )
	{
		attacker.pers["score"] += 10;
		attacker.score = attacker.pers["score"];
		attacker.pers["kills"]++;
		attacker.kills = attacker.pers["kills"];
	}

	self.sessionstate = "dead";
	self.statusicon = "hud_status_dead";
	//self.sessionstate =  "spectator";

	self thread respawn();
}

respawn()
{
	self endon( "disconnect" );
	self endon( "joined_spectators" );
	//self endon( "spawned" );

	wait 0.05;
	if( self.pers["team"] == "allies" && game["state"] == "playing" )
		self headdy\_teams::setTeam( "axis" );
	
	wait level.dvar["respawnDelay"];
	

	if( self.sessionstate != "playing" )
		self spawnPlayer();
}


spawnPlayer( origin, angles )
{
	self endon( "disconnect" );
	self notify("spawn");

	if( game["state"] == "endmap" ) 
		return;
		//debug("init player");
	resettimeout();

	self.team = self.pers["team"];
	self.sessionteam = self.team;
	self.sessionstate = "playing";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.statusicon = "";

	self cleanUp();

	if( isDefined( origin ) && isDefined( angles ) )
		self spawn( origin,angles );
	else
	{
		spawnPoint = level.spawns[self.pers["team"]][randomInt(level.spawns[self.pers["team"]].size)];
		self spawn( spawnPoint.origin, spawnPoint.angles );
	}

	if( self.pers["team"] == "allies" )
	{
		self setModel( "body_mp_usmc_cqb" );
		self show();

		self.pers["weapon"] = "colt45_mp";
		self giveWeapon( self.pers["weapon"] );
		self setSpawnWeapon( self.pers["weapon"] );
		self giveMaxAmmo( self.pers["weapon"] );
		 //self giveWeapon("knife_mp");
		self setClientDvar( "cg_thirdperson", 0 );
			
		//self thread flashLight();

	}
	else
	{
		self setModel( "fake" );
		self hide();
		self takeAllWeapons();
		self setClientDvar( "cg_thirdperson", 1 );
	}

	self.maxhealth = 100;
	self.health = self.maxhealth;
	self iPrintln("BETA, DO NOT RELEASE THIS!!!!!!!");

	self thread afterFrame();
	wait 10;
	self iprintln("version 0.1a, not allowed to release");
	wait 10;
	self iPrintln("test server only!!!");
}


/*flashLight()
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "joined_spectators" );
	//self endon( "disable flashlight" );
	//debug("flashlight loaded");

	if( isDefined( self.usingFlashLight ) )
	{
		self disableFlashLight();
		return;
	}
	self.usingFlashLight = true;
	


	tag = "tag_weapon_right";
	self.flashlightEnt = spawn( "script_model", (0,0,0 ) );
	self.flashlightEnt setModel( "tag_origin" );
	self.flashlightEnt hide();
	self.flashlightEnt showToPlayer( self );

	wait 0.1;
	self.fakeFlashLightFX = playFxOnTag( level.fx["flashlight_fake"], self, tag );
	playFxOnTag( level.fx["flashlight"], self.flashlightEnt, "tag_origin" );
	while( self.sessionstate == "playing" )
	{
		self.flashlightEnt.origin = self getTagOrigin( tag );
		self.flashlightEnt.angles = self getPlayerAngles();
		wait 0.05;

		if( self meleeButtonPressed() && self.usingFlashLight )
		{
			self disableFlashLight();
			//debug ("flashlight OFF changed");
			self.usingFlashLight = false;
			wait 1;
		}
		if( self meleeButtonPressed() && !self.usingFlashLight )
		{
			self startFlashLight();
			//debug ("flashlight ON changed");
			self.usingFlashLight = true;
			wait 1;
		}
	}

}

startFlashLight()
{
	if ( !isDefined( self.usingFlashLight ) )
		return;

	tag = "tag_weapon_right";
	self.flashlightEnt = spawn( "script_model", (0,0,0 ) );
	self.flashlightEnt setModel( "tag_origin" );
	self.flashlightEnt hide();
	self.flashlightEnt showToPlayer( self );

	wait 0.1;
	self.fakeFlashLightFX = playFxOnTag( level.fx["flashlight_fake"], self, tag );
	playFxOnTag( level.fx["flashlight"], self.flashlightEnt, "tag_origin" );

}

disableFlashLight()
{
	if ( !isDefined( self.usingFlashLight ) )
		return;

	self notify( "disable flashlight" );

	if( isDefined( self.fakeFlashLightFX ) )
		self.fakeFlashLightFX delete();
	if( isDefined( self.flashLightEnt ) )
	{
		self.flashLightEnt unlink();
		self.flashLightEnt hide();
		self.flashLightEnt delete();
	}

}*/



afterFrame()
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "joined_spectators" );

	wait 0.1;
	

	//self playLoopSound( "yolo" );

	self thread antiCamp();
	if( self.pers["team"] == "axis" )
	{
		self thread yolo();
		wait 0.1;

		while( self.sessionstate == "playing" )
		{
			while( !self attackButtonPressed() )
				wait 0.05;
			
			self playSound( "hind_helicopter_secondary_exp" );
			playFx( level.fx["explosion"], self.origin );
			radiusDamage( self.origin + (0,0,10), 192, 200, 70, self );
			self suicide();
		}
	}
	
		self thread bunnyHoop();
		
}

yolo()
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "joined_spectators" );

	self.modelEnt = spawn( "script_model", self.origin );
	self.modelEnt.angles = self.angles;
	self.modelEnt setModel( level.suiciderModel ); // Gives the suicider the model that was given in the map.
	self.modelEnt linkTo( self );
	self.modelEnt.yolo = false;
	self.modelEnt thread watchDamage( self );
	wait 0.05;

	oldPos = self.origin;

	while( isDefined( self.modelEnt ) && self.sessionstate == "playing" )
	{
		wait 0.2;
		
		dist = distance( oldPos, self.origin );
		if( dist >= 41 && !self.modelEnt.yolo && self getStance(1) == "stand" )
		{
			self.modelEnt playLoopSound( "yolo" );
			self.modelEnt.yolo = true;
		}
		else if( self.modelEnt.yolo && dist < 41 )
		{
			self.modelEnt stopLoopSound();
			self.modelEnt.yolo = false;
		}
		oldPos = self.origin;

	}
}

watchDamage( owner )
{
	owner endon( "disconnect" );
	owner endon( "death" );
	owner endon( "joined_spectators" );
	//self endon( "spawn_player" );

	wait 0.1;

	self setCanDamage( true );
	self.health = 1;

	while( isDefined( self ) && isDefined( owner ) && self.health > 0 )
	{
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags );
			
		//iprintln( "damage: " + damage );
		if ( !isPlayer( attacker ) || isPlayer( attacker ) && attacker.pers["team"] == owner.pers["team"] || !damage )
			continue;

		self.health -= damage;
		owner PlayerDamage( attacker, attacker, owner.health+1, 0, "MOD_UNKNOWN", "none", point, direction_vec, "none", 0 );
	}
}

spawnSpectator( origin, angles )
{
	if( !isDefined( origin ) )
		origin = level.spawns["spectator"][0].origin;
	if( !isDefined( angles ) )
		angles = level.spawns["spectator"][0].angles;

	//origin = (0,0,0);
	//angles = origin;

	self notify( "joined_spectators" );

	self headdy\_teams::setTeam( "spectator" );

	self thread cleanUp();
	resettimeout();
	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	self.statusicon = "";
	self spawn( origin, angles );
	self headdy\_teams::setSpectatePermissions();

	level notify( "player_spectator", self );
}

cleanUp()
{

	//self disableFlashLight();
	self setClientDvars( "cg_thirdperson", 0 );

	if( isDefined( self.modelEnt ) )
	{
		self.modelEnt unLink();
		if( self.modelEnt.yolo )
			self.modelEnt stopLoopSound();
		self.modelEnt delete();
		self.modelEnt = undefined;
	}
}


pickRandomSuicider()
{
	level notify( "picking suicider" );
	level endon( "picking suicider" );

	if( game["state"] != "playing" || level.numSuiciders )
		return;

	players = getAllPlayers();
	if( !isDefined( players ) || isDefined( players ) && !players.size )
		return;

	num = randomInt( players.size );
	guy = players[num];

	if( guy getEntityNumber() == getDvarInt( "last_picked_player" ) )
	{	
		if( isDefined( players[num-1] ) && isPlayer( players[num-1] ) )
			guy = players[num-1];
		else if( isDefined( players[num+1] ) && isPlayer( players[num+1] ) )
			guy = players[num+1];
	}
	
	if( !isDefined( guy ) && !isPlayer( guy ) || guy.sessionstate == "spectator" )
	{
		level thread pickRandomSuicider();
		return;
	}

	logPrint( ("First Suicider:" + guy.name + ";" + guy getGuid() ) );
	//iPrintlnBold( guy.name + " is the first ^1Suicider." );

	headdy\_hudutils::annoucement( 4, (guy.name + "^7 is the first ^1Suicider.") );
	thread headdy\_common::playSoundOnAllPlayers( "first_suicider" );


	guy thread headdy\_teams::setTeam( "axis" );
	guy spawnPlayer();
		
	setDvar( "last_picked_player", guy getEntityNumber() );
	level notify( "firstsuicider", guy );
	level.activ = guy;
	wait 0.1;
}


roundLogic()
{
	level endon( "end round" );
	level endon( "game over" );

	if( game["state"] == "endmap" )
		return;

	waitForPlayers( 2 );
	//debug("player wait bypassed");
	level notify( "round_started", game["roundsplayed"] );
	game["state"] = "playing";

	while( game["state"] == "playing" )
	{
		wait 0.1;

		level.soldiers = [];
		level.suiciders = [];

		level.numSoldiers = 0;
		level.numSuiciders = 0;

		level.totalPlayers = 0;
		level.totalPlayingPlayers = 0;

		players = getAllPlayers();

		if( players.size > 0 )
		{
			for( i = 0; i < players.size; i++ )
			{
				level.totalPlayers++;

				if( isDefined( players[i].pers["team"] ) )
				{
					level.totalPlayingPlayers ++;

					if( players[i].pers["team"] == "allies" )
					{
						level.soldiers[level.soldiers.size] = players[i];
						level.numSoldiers ++;
					}
					else if( players[i].pers["team"] == "axis" )
					{
						level.suiciders[level.suiciders.size] = players[i];
						level.numSuiciders ++;
					}
				}
			}		
		}	
			
		if( game["state"] != "playing" )
			continue;
			
		

		if( level.numSoldiers > 1 && !level.numSuiciders  )
		{
			pickRandomSuicider();
			wait 0.1;
			continue;
		}

		if( !level.numSoldiers )
		{
			thread endRound( "axis", "   " );
			break;
		}
	}
}	
timeLimit()
{
	level endon( "game over" );

	level.hud_time = newHudElem();
    level.hud_time.foreground = true;
	level.hud_time.alignX = "right";
	level.hud_time.alignY = "top";
	level.hud_time.horzAlign = "right";
    level.hud_time.vertAlign = "top";
    level.hud_time.x = 0;
    level.hud_time.y = 70;
    level.hud_time.sort = 0;
  	level.hud_time.fontScale = 3;
	level.hud_time.color = (0.8, 1.0, 0.8);
	level.hud_time.font = "objective";
	level.hud_time.glowColor = (0.3, 0.6, 0.3);
	level.hud_time.glowAlpha = 1;
 	level.hud_time.hidewheninmenu = true;

	level.hud_time setTimer( game["timeLeft"] );
	level.hud_time.alpha = 0;

	while( game["timeLeft"] >= 0 )
	{
		wait 1;
		if( game["state"] == "playing" )
		{
			game["timeLeft"] --;
		}
	}

	thread endMap();
}

mapby()
{
	level.hud_mapby = newHudElem();
    level.hud_mapby.foregmapby = true;
	level.hud_mapby.alignX = "right";
	level.hud_mapby.alignY = "bottom";
	level.hud_mapby.horzAlign = "right";
    level.hud_mapby.vertAlign = "bottom";
    level.hud_mapby.x = 0;
    level.hud_mapby.y = -45;
    level.hud_mapby.sort = 0;
  	level.hud_mapby.fontScale = 1.8;
	level.hud_mapby.color = (1, 0, 0.2);
	level.hud_mapby.font = "objective";
 	level.hud_mapby.hidewheninmenu = true;
	level.hud_mapby setText("Map by: ^5" + level.mapmaker );
} 
endRound( team, notifyText )
{
	level endon( "game over" );
	
	level notify( "end round" );

	game["state"] = "readup";

	level.hud_time.alpha = 0;
	if( game["round"] != 0 ) // to avoid respawning players in 1st round
	{
		level.wins[team] ++;


		wait 0.1;

		players = getAllPlayers();
		for( i = 0; i < players.size; i++ )
		{
			players[i] suicide();
			players[i] headdy\_teams::setTeam( "allies" );
			players[i] spawnPlayer();
		}
	}
	waitForPlayers( 2 ); // Minimum players needed to start. Change this if you want.
	if( game["round"] >= (level.dvar[ "round_limit" ]+1) )
	{
		level endMap( "Game has ended" );
		return;
	}
	game["round"] ++;
	//debug("new round");
	//headdy\_hudutils::annoucement( 9, "Round: ^3" + game["round"] + " out of ^3" + level.dvar["round_limit"] ); // In case you want to use round limits, I do prefer time. ;)
	headdy\_hudutils::annoucement( 5, "Round " + game["round"] + " begins in 5 seconds..." );
	
	wait 5;

	game["state"] = "playing";
	thread roundLogic();
	level.hud_time setTimer( game["timeLeft"] );
	level.hud_time.alpha = 1;
	

}

addTextHud( who, x, y, alpha, alignX, alignY, fontScale ) // Huh gay
{
	if( isPlayer( who ) )
		hud = newClientHudElem( who );
	else
		hud = newHudElem();

	hud.x = x;
	hud.y = y;
	hud.alpha = alpha;
	hud.alignX = alignX;
	hud.alignY = alignY;
	hud.fontScale = fontScale;
	return hud;
}


/*endMap()
{
	game["state"] = "endmap";
	level notify( "intermission" );
	level notify( "game over" );

	setDvar( "g_deadChat", 1 );
	
	level.hud_round fadeOverTime( 2.6 );
	level.hud_round.alpha = 0;
	wait 3;
	level.hud_round destroy();

	ambientstop( 0 );
	playSoundOnAllPlayers( "endmusic" );
		

	players = getAllPlayers();
	for( i = 0; i < players.size; i++ )
	{
		oldteam = players[i].pers["team"];
		players[i] spawnSpectator( level.spawns["spectator"][0].origin, level.spawns["spectator"][0].angles );
		players[i] headdy\_teams::setTeam( oldteam );
		players[i].sessionstate = "intermission";
	}
	wait .5;
	headdy\_credits::main();
	
	wait 20;
	
	//exitLevel( false );
}*/

endMap( winningteam )
{
	game["state"] = "endmap";
	level notify( "intermission" );
	level notify( "game over" );

	setDvar( "g_deadChat", 1 );

	level.hud_time fadeOverTime( 2.6 );
	level.hud_time.alpha = 0;
	wait 3;
	level.hud_time destroy();
	
	//thread saveMapScores();

	//level thread playSoundOnAllPlayers( "end_map" );

	players = getAllPlayers();
	for( i = 0; i < players.size; i++ )
	{
		players[i] closeMenu();
		players[i] closeInGameMenu();
		players[i] freezeControls( true );
		players[i] cleanUp();
	}
	wait .05;

	players = getAllPlayers();
	for( i = 0; i < players.size; i++ )
	{
		players[i] spawnSpectator( level.spawn["spectator"].origin, level.spawn["spectator"].angles );
		players[i] allowSpectateTeam( "allies", false );
		players[i] allowSpectateTeam( "axis", false );
		players[i] allowSpectateTeam( "freelook", false );
		players[i] allowSpectateTeam( "none", true );
	}

	wait 0.5;

	headdy\_credits::main();

	
	players = getAllPlayers();
	for( i = 0; i < players.size; i++ )
	{
		players[i] spawnSpectator( level.spawn["spectator"].origin, level.spawn["spectator"].angles );
		players[i].sessionstate = "intermission";
	}
	wait 5;
	
}

antiCamp()
{
	self endon( "disconnect" );
	self endon( "spawned_player" );
	self endon( "joined_spectators" );
	self endon( "death" );
	self endon( "anticamp monitor" );

	if( !level.dvar["anticamp"] || self.pers["team"] == "axis" )
		return;

	time = 0;
	oldOrigin = self.origin - (0,0,70);
	while( isAlive( self ) )
	{
		if( game["state"] != "playing" )
		{
			wait 1;
			continue;
		}


		wait 0.2;
		if( distance(oldOrigin, self.origin) <= level.dvar["ac_dist"] )
			time++;
		else
			time = 0;

		if( time == (level.dvar["ac_warn"]*5) )
		{
			self playLocalSound( "camper" );
			self iPrintlnBold( "^1Move you camper!" );
		}

		if( time == (level.dvar["ac_time"]*5) )
		{
			iPrintln( self.name + " was killed due to camping." );
			self suicide();
			break;
		}
		oldOrigin = self.origin;
	}
}
//voiceovers/US/mp/US_1mc_new_position_01_R.wav
bunnyHoop()
{
    self endon( "disconnect" );
    self endon( "spawned_player" );
    self endon( "joined_spectators" );
    self endon( "death" );

    if( !level.dvar["bunnyhoop"] )
        return;
    wait 1.5; // this is just to make sure that new players won't spawn and bunny hoop in 1st frame
    
    last = self.origin; 
    lastBH = 0;
    lastCount = 0;
    // ----- //

    while( isAlive( self ) )
    {        
		dist = distance(self.origin, last);
        last = self.origin; 
        if ( dist > 350 && lastBH && lastCount > 5)
		{
            num = self getEntityNumber();
            guid = self getGuid();
            logPrint( "LJ;" + guid + ";" + num + ";" + self.name + ";\n" );
            self iprintln("^3Lagjump? ^1DIE!");
            self suicide();
        }    
        lastBH = self.doingBH;        
        wait 0.1;
        //self setClientDvar( "com_maxfps", 250 ); //  what is this for? - Fack this, I dont want to change my FPS! FUcking bitch :s
		// ----- //

        stance = self getStance();
        useButton = self useButtonPressed();
        onGround = self isOnGround();
        fraction = bulletTrace( self getEye(), self getEye() + vector_scale(anglesToForward(self.angles), 32 ), true, self )["fraction"];
        
        // Begin
        if( !self.doingBH && useButton && !onGround && fraction == 1 )
        {
            self setClientDvars( "bg_viewKickMax", 0, "bg_viewKickMin", 0, "bg_viewKickRandom", 0, "bg_viewKickScale", 0 );
            self.doingBH = true;
            lastCount = 0;
        }

        // Accelerate
        if( self.doingBH && useButton && onGround && stance != "prone" && fraction == 1 )
        {
            lastCount++;
            if( self.bh < 120 )
                self.bh += 30;
        }

        // Finish
        if( self.doingBH && !useButton || self.doingBH && stance == "prone" || self.doingBH && fraction < 1 )
        {
            self setClientDvars( "bg_viewKickMax", 90, "bg_viewKickMin", 5, "bg_viewKickRandom", 0.4, "bg_viewKickScale", 0.2 );
            self.doingBH = false;
            self.bh = 0;
            lastCount = 0;
            continue;
        }

        // Bounce
        if( self.bh && self.doingBH && onGround && fraction == 1 )
        {
            bounceFrom = (self.origin - vector_scale( anglesToForward( self.angles ), 50 )) - (0,0,42);
            bounceFrom = vectorNormalize( self.origin - bounceFrom );
            self bounce( bounceFrom, self.bh );
            self bounce( bounceFrom, self.bh );
            wait 0.1;
        }
    }
}
statToString( stat )
{
	name = "unknown";
	switch( stat )
	{
	case "kills":
		name = "Kills";
		break;
	case "deaths":
		name = "Deaths";
		break;
	case "score":
		name = "Score";
		break;
	}
	return name;
}

advancedJumping()
{
	// NOTE! This code is extremly EXPERIMENTAL AND GLITCHY
	self endon( "disconnect" );
	self endon( "spawned_player" );
	self endon( "joined_spectators" );
	self endon( "death" );

	if( !isDefined( self.bh ) )
		self.bh = 0;

	wait 1;

	while( self isReallyAlive() )
	{
		while( self isOnGround() || self.bh ) // don't do that if we're not on the ground or we're bunny hooping
			wait 0.1;

		while( self.sessionstate == "playing" && !self isOnGround() && !self.bh )
		{	
			// @BUG: looks like player can jump forward abit longer
			//iprintln( "advanced jump: " + num );
			vec = ( self.origin + (0,0,-1) + vector_scale( anglesToForward( self.angles ), 9 ) );
			endPos = playerPhysicsTrace( self.origin, vec );
			self setOrigin( (endPos[0], endPos[1], self.origin[2] ) );
			wait 0.05;
		}
		wait 0.1; // delay before another advanced jump
	}
}

isAngleOk( angles, min, max )
{
	diff = distance( angles, self.angles );
	iprintln( "diff:" + diff );
	if( diff >= min && diff <= max )
		return true;
	return false;
}