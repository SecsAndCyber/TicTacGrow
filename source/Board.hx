package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import haxe.EntryPoint;

private var END_COLOR_O:FlxColor = 0xE00400FF;
private var END_COLOR_X:FlxColor = 0xE0FF0000;

class Board extends FlxSprite
{
	private var xs: Int;
	private var ys: Int;
	private var map:Array<Array<Int>>;
	private var blocks:Array<Array<FlxSprite>>;
	var start_block:FlxSprite = null;
	var end_block:FlxSprite = null;
	var end_color:FlxColor = 0x000000;

	public function new(board_size:Int = 3)
	{
		super();
		xs = board_size;
		ys = board_size;
		makeGraphic(FlxG.width, FlxG.height);
		map = [
			for (_ in 0...xs) [
				for(_ in 0...ys)
					0
			]
		];
		blocks = new Array<Array<FlxSprite>>();
		for (r in 0...xs){
			blocks[r] = new Array<FlxSprite>();
			for(c in 0...ys){
				var block = new FlxSprite(r * (FlxG.width / xs), c * (FlxG.height / ys));
				block.makeGraphic(Std.int(FlxG.width / xs), Std.int(FlxG.height / ys), FlxColor.TRANSPARENT);
				#if debug
				var t = new FlxText(block.getMidpoint().x, block.getMidpoint().y, 0, r + "," + c);
				Reg.PS.add(t);
				#end
				blocks[r][c]=block;
			}
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxSpriteUtil.fill(this, 0);		

		for (i in 1...xs){
			FlxSpriteUtil.drawLine(this,
									i * (FlxG.width / xs), 0,
									i * (FlxG.width / xs), FlxG.height, {
				thickness: 3,
				color: 0xFFFFFFFF
			});
		}

		for (i in 1...ys){
			FlxSpriteUtil.drawLine(this, 
									0, 			i * (FlxG.height / ys),
									FlxG.width, i * (FlxG.height / ys), {
				thickness: 3,
				color: 0xFFFFFFFF
			});
		}
		
		if(null != start_block){
			FlxSpriteUtil.drawLine(this, 
									start_block.getMidpoint().x, start_block.getMidpoint().y,
									end_block.getMidpoint().x  , end_block.getMidpoint().y, {
									thickness: 4,
									color: end_color
								});
		}
	}

	public function clicked(x:Float, y:Float, turn:Int)
	{
		var point:FlxPoint = new FlxPoint(x,y);
		for (r in 0...xs){
			for(c in 0...ys){
				var block:FlxSprite = blocks[r][c];
				if(block.overlapsPoint(point))
				{
					if(map[r][c] == 0){
						map[r][c] = turn;
						return block.getMidpoint();
					}
					return null;
				}
			}
		}
		return null;
	}

	public function get_game_state():Array<Array<Int>>
	{
		var gameover:Array<Int> = [for (_ in 0...1) 1];
		var rows:Array<Int> = [for (_ in 0...xs) 0];
		var columns:Array<Int> = [for (_ in 0...ys) 0];
		var diagnals:Array<Int> = [for (_ in 0...2) 0];
		// Check rows
		for (r in 0...xs){
			for(c in 0...ys){
				if(map[r][c] != 0){
					var player:Int = 2*(map[r][c] % 2) - 1;
					rows[r] += player;
					columns[c] += player;
					if(r==c){
						diagnals[0] += player;
					}
					if(r+c == xs-1){
						diagnals[1] += player;
					}
				}
				else {
					gameover[0] = 0;
				}
			}
		}
		return [gameover, rows, columns, diagnals];
	}

	public function is_complete()
	{
		var game_state:Array<Array<Int>> = get_game_state();
		var gameover:Array<Int> = game_state[0];
		var rows:Array<Int> = game_state[1];
		var columns:Array<Int> = game_state[2];
		var diagnals:Array<Int> = game_state[3];

		for (i in rows) if(Math.abs(i) == xs) return i;
		for (i in columns) if(Math.abs(i) == xs) return i;
		for (i in diagnals) if(Math.abs(i) == xs) return i;
		if(gameover[0] != 0) return 99;
		return 0;
	}

	public function draw_victory(status:Int)
	{
		var game_state:Array<Array<Int>> = get_game_state();
		var gameover:Array<Int> = game_state[0];
		var rows:Array<Int> = game_state[1];
		var columns:Array<Int> = game_state[2];
		var diagnals:Array<Int> = game_state[3];

		if(status == 99){
			trace("Stalemate");
			FlxG.camera.fade(FlxColor.BLACK, 0.75, () -> {FlxG.switchState(new MenuState());});
		}
		if(status > 0){
			end_color = END_COLOR_O;
			Reg.Oscore += 1;
		}
		if(status < 0){
			end_color = END_COLOR_X;
			Reg.Xscore += 1;
		}
		Reg.saveScore();
		if(Math.abs(diagnals[0]) == xs){
			start_block = blocks[0][0];
			end_block = blocks[xs-1][ys-1];
			return;
		}
		if(Math.abs(diagnals[1]) == xs){
			start_block = blocks[0][ys-1];
			end_block = blocks[xs-1][0];
			return;
		}
		
		for (r in 0...xs){
			if(Math.abs(rows[r]) == xs){
				start_block = blocks[r][0];
				end_block = blocks[r][ys-1];
				return;
			}
		}
		for(c in 0...ys){
			if(Math.abs(columns[c]) == xs){
				start_block = blocks[0][c];
				end_block = blocks[xs-1][c];
				return;
			}
		}
	}
}
