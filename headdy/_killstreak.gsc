init() // Thanks wingie :D
{
  for(;;)
  {	 
		level waittill("connected", player);
		player thread watchscorestreak();
  }
}
watchscorestreak()
{
	self endon("disconnect");
	
	self.startscore = self.pers["score"];
	self.scorecount = 0;

	for(;;)
	{
	if(self.scorecount != self.pers["score"] - self.startscore)
	{
		self.scorecount = self.pers["score"] - self.startscore;
		switch (self.scorecount) {
			case 10:
					self giveWeapon("usp_mp");
					self switchtoweapon("usp_mp");
					self giveMaxAmmo("usp_mp");
					self iPrintln("USP debug");
				break;
			case 30:
				self giveWeapon("m40a3_mp");
				self switchtoweapon("m40a3_mp");
				self giveMaxAmmo("m40a3_mp");
				self iPrintln("M40A3 debug");
			break;
			case 4:
			break;
			case 5: 
			break;
			case 6:
			break;
			case 7:
			break;
			case 8:
			break;
			case 9:
			break;
		}
	}
	wait 1;
	}
}