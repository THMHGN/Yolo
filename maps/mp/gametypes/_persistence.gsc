//__/\\\______________/\\\______________________________________________________________________________________         
// _\/\\\_____________\/\\\_____________________________________________xfire:_Evilphinal________________________        
//  _\/\\\_____________\/\\\__/\\\_________________/\\\\\\\\______________________________________________________       
//   _\//\\\____/\\\____/\\\__\///___/\\/\\\\\\____/\\\////\\\__/\\\\\\\\\\\_____/\\\\\_____/\\/\\\\\\\____________      
//    __\//\\\__/\\\\\__/\\\____/\\\_\/\\\////\\\__\//\\\\\\\\\_\///////\\\/____/\\\///\\\__\/\\\/////\\\___________     
//     ___\//\\\/\\\/\\\/\\\____\/\\\_\/\\\__\//\\\__\///////\\\______/\\\/_____/\\\__\//\\\_\/\\\___\///____________    
//      ____\//\\\\\\//\\\\\_____\/\\\_\/\\\___\/\\\__/\\_____\\\____/\\\/______\//\\\__/\\\__\/\\\___________________   
//       _____\//\\\__\//\\\______\/\\\_\/\\\___\/\\\_\//\\\\\\\\___/\\\\\\\\\\\__\///\\\\\/___\/\\\___________________  
//        ______\///____\///_______\///__\///____\///___\////////___\///////////_____\/////_____\///____________________ 

init()
{
	level.persistentDataInfo = [];

	level thread onPlayerConnect();
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );

		player setClientDvar("ui_xpText", "1");
		player.enableText = true;
	}
}


statGet( dataName )
{
	if ( !level.onlineGame )
		return 0;
	
	return self getStat( int(tableLookup( "mp/playerStatsTable.csv", 1, dataName, 0 )) );
}

statSet( dataName, value )
{
	if ( !level.rankedMatch )
		return;
	
	self setStat( int(tableLookup( "mp/playerStatsTable.csv", 1, dataName, 0 )), value );	
}

statAdd( dataName, value )
{	
	if ( !level.rankedMatch )
		return;

	curValue = self getStat( int(tableLookup( "mp/playerStatsTable.csv", 1, dataName, 0 )) );
	self setStat( int(tableLookup( "mp/playerStatsTable.csv", 1, dataName, 0 )), value + curValue );
}