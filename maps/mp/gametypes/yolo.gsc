/*
YOLO (The Mod) by Headdy
Original mod maker: Braxi
Thanks to: NiNJA; Lossy
*/
main()
{
	if( getDvar( "mapname" ) == "mp_background" )
		return; // this isn't required but i'm putting it here...

	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	level.callbackStartGameType = ::Callback_StartGameType;
	level.callbackPlayerConnect = ::Callback_PlayerConnect;
	level.callbackPlayerDisconnect = ::Callback_PlayerDisconnect;
	level.callbackPlayerDamage = ::Callback_PlayerDamage;
	level.callbackPlayerKilled = ::Callback_PlayerKilled;
	level.callbackPlayerLastStand = ::Callback_PlayerLastStand;

	level.script = toLower( getDvar( "mapname" ) );
	level.gametype = toLower( getDvar( "g_gametype" ) );
	
	level.allies = ::allies;
	level.axis = ::axis;
	level.spectator = ::spectator;
}

Callback_StartGameType()
{
	if ( !isDefined( game["allies"] ) )
		game["allies"] = "marines";
	if ( !isDefined( game["axis"] ) )
		game["axis"] = "opfor";

	mod\_mod::main(); // Start the mod ^^

	allowed[0] = "war";
	maps\mp\gametypes\_gameobjects::main(allowed);	
}

dummy()
{
	waittillframeend;
	if(isdefined(self))
		level notify("connecting", self);
}


Callback_PlayerConnect()
{
	thread dummy();

	self.statusicon = "";
	self waittill("begin");
	self mod\_mod::playerConnect();
}


Callback_PlayerDisconnect()
{
	iPrintln( self.name + " ^7disconnected." );
	self mod\_mod::playerDisconnect();
}


Callback_PlayerLastStand( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	self mod\_mod::PlayerLastStand( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration );
}


Callback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime)
{
	self mod\_mod::PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
}


Callback_PlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	self mod\_mod::PlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);
}

allies(){ self mod\_teams::setTeam( "allies" ); }
axis(){ self mod\_teams::setTeam( "axis" ); }
spectator(){ self mod\_teams::setTeam( "spectator" ); }

