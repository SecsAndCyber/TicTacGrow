package;

import flixel.FlxG;
import flixel.FlxSprite;

class Player extends FlxSprite
{
	private var _symbol:String;

	public function new(symbol, x:Float, y:Float)
	{
		super();
		switch (symbol){
			case "O":
				loadGraphic("assets/O.png");
			case "X":
				loadGraphic("assets/X.png");
		}
		setPosition(x - width /2,y - height /2);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

}
