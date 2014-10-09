/*
YOLO (The Mod) by Headdy
Original mod maker: Braxi
Thanks to: NiNJA; Lossy
*/

setTeam( team )
{
	if( self.pers["team"] == team )
		return;

	if( isAlive( self ) )
		self suicide();
	
	self.pers["weapon"] = "none";
	self.pers["team"] = team;
	self.team = team;
	self.sessionteam = team;

	menu = game["menu_team"];
	if( team == "allies" )
		self.pers["weapon"] = "brick_mp";
	else
		self.pers["weapon"] = "none";

}

setSpectatePermissions()
{
	self allowSpectateTeam( "allies", true );
	self allowSpectateTeam( "axis", true );
	self allowSpectateTeam( "none", false );
}
