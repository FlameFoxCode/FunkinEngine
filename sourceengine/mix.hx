function loadOptions():Void
	{
		if (FlxG.save.data.Music_Volume != null)
			Music_Volume = FlxG.save.data.Music_Volume;
		if (FlxG.save.data.Sound_Volume != null)
			Sound_Volume = FlxG.save.data.Sound_Volume;
		if (FlxG.save.data.Vocals_Volume != null)
			Vocals_Volume = FlxG.save.data.Vocals_Volume;
		if (FlxG.save.data.NoteOffset != null)
			OptionsMenu.NoteOffset = FlxG.save.data.NoteOffset;
		if (FlxG.save.data.ModifierSwitch != null)
			OptionsMenu.ModifierSwitch = FlxG.save.data.ModifierSwitch;
	}
} //bottom lol

switch (OptionsMenu.ModifierSwitch)
				{
					case 1:
						FlxG.switchState(new ModifiersState());
					case 0:
						if (FlxG.sound.music != null)
							FlxG.sound.music.stop();
						FlxG.switchState(new PlayState());
				} //story hx328
				
loadOptions(); //hx77