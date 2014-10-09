/***********************************************************************************************************
 MAP VOTE PACKAGE
 ORIGINALLY MADE BY NC-17 (codam, powerserver), REWORKED BY wizard220, MODIFIED BY FrAnCkY55, Modified again by bell
 
 Modified by 0ddball
***********************************************************************************************************/
#include headdy\_mod;

init()
{
	// Map voting	

	// Setup strings
	level.mapvotetext["MapVote"]		= &"Press ^2FIRE^7 to vote                                                              Votes";
	level.mapvotetext["TimeLeft"] 		= &"Time Left: ";
	level.mapvotetext["MapVoteHeader"] 	= &"Next Map Vote";

	// Precache stuff used by map voting
	precacheString(level.mapvotetext["MapVote"]);
	precacheString(level.mapvotetext["TimeLeft"]);
	precacheString(level.mapvotetext["MapVoteHeader"]);
}

Initialise()
{
	if(!level.awe_mapvote) return;


	// Small wait
	wait .5;

	// Cleanup some stuff to free up some resources
	CleanUp();

	// Create HUD
	CreateHud();

	// Start mapvote thread	
	thread RunMapVote();

	// Wait for voting to finish
	level waittill("VotingComplete");

	// Delete HUD
	DeleteHud();
}

CreateHud()
{
	level.vote_hud_bgnd = newHudElem();
	level.vote_hud_bgnd.archived = false;
	level.vote_hud_bgnd.alpha = .7;
	level.vote_hud_bgnd.x = 185;
	level.vote_hud_bgnd.y = level.awe_mapvotehudoffset + 17;
	level.vote_hud_bgnd.sort = 9000;
	level.vote_hud_bgnd.color = (0,0,0);
	level.vote_hud_bgnd setShader("white", 300, 170);
	
	level.vote_header = newHudElem();
	level.vote_header.archived = false;
	level.vote_header.alpha = .3;
	level.vote_header.x = 188;
	level.vote_header.y = level.awe_mapvotehudoffset + 19;
	level.vote_header.sort = 9001;
	level.vote_header setShader("white", 294, 21);
	
	level.vote_headerText = newHudElem();
	level.vote_headerText.archived = false;
	level.vote_headerText.x = 200;
	level.vote_headerText.y = level.awe_mapvotehudoffset + 21;
	level.vote_headerText.sort = 9998;
	level.vote_headerText.label = level.mapvotetext["MapVoteHeader"];
	level.vote_headerText.fontscale = 1.8;

	level.vote_leftline = newHudElem();
	level.vote_leftline.archived = false;
	level.vote_leftline.alpha = .3;
	level.vote_leftline.x = 187;
	level.vote_leftline.y = level.awe_mapvotehudoffset + 19;
	level.vote_leftline.sort = 9001;
	level.vote_leftline setShader("white", 1, 165);
	
	level.vote_rightline = newHudElem();
	level.vote_rightline.archived = false;
	level.vote_rightline.alpha = .3;
	level.vote_rightline.x = 482;
	level.vote_rightline.y = level.awe_mapvotehudoffset + 19;
	level.vote_rightline.sort = 9001;
	level.vote_rightline setShader("white", 1, 165);
	
	level.vote_bottomline = newHudElem();
	level.vote_bottomline.archived = false;
	level.vote_bottomline.alpha = .3;
	level.vote_bottomline.x = 187;
	level.vote_bottomline.y = level.awe_mapvotehudoffset + 184;
	level.vote_bottomline.sort = 9001;
	level.vote_bottomline setShader("white", 296, 1);

	level.vote_hud_timeleft = newHudElem();
	level.vote_hud_timeleft.archived = false;
	level.vote_hud_timeleft.x = 410;
	level.vote_hud_timeleft.y = level.awe_mapvotehudoffset + 23;
	level.vote_hud_timeleft.sort = 9998;
	level.vote_hud_timeleft.fontscale = 1.4;
	level.vote_hud_timeleft.label = level.mapvotetext["TimeLeft"];
	level.vote_hud_timeleft setValue( level.awe_mapvotetime );	
	
	level.vote_hud_instructions = newHudElem();
	level.vote_hud_instructions.archived = false;
	level.vote_hud_instructions.x = 325;
	level.vote_hud_instructions.y = level.awe_mapvotehudoffset + 53;
	level.vote_hud_instructions.sort = 9998;
	level.vote_hud_instructions.fontscale = 1.4;
	level.vote_hud_instructions.label = level.mapvotetext["MapVote"];
	level.vote_hud_instructions.alignX = "center";
	level.vote_hud_instructions.alignY = "middle";
	
	level.vote_map1 = newHudElem();
	level.vote_map1.archived = false;
	level.vote_map1.x = 440;
	level.vote_map1.fontscale = 1.4;
	level.vote_map1.y = level.awe_mapvotehudoffset + 69;
	level.vote_map1.sort = 9998;
		
	level.vote_map2 = newHudElem();
	level.vote_map2.archived = false;
	level.vote_map2.x = 440;
	level.vote_map2.fontscale = 1.4;
	level.vote_map2.y = level.awe_mapvotehudoffset + 90;
	level.vote_map2.sort = 9998;
		
	level.vote_map3 = newHudElem();
	level.vote_map3.archived = false;
	level.vote_map3.x = 440;
	level.vote_map3.fontscale = 1.4;
	level.vote_map3.y = level.awe_mapvotehudoffset + 109;
	level.vote_map3.sort = 9998;	

	level.vote_map4 = newHudElem();
	level.vote_map4.archived = true;
	level.vote_map4.x = 440;
	level.vote_map4.fontscale = 1.4;
	level.vote_map4.y = level.awe_mapvotehudoffset + 129;
	level.vote_map4.sort = 9998;	

	level.vote_map5 = newHudElem();
	level.vote_map5.archived = false;
	level.vote_map5.x = 440;
	level.vote_map5.fontscale = 1.4;
	level.vote_map5.y = level.awe_mapvotehudoffset + 149;
	level.vote_map5.sort = 9998;	
}

RunMapVote()
{
	maps = undefined;
	x = undefined;

	currentgt = getDvar("g_gametype");
	currentmap = getdvar("mapname");
 
	if(getdvar ("awe_map_vote_gametypes") != "")
		x = GetRandomMapVoteRotation();
    else
		x = awe\_utils::GetRandomMapRotation();
				
	if(isdefined(x))
	{
		if(isdefined(x.maps))
			maps = x.maps;
		x delete();
	}

	// Any maps?
	if(!isdefined(maps))
	{
		wait 0.05;
		level notify("VotingComplete");
		return;
	}

	// Fill all alternatives with the current map in case there is not enough unique maps
	for(j=0;j<5;j++)
	{
		level.mapcandidate[j]["map"] = currentmap;
		level.mapcandidate[j]["mapname"] = "Replay this map";
		level.mapcandidate[j]["gametype"] = currentgt;
		level.mapcandidate[j]["votes"] = 0;
	}
	
	//get candidates
	i = 0;
	for(j=0;j<5;j++)
	{
		// Skip current map and gametype combination
		if(maps[i]["map"] == currentmap && maps[i]["gametype"] == currentgt)
			i++;

		// Any maps left?
		if(!isdefined(maps[i]))
			break;

		level.mapcandidate[j]["map"] = maps[i]["map"];
		level.mapcandidate[j]["mapname"] = awe\_utils::getMapName(maps[i]["map"]);
		level.mapcandidate[j]["gametype"] = maps[i]["gametype"];
		level.mapcandidate[j]["votes"] = 0;

		i++;

		// Any maps left?
		if(!isdefined(maps[i]))
			break;

		// Keep current map as last alternative?
		if(level.awe_mapvotereplay && j>2)
			break;
	}
	
	thread DisplayMapChoices();
	
	game["menu_team"] = "";

	//start a voting thread per player
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
		players[i] thread PlayerVote();
	
	thread VoteLogic();
	
	//Take a breath for players to restart with the map
	wait 0.1;	
	level.mapended = true;	
}

DeleteHud()
{
	level.vote_headerText destroy();
	level.vote_hud_timeleft destroy();	
	level.vote_hud_instructions destroy();
	level.vote_map1 destroy();
	level.vote_map2 destroy();
	level.vote_map3 destroy();
	level.vote_map4 destroy();
	level.vote_map5 destroy();
	level.vote_hud_bgnd destroy();
	level.vote_header destroy();
	level.vote_leftline destroy();
	level.vote_rightline destroy();
	level.vote_bottomline destroy();

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
		if(isdefined(players[i].vote_indicator))
			players[i].vote_indicator destroy();
}

//Displays the map candidates
DisplayMapChoices()
{
	level endon("VotingDone");
	for(;;)
	{
		iprintlnbold(level.mapcandidate[0]["mapname"] + " (" + level.mapcandidate[0]["gametype"] +")");
		iprintlnbold(level.mapcandidate[1]["mapname"] + " (" + level.mapcandidate[1]["gametype"] +")");
		iprintlnbold(level.mapcandidate[2]["mapname"] + " (" + level.mapcandidate[2]["gametype"] +")");
		iprintlnbold(level.mapcandidate[3]["mapname"] + " (" + level.mapcandidate[3]["gametype"] +")");
		iprintlnbold(level.mapcandidate[4]["mapname"] + " (" + level.mapcandidate[4]["gametype"] +")");
		wait 7.8;
	}	
}

//Changes the players vote as he hits the attack button and updates HUD
PlayerVote()
{
	level endon("VotingDone");
	self endon("disconnect");
	
	self notify ( "reset_outcome" );

	novote = false;
	
	// No voting for spectators
	if(self.pers["team"] == "spectator")
		novote = true;

	// Spawn player as spectator
	self awe\_awe_globallogic::spawnSpectator();
	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	resettimeout();
	
	//remove the scoreboard
	self setClientdvar("g_scriptMainMenu", "");
	self closeMenu();

	self allowSpectateTeam("allies", false);
	self allowSpectateTeam("axis", false);
	self allowSpectateTeam("freelook", false);
	self allowSpectateTeam("none", true);

	if(novote)
		return;

	colors[0] = (0  ,  0,  1);
	colors[1] = (0  ,0.5,  1);
	colors[2] = (0  ,  1,  1);
	colors[3] = (0  ,  1,0.5);
	colors[4] = (0  ,  1,  0);
	
	self.vote_indicator = newClientHudElem( self );
	self.vote_indicator.alignY = "middle";
	self.vote_indicator.x = 188;
	self.vote_indicator.y = level.awe_mapvotehudoffset + 60;
	self.vote_indicator.archived = false;
	self.vote_indicator.sort = 9998;
	self.vote_indicator.alpha = 0;
	self.vote_indicator.color = colors[0];
	self.vote_indicator setShader("white", 294, 17);
	
	hasVoted = false;

	for (;;)
	{
		wait .01;

		if(self attackButtonPressed() == true)
		{
			// -- Added by Number7 --
			if(!hasVoted)
			{
				self.vote_indicator.alpha = .3;
				self.votechoice = 0;
				hasVoted = true;
			}
			else
				self.votechoice++;

			if (self.votechoice == 5)
				self.votechoice = 0;

			self iprintln("You have voted for ^2" + level.mapcandidate[self.votechoice]["mapname"]);
			self.vote_indicator.y = level.awe_mapvotehudoffset + 78 + self.votechoice * 20;			
			self.vote_indicator.color = colors[self.votechoice];

			self playLocalSound("ui_mp_timer_countdown");
		}					
		while(self attackButtonPressed() == true)
			wait.01;

		self.sessionstate = "spectator";
		self.spectatorclient = -1;
	}
}

//Determines winning map and sets rotation
VoteLogic()
{
	//Vote Timer
	for ( ; level.awe_mapvotetime >= 0; level.awe_mapvotetime--)
	{
		for(j=0;j<10;j++)
		{
			// Count votes
			for(i=0;i<5;i++)	level.mapcandidate[i]["votes"] = 0;
			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
				if(isdefined(players[i].votechoice))
					level.mapcandidate[players[i].votechoice]["votes"]++;

			// Update HUD
			level.vote_map1 setValue( level.mapcandidate[0]["votes"] );
			level.vote_map2 setValue( level.mapcandidate[1]["votes"] );
			level.vote_map3 setValue( level.mapcandidate[2]["votes"] );
			level.vote_map4 setValue( level.mapcandidate[3]["votes"] );
			level.vote_map5 setValue( level.mapcandidate[4]["votes"] );
			wait .1;
		}
		
		level.vote_hud_timeleft setValue( level.awe_mapvotetime );
	}	

	wait 0.2;
	
	newmapnum = 0;
	topvotes = 0;
	for(i=0;i<5;i++)
	{
		if (level.mapcandidate[i]["votes"] > topvotes)
		{
			newmapnum = i;
			topvotes = level.mapcandidate[i]["votes"];
		}
	}

	SetMapWinner(newmapnum);
}

//change the map rotation to represent the current selection
SetMapWinner(winner)
{
	map		= level.mapcandidate[winner]["map"];
	mapname	= level.mapcandidate[winner]["mapname"];
	gametype	= level.mapcandidate[winner]["gametype"];

	setdvar("sv_maprotationcurrent", " gametype " + gametype + " map " + map);

	wait 0.1;

	// Stop threads
	level notify( "VotingDone" );

	// Wait for threads to die
	wait 0.05;

	// Announce winner
	iprintlnbold(&"AWE_BLANK");
	iprintlnbold(&"AWE_BLANK");
	iprintlnbold(&"AWE_BLANK");
	iprintlnbold(&"AWE_THE_WINNER");
	iprintlnbold("^2" + mapname);
	iprintlnbold("^2" + awe\_utils::GetGametypeName(gametype));

	// Fade HUD elements
	level.vote_headerText fadeOverTime (1);
	level.vote_hud_timeleft fadeOverTime (1);	
	level.vote_hud_instructions fadeOverTime (1);
	level.vote_map1 fadeOverTime (1);
	level.vote_map2 fadeOverTime (1);
	level.vote_map3 fadeOverTime (1);
	level.vote_map4 fadeOverTime (1);
	level.vote_map5 fadeOverTime (1);
	level.vote_hud_bgnd fadeOverTime (1);
	level.vote_header fadeOverTime (1);
	level.vote_leftline fadeOverTime (1);
	level.vote_rightline fadeOverTime (1);
	level.vote_bottomline fadeOverTime (1);

	level.vote_headerText.alpha = 0;
	level.vote_hud_timeleft.alpha = 0;	
	level.vote_hud_instructions.alpha = 0;
	level.vote_map1.alpha = 0;
	level.vote_map2.alpha = 0;
	level.vote_map3.alpha = 0;
	level.vote_map4.alpha = 0;
	level.vote_map5.alpha = 0;
	level.vote_hud_bgnd.alpha = 0;
	level.vote_header.alpha = 0;
	level.vote_leftline.alpha = 0;
	level.vote_rightline.alpha = 0;
	level.vote_bottomline.alpha = 0;

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		if(isdefined(players[i].vote_indicator))
		{
			players[i].vote_indicator fadeOverTime (1);
			players[i].vote_indicator.alpha = 0;
		}
	}

	// Show winning map for a few seconds
	wait 4;
	level notify( "VotingComplete" );
	
	level.awe_intermission_time = 5;
}

GetRandomMapVoteRotation()
{
	
	gtrotstr = getdvar("awe_map_vote_gametypes");
	gtrot_array = listOfStringsToArray(gtrotstr);
	
	// Spawn entity to hold the array
	
	x = spawn("script_origin",(0,0,0));
	x.maps = [];
	z=0;
		
	for (i=0; i<gtrot_array.size; i++)
	{
		gt=gtrot_array[i];
		gtmaprotstr = getdvar("awe_map_vote_" + gt + "_maps");
		if (isdefined(gtmaprotstr))
		{
			gtmaprot = listOfStringsToArray(gtmaprotstr);
		  
		  for (j=0; j<gtmaprot.size; j++)
		  {
		  	x.maps[z]["gametype"] = gt ;
		  	x.maps[z]["map"] = gtmaprot[j];
		  	z++;
		  }
		 }
	}

	// Shuffle the array 20 times
	for(k = 0; k < 20; k++)
	{
		for(i = 0; i < x.maps.size; i++)
		{
			j = randomInt(x.maps.size);
			element = x.maps[i];
			x.maps[i] = x.maps[j];
			x.maps[j] = element;
		}
	}


	return x;
}

listOfStringsToArray(list)
{
		
	list = awe\_utils::strip(list);
		
	j=0;
	temparr2[j] = "";	
	for(i=0;i<list.size;i++)
	{
		if(list[i]==" ")
		{
			j++;
			temparr2[j] = "";
		}
		else
			temparr2[j] += list[i];
	}

	// Remove empty elements (double spaces)
	temparr = [];
	for(i=0;i<temparr2.size;i++)
	{
		element = awe\_utils::strip(temparr2[i]);
		if(element != "")
		{
		//	if(level.awe_debug) iprintln("list" + temparr.size + ":" + element);
			temparr[temparr.size] = element;
		}
	}
	return temparr;
}


