package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

class PlayState extends FlxState
{
	private var done:Int = 0;
	private var board:Board;
	private var players:Array<FlxSprite>;
	private var turn:Int = 0;
	
	override public function create():Void
	{
		super.create();

		// Keep a reference to this state in Reg for global access.

		Reg.PS = this;

		board = new Board(Reg.boardSize);
		add(board);

		players = new Array<FlxSprite>();
		turn = 1;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if(0 != done && FlxG.mouse.justPressed)
		{			
			FlxG.camera.fade(FlxColor.BLACK, 0.33, () -> {FlxG.switchState(new MenuState());});
		}

		if (0==done && FlxG.mouse.justPressed)
		{
			var location:FlxPoint = board.clicked(FlxG.mouse.getPosition().x, FlxG.mouse.getPosition().y, turn);
			if(location != null){
				var cur_player = "O";
				if(turn % 2 == 0){
					cur_player = "X";
				}
				turn += 1;

				var new_mark = new Player(cur_player, location.x, location.y);
				add(new_mark);
				players.push(new_mark);

				done = board.is_complete();
			}
			if(0 != done)
			{
				board.draw_victory(done);
			}
		}
	}
}
