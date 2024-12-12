package;

import flixel.FlxG;
import flixel.util.FlxSave;

class Reg
{
	/**
	* A reference to the active playstate. Lets you call Reg.PS globally to access the playstate.
	*/
	static public var PS:PlayState;

	static public var Xscore:Int = 0;
	static public var Oscore:Int = 0;

	/**
	 * Board size storage.
	 */
	static public var boardSize:Int = 0;
	
	
	/**
	 * Safely store a new high score into the saved session, if possible.
	 */
	 static public function saveScore():Void
	{
		if ((FlxG.save.data.Xscore == null) || (FlxG.save.data.Xscore < Reg.Xscore))
			FlxG.save.data.Xscore = Reg.Xscore;
		if ((FlxG.save.data.Oscore == null) || (FlxG.save.data.Oscore < Reg.Oscore))
			FlxG.save.data.Oscore = Reg.Oscore;
		if ((FlxG.save.data.boardSize == null) || (FlxG.save.data.boardSize != Reg.boardSize))
			FlxG.save.data.boardSize = Reg.boardSize;

		// Have to do this in order for saves to work on native targets!

		FlxG.save.flush();
	}

	/**
		* Load data from the saved session.
		*
		* @return	The total points of the saved high score.
		*/
	static public function loadScore():Int
	{
		Reg.Xscore = 0;
		if ((FlxG.save.data != null) && (FlxG.save.data.Xscore != null))
			Reg.Xscore = FlxG.save.data.Xscore;

		Reg.Oscore = 0;
		if ((FlxG.save.data != null) && (FlxG.save.data.Oscore != null))
			Reg.Oscore = FlxG.save.data.Oscore;

		Reg.boardSize = 3;
		if ((FlxG.save.data != null) && (FlxG.save.data.boardSize != null))
			if(0 != FlxG.save.data.boardSize)
			Reg.boardSize = FlxG.save.data.boardSize;

		return 0;
	}

	/**
		* Wipe save data.
		*/
	static public function clearSave():Void
	{
		FlxG.save.erase();
	}
}
