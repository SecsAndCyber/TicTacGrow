package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.ui.FlxSlider;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

class MenuState extends FlxState
{
	private var title:FlxText;
	private var scores:FlxText;
	private var copyright:FlxText;
	private var play:FlxButton;
	private var exit:FlxButton;
	private var reset:FlxButton;
	private var boardSlider:FlxSlider;
	private var boardSize:Int;

	override public function create():Void
	{
		Reg.loadScore();
		title = new FlxText(50,20, 0, "Tic Tac Grow", 18);
		title.alignment = CENTER;
		title.screenCenter(X);
		add(title);

		play = new FlxButton(0,0,"Play", onClickPlay);
		play.x = (FlxG.width) / 2 -(play.width / 2);
		play.y = (FlxG.height) / 2 -(play.height / 2);
		add(play);

        var boardSlider = new FlxSlider(this,"boardSize",
			play.x - 5,title.y+title.height,3,7,Std.int(play.width),5,15,0xFFFFFFFF,0xFFFFFFFF);
		boardSlider.value = Reg.boardSize;
		boardSlider.decimals = 0;
		boardSlider.nameLabel.text = "Board Size";
		boardSlider.minLabel.text = "";
		boardSlider.maxLabel.text = "";
        add(boardSlider);

		scores = new FlxText(0,play.y - play.height,0,
			"SCORE", 10);
		scores.alignment = CENTER;
		scores.screenCenter(X);
		add(scores);
		
		exit = new FlxButton(0,0,"Exit", onClickExit);
		exit.x = (FlxG.width) / 2 -(exit.width / 2);
		exit.y = play.y + play.height + 5;
		add(exit);
		
		copyright = new FlxText(50,FlxG.height-50,0, "Copyright 2024 S1air Coding", 8);
		copyright.alignment = CENTER;
		copyright.screenCenter(X);
		add(copyright);
		
		reset = new FlxButton(0,0,"Reset", onClickReset);
		reset.x = (FlxG.width) / 2 -(exit.width / 2);
		reset.y = copyright.y - copyright.height - 10;
		add(reset);

		super.create();
	}

	private function onClickPlay():Void
	{
		if(boardSize > 0)
		{
			Reg.boardSize = Std.int(boardSize);
			Reg.saveScore();
		}
		FlxG.camera.fade(FlxColor.BLACK, 0.33, () -> {FlxG.switchState(new PlayState());});
	}

	private function onClickExit():Void
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.33,
			#if cpp
			//your desktop code
			() -> {Sys.exit(0);}
			#end
		);
	}

	private function onClickReset():Void
	{
		if(reset.text == "For sure?")
		{
			Reg.clearSave();
			Reg.loadScore();
			reset.text = "Reset";
		}
		else 
		{
			reset.text = "For sure?";
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		scores.text = "X:" + Reg.Xscore + "    O:" + Reg.Oscore;
	}
}
