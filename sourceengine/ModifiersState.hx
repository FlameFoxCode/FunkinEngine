package;

import flixel.text.FlxText;
import flixel.FlxObject;
import flixel.effects.FlxFlicker;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;

using StringTools;

class ModifiersState extends MusicBeatState
{

    var ModiWindow:FlxSprite;
    var BG1:FlxSprite;

    var menuItems:FlxTypedGroup<FlxSprite>;
    var optionShit:Array<String> = ['Practice', 'Perfect', 'Lights Out','Fast Notes', 'Inv Notes', 'Snake Notes', 'Drunk Notes', 'Accel Notes', 'Vnsh Notes', 'Flip Notes', 'Eel Notes', 'Seasick', 'Clean', 'Play'];
	 
    var songs:Array<Dynamic> = [ 
        ['Practice'],
        ['Perfect'],
        ['Lights Out'],
        ['Fast Notes'],
        ['Inv Notes'],
        ['Snake Notes'],
        ['Drunk Notes'],
        ['Accel Notes'],
        ['Vnsh Notes'],
        ['Flip Notes'],
        ['Eel Notes'],
        ['Seasick'],
		['Clean'],
		['Play']
    ];
    private var grpSongs:FlxTypedGroup<Alphabet>;
    var selectedSomethin:Bool = false;
    var curSelected:Int = 0;
    var camFollow:FlxObject;

    public static var Practice_Selected:Int = 1; //1 = unactivated, 0 = activated
    public static var FastNotes_Selected:Float = 0; //0 = unactivated, 0.5 = activated
    public static var Perfect_Selected:Int = 1; //0 = unactivated, 1 = activated
    public static var InvNotes_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var DrunkNotes_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var SnakeNotes_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var AccelNotes_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var LightsOut_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var VnshNotes_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var FlipNotes_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var Seasick_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var EelNotes_Selected:Float = 1; //0 = unactivated, 1 = activated


    public static var ScoreRate:Float = 1;
    public static var ScoreMultiplier:Float = 1;
    public static var NoteSpeed:Float = 1; //1 = normal speed, 1.6 = fast speed, 0.6 = slow speed
    public static var NoteAccel:Float = 0; //1 = normal speed, 1.5 = fast speed, 0.5 = slow speed  
	public static var ZoneOffset:Float = 1;
	
    public static var CheckmarkPractice:Bool = false;
    public static var CheckmarkFastNotes:Bool = false;
    public static var CheckmarkPerfect:Bool = false;
    public static var CheckmarkInvNotes:Bool = false;
    public static var CheckmarkSnakeNotes:Bool = false;
    public static var CheckmarkDrunkNotes:Bool = false;
    public static var CheckmarkAccelNotes:Bool = false;
    public static var CheckmarkLightsOut:Bool = false;
    public static var CheckmarkVnshNotes:Bool = false;
    public static var CheckmarkFlipNotes:Bool = false;
    public static var CheckmarkSeasick:Bool = false;
    public static var CheckmarkEelNotes:Bool = false;

    var RateText:FlxText = new FlxText(20, 565, FlxG.width, "SCORE RATE:\n"+ScoreMultiplier+"x", 48);
    var ExplainText:FlxText = new FlxText(20, 132, FlxG.width, " ", 48);

    var Checkmark_Practice:FlxSprite = new FlxSprite(605, 66).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_Perfect:FlxSprite = new FlxSprite(605, 386).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_LightsOut:FlxSprite = new FlxSprite(605, 546).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_FastNotes:FlxSprite = new FlxSprite(605, 2786).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_InvNotes:FlxSprite = new FlxSprite(605, 2946).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_SnakeNotes:FlxSprite = new FlxSprite(605, 3106).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_DrunkNotes:FlxSprite = new FlxSprite(605, 3266).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_AccelNotes:FlxSprite = new FlxSprite(605, 3426).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_VnshNotes:FlxSprite = new FlxSprite(605, 3586).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_FlipNotes:FlxSprite = new FlxSprite(605, 3746).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_Seasick:FlxSprite = new FlxSprite(605, 4066).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_EelNotes:FlxSprite = new FlxSprite(605, 4706).loadGraphic('assets/images/Checkmark.png');

    override function create()
    {

        persistentUpdate = persistentDraw = true;

        if (FlxG.sound.music != null)
        {
            if (!FlxG.sound.music.playing)
                FlxG.sound.playMusic('assets/music/freakyMenu' + TitleState.soundExt, TitleState.Music_Volume/100);
        }
		
        var menuBG:FlxSprite = new FlxSprite().loadGraphic('assets/images/menuBG.png');
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		menuBG.scrollFactor.x = 0;
		menuBG.scrollFactor.y = 0.1;
		add(menuBG);

		menuItems = new FlxTypedGroup<FlxSprite>();
        add(menuItems);
		
		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(580, 30 + (i * 160));
            menuItem.animation.addByPrefix('Idle', " Idle", 24, true);
            menuItem.animation.addByPrefix('Select', " Select", 24, true);
			menuItem.animation.play('Idle');
			menuItem.ID = i;
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
            menuItem.antialiasing = false;
            menuItem.scrollFactor.x = 0;
            menuItem.scrollFactor.y = 1;
		}
		
        grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (160 * i) + 66, songs[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);
            songText.x = 740;
            songText.scrollFactor.x = 0;
            songText.scrollFactor.y = 1;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
        }

		add(RateText);
        RateText.scrollFactor.x = 0;
        RateText.scrollFactor.y = 0;
        RateText.setFormat("VCR OSD Mono", 28, FlxColor.WHITE, CENTER);
        RateText.x = -350;
        RateText.setBorderStyle(OUTLINE_FAST, 0xFF000000, 2, 0.5);

        add(ExplainText);
        ExplainText.scrollFactor.x = 0;
        ExplainText.scrollFactor.y = 0;
        ExplainText.setFormat("VCR OSD Mono", 30, FlxColor.WHITE, CENTER);
        ExplainText.x = -355;
        ExplainText.setBorderStyle(OUTLINE_FAST, 0xFF000000, 2, 0.5);

        camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

        FlxG.camera.follow(camFollow, null, 0.06);
        
        changeItem();

        CreateCheckmark();

        PositionCheckmark();

        LoadModifiers();

        UpdateCheckmark();

        UpdateScorerate();

		super.create();
        
    }

    function CreateCheckmark():Void
    {
        add(Checkmark_Practice);
        Checkmark_Practice.scrollFactor.set(0, 1);
        add(Checkmark_FastNotes);
        Checkmark_FastNotes.scrollFactor.set(0, 1);
        add(Checkmark_Perfect);
        Checkmark_Perfect.scrollFactor.set(0, 1);
        add(Checkmark_InvNotes);
        Checkmark_InvNotes.scrollFactor.set(0, 1);
        add(Checkmark_DrunkNotes);
        Checkmark_DrunkNotes.scrollFactor.set(0, 1);
        add(Checkmark_SnakeNotes);
        Checkmark_SnakeNotes.scrollFactor.set(0, 1);
        add(Checkmark_AccelNotes);
        Checkmark_AccelNotes.scrollFactor.set(0, 1);
        add(Checkmark_LightsOut);
        Checkmark_LightsOut.scrollFactor.set(0, 1);
        add(Checkmark_VnshNotes);
        Checkmark_VnshNotes.scrollFactor.set(0, 1);
        add(Checkmark_FlipNotes);
        Checkmark_FlipNotes.scrollFactor.set(0, 1);
        add(Checkmark_Seasick);
        Checkmark_Seasick.scrollFactor.set(0, 1);
        add(Checkmark_EelNotes);
        Checkmark_EelNotes.scrollFactor.set(0, 1);
    }

    function PositionCheckmark():Void //this is a much better method of positioning them
    {
        Checkmark_Practice.y = Checkmark_Perfect.y + 66;
        Checkmark_Perfect.y = Checkmark_LightsOut.y+ 160;
        Checkmark_LightsOut.y = Checkmark_Perfect.y+ 160;
        Checkmark_FastNotes.y = Checkmark_InvNotes.y+ 160;
        Checkmark_InvNotes.y = Checkmark_FastNotes.y+ 160;
        Checkmark_SnakeNotes.y = Checkmark_InvNotes.y+ 160;
        Checkmark_DrunkNotes.y = Checkmark_SnakeNotes.y+ 160;
        Checkmark_AccelNotes.y = Checkmark_DrunkNotes.y+ 160;
        Checkmark_VnshNotes.y = Checkmark_AccelNotes.y+ 160;
        Checkmark_FlipNotes.y = Checkmark_VnshNotes.y+ 160;
        Checkmark_EelNotes.y = Checkmark_FlipNotes.y+ 160;
        Checkmark_Seasick.y = Checkmark_EelNotes.y+ 160;
    }

    function UpdateScorerate():Void
    {
        ScoreRate = (1+LightsOut_Selected+FastNotes_Selected+InvNotes_Selected+SnakeNotes_Selected+DrunkNotes_Selected+AccelNotes_Selected+VnshNotes_Selected+FlipNotes_Selected+Seasick_Selected)*Perfect_Selected*Practice_Selected*EelNotes_Selected;
        ScoreMultiplier = ScoreRate;

        if (ScoreMultiplier <= 0.1)
            switch (CheckmarkPractice||CheckmarkEelNotes)
            {
                case true:
                    ScoreMultiplier = 0;
                case false:
                    ScoreMultiplier = 0.1;
            }


        RateText.text = "SCORE RATE:\n"+ScoreMultiplier+"x";
    }

    function UpdateCheckmark():Void
    {

        switch (CheckmarkPractice)
                {
                    case true:
                        Checkmark_Practice.visible = true;
                    case false:
                        Checkmark_Practice.visible = false;
                }

                switch (CheckmarkFastNotes)
                {
                    case true:
                        Checkmark_FastNotes.visible = true;
                    case false:
                        Checkmark_FastNotes.visible = false;
                }

                switch (CheckmarkPerfect)
                {
                    case true:
                        Checkmark_Perfect.visible = true;
                    case false:
                        Checkmark_Perfect.visible = false;
                }

                switch (CheckmarkInvNotes)
                {
                    case true:
                        Checkmark_InvNotes.visible = true;
                    case false:
                        Checkmark_InvNotes.visible = false;
                }

                switch (CheckmarkDrunkNotes)
                {
                    case true:
                        Checkmark_DrunkNotes.visible = true;
                    case false:
                        Checkmark_DrunkNotes.visible = false;
                }
                switch (CheckmarkSnakeNotes)
                {
                    case true:
                        Checkmark_SnakeNotes.visible = true;
                    case false:
                        Checkmark_SnakeNotes.visible = false;
                }
                switch (CheckmarkAccelNotes)
                {
                    case true:
                        Checkmark_AccelNotes.visible = true;
                    case false:
                        Checkmark_AccelNotes.visible = false;
                }
                switch (CheckmarkLightsOut)
                {
                    case true:
                        Checkmark_LightsOut.visible = true;
                    case false:
                        Checkmark_LightsOut.visible = false;
                }
            
                switch (CheckmarkVnshNotes)
                {
                    case true:
                        Checkmark_VnshNotes.visible = true;
                    case false:
                        Checkmark_VnshNotes.visible = false;
                }
                                         
                switch (CheckmarkSeasick)
                {
                    case true:
                        Checkmark_Seasick.visible = true;
                    case false:
                        Checkmark_Seasick.visible = false;
                }
                switch (CheckmarkFlipNotes)
                {
                    case true:
                        Checkmark_FlipNotes.visible = true;
                    case false:
                        Checkmark_FlipNotes.visible = false;
                }
                switch (CheckmarkEelNotes)
                {
                    case true:
                        Checkmark_EelNotes.visible = true;
                    case false:
                        Checkmark_EelNotes.visible = false;
                }
    }

    override function update(elapsed:Float)
        {
            if (!selectedSomethin)
                {
                    if (controls.UP_P)
                    {
                        FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt, TitleState.Sound_Volume/100);
                        changeItem(-1);
                    }
        
                    if (controls.DOWN_P)
                    {
                        FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt, TitleState.Sound_Volume/100);
                        changeItem(1);
                    }
                }
            if (controls.BACK)
                {
                    FlxG.sound.play('assets/sounds/cancelMenu' + TitleState.soundExt, TitleState.Sound_Volume/100);
                    if (PlayState.isStoryMode)
                        FlxG.switchState(new StoryMenuState());
                    else
                        FlxG.switchState(new FreeplayState());
                }
            if (controls.ACCEPT)
            {
                if (optionShit[curSelected] == 'Play')
                {
                    selectedSomethin = true;
                    FlxG.sound.play('assets/sounds/confirmMenu' + TitleState.soundExt, TitleState.Sound_Volume/100);
                    new FlxTimer().start(1, function(tmr:FlxTimer)
                        {
                            if (FlxG.sound.music != null)
                              FlxG.sound.music.stop();
                          FlxG.switchState(new PlayState());
                      });
                }
                else if (optionShit[curSelected] == 'Clean')
                {
                    FlxG.sound.play('assets/sounds/cancelMenu' + TitleState.soundExt, TitleState.Sound_Volume/100);
                    ClearModifiers();

                    SaveModifiers();

                    UpdateScorerate();

                    UpdateCheckmark();
                }
                else
                    FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt, TitleState.Sound_Volume/100);
                    switch (optionShit[curSelected]) 
					{
                        case 'Practice':

                            switch (Practice_Selected)
                            {
                                case 1:
                                    Practice_Selected = 0;
                                    CheckmarkPractice = true;
                                    CheckmarkPerfect = false;
                                    Perfect_Selected = 1;
                                case 0:
                                    Practice_Selected = 1;
                                    CheckmarkPractice = false;
                            }
                        case 'Fast Notes':

                            switch (FastNotes_Selected)
                            {
                                case 0:
                                    FastNotes_Selected = 0.9;
                                    NoteSpeed = 1.7;
                                    CheckmarkFastNotes = true;
                                case 0.9:
                                    FastNotes_Selected = 0;
                                    NoteSpeed = 1;
                                    CheckmarkFastNotes = false;
                            }
                        case 'Perfect':

                            switch (Perfect_Selected)
                            {
                                case 1:
                                    Perfect_Selected = 4;
                                    CheckmarkPerfect = true;
                                    CheckmarkPractice = false;
                                    Practice_Selected = 1;
                                case 4:
                                    Perfect_Selected = 1;
                                    CheckmarkPerfect = false;
                            }
                        case 'Inv Notes':

                        switch (InvNotes_Selected)
                        {
                            case 0:
                                InvNotes_Selected = 1.5;
                                CheckmarkInvNotes = true;
                                SnakeNotes_Selected = 0;
                                CheckmarkSnakeNotes = false;
                                VnshNotes_Selected = 0;
                                CheckmarkVnshNotes = false;
                            case 1.5:
                                InvNotes_Selected = 0;
                                CheckmarkInvNotes = false;
                        }
                        case 'Snake Notes':

                            switch (SnakeNotes_Selected)
                            {
                                case 0:
                                    SnakeNotes_Selected = 0.7;
                                    CheckmarkSnakeNotes = true;
                                    CheckmarkInvNotes = false;
                                    InvNotes_Selected = 0;
                                case 0.7:
                                    SnakeNotes_Selected = 0;
                                    CheckmarkSnakeNotes = false;
                            }
                        case 'Drunk Notes':

                            switch (DrunkNotes_Selected)
                            {
                                case 0:
                                    DrunkNotes_Selected = 0.7;
                                    CheckmarkDrunkNotes = true;
                                case 0.7:
                                    DrunkNotes_Selected = 0;
                                    CheckmarkDrunkNotes = false;
                            }
                        case 'Accel Notes':
    
                            switch (AccelNotes_Selected)
                            {
                                case 0:
                                    AccelNotes_Selected = 0.6;
                                    CheckmarkAccelNotes = true;
                                case 0.6:
                                    AccelNotes_Selected = 0;
                                    CheckmarkAccelNotes = false;
                            }
                        case 'Lights Out':
    
                            switch (LightsOut_Selected)
                            {
                                case 0:
                                    LightsOut_Selected = 0.5;
                                    CheckmarkLightsOut = true;
                                case 0.5:
                                    LightsOut_Selected = 0;
                                    CheckmarkLightsOut = false;
                            }
                        case 'Vnsh Notes':
    
                               switch (VnshNotes_Selected)
                            {
                                case 0:
                                    VnshNotes_Selected = 0.6;
                                    CheckmarkVnshNotes = true;
                                    InvNotes_Selected = 0;
                                    CheckmarkInvNotes = false;
                                case 0.6:
                                    VnshNotes_Selected = 0;
                                    CheckmarkVnshNotes = false;
                            }
                        case 'Flip Notes':

                            switch (FlipNotes_Selected)
                            {
                                case 0:
                                    FlipNotes_Selected = 0.5;
                                    CheckmarkFlipNotes = true;
                                case 0.5:
                                    FlipNotes_Selected = 0;
                                    CheckmarkFlipNotes = false;
                            }
                        case 'Seasick':

                            switch (Seasick_Selected)
                            {
                                case 0:
                                    Seasick_Selected = 0.4;
                                    CheckmarkSeasick = true;
                                case 0.4:
                                    Seasick_Selected = 0;
                                    CheckmarkSeasick = false;
                            }
                        case 'Eel Notes':

                            switch (EelNotes_Selected)
                            {
                                case 1:
                                    EelNotes_Selected = 0;
                                    CheckmarkEelNotes = true;
                                case 0:
                                    EelNotes_Selected = 1;
                                    CheckmarkEelNotes = false;
                            }
                    }
                SaveModifiers();

                UpdateScorerate();

                UpdateCheckmark();
            }			
        }

        public static function SaveModifiers():Void
        {
            FlxG.save.data.Practice_Selected = Practice_Selected;
            FlxG.save.data.FastNotes_Selected = FastNotes_Selected;
            FlxG.save.data.Perfect_Selected = Perfect_Selected;
            FlxG.save.data.InvNotes_Selected = InvNotes_Selected;
            FlxG.save.data.SnakeNotes_Selected = SnakeNotes_Selected;
            FlxG.save.data.DrunkNotes_Selected = DrunkNotes_Selected;
            FlxG.save.data.AccelNotes_Selected = AccelNotes_Selected;
            FlxG.save.data.LightsOut_Selected = LightsOut_Selected;
            FlxG.save.data.VnshNotes_Selected = VnshNotes_Selected;
            FlxG.save.data.FlipNotes_Selected = FlipNotes_Selected;
            FlxG.save.data.Seasick_Selected = Seasick_Selected;
            FlxG.save.data.EelNotes_Selected = EelNotes_Selected;

            FlxG.save.flush();
        }

        function LoadModifiers():Void
            {
                if (FlxG.save.data.Practice_Selected != null)
                    Practice_Selected = FlxG.save.data.Practice_Selected;
                if (FlxG.save.data.FastNotes_Selected != null)
                    FastNotes_Selected = FlxG.save.data.FastNotes_Selected;
                if (FlxG.save.data.Perfect_Selected != null)
                    Perfect_Selected = FlxG.save.data.Perfect_Selected;
                if (FlxG.save.data.InvNotes_Selected != null)
                    InvNotes_Selected = FlxG.save.data.InvNotes_Selected;
                if (FlxG.save.data.SnakeNotes_Selected != null)
                    SnakeNotes_Selected = FlxG.save.data.SnakeNotes_Selected;
                if (FlxG.save.data.DrunkNotes_Selected != null)
                    DrunkNotes_Selected = FlxG.save.data.DrunkNotes_Selected;
                if (FlxG.save.data.AccelNotes_Selected != null)
                    AccelNotes_Selected = FlxG.save.data.AccelNotes_Selected;
                if (FlxG.save.data.LightsOut_Selected != null)
                    LightsOut_Selected = FlxG.save.data.LightsOut_Selected;
                if (FlxG.save.data.VnshNotes_Selected != null)
                    VnshNotes_Selected = FlxG.save.data.VnshNotes_Selected;
                if (FlxG.save.data.FlipNotes_Selected != null)
                    FlipNotes_Selected = FlxG.save.data.FlipNotes_Selected;
                if (FlxG.save.data.Seasick_Selected != null)
                    Seasick_Selected = FlxG.save.data.Seasick_Selected;
                if (FlxG.save.data.EelNotes_Selected != null)
                    EelNotes_Selected = FlxG.save.data.EelNotes_Selected;
					
                switch (Practice_Selected)
                {
                    case 0:
                        CheckmarkPractice = true;
                    case 1:
                        CheckmarkPractice = false;
                }

                switch (FastNotes_Selected)
                {
                    case 0.9:
                        CheckmarkFastNotes = true;
                        NoteSpeed = 1.7;
                    case 0:
                        CheckmarkFastNotes = false;
                }

                switch (Perfect_Selected)
                {
                    case 4:
                        CheckmarkPerfect = true;
                    case 1:
                        CheckmarkPerfect = false;
                }

                switch (InvNotes_Selected)
                {
                    case 1.5:
                        CheckmarkInvNotes = true;
                    case 0:
                        CheckmarkInvNotes = false;
                }

                switch (DrunkNotes_Selected)
                {
                    case 0.7:
                        CheckmarkDrunkNotes = true;
                    case 0:
                        CheckmarkDrunkNotes = false;
                }
				
                switch (SnakeNotes_Selected)
                {
                    case 0.7:
                        CheckmarkSnakeNotes = true;
                    case 0:
                        CheckmarkSnakeNotes = false;
                }
				
                switch (AccelNotes_Selected)
                {
                    case 0.6:
                        CheckmarkAccelNotes = true;
                    case 0:
                        CheckmarkAccelNotes = false;
                }

                switch (LightsOut_Selected)
                {
                    case 0.5:
                        CheckmarkLightsOut = true;
                    case 0:
                        CheckmarkLightsOut = false;
                }

                switch (VnshNotes_Selected)
                {
                    case 0.6:
                        CheckmarkVnshNotes = true;
                    case 0:
                        CheckmarkVnshNotes = false;
                }
                                         
                switch (Seasick_Selected)
                {
                    case 0.4:
                        CheckmarkSeasick = true;
                    case 0:
                        CheckmarkSeasick = false;
                }
                switch (FlipNotes_Selected)
                {
                    case 0.5:
                        CheckmarkFlipNotes = true;
                    case 0:
                        CheckmarkFlipNotes = false;
                }
                switch (EelNotes_Selected)
                {
                    case 0:
                        CheckmarkEelNotes = true;
                    case 1:
                        CheckmarkEelNotes = false;
                }
            }

        public static function ClearModifiers():Void
        {
            Practice_Selected = 1;
            CheckmarkPractice = false;
            FastNotes_Selected = 0;
            NoteSpeed = 1;
            CheckmarkFastNotes = false;
            Perfect_Selected = 1;
            CheckmarkPerfect = false;
            InvNotes_Selected = 0;
            CheckmarkInvNotes = false;
            SnakeNotes_Selected = 0;
            CheckmarkSnakeNotes = false;
            DrunkNotes_Selected = 0;
            CheckmarkDrunkNotes = false;
            AccelNotes_Selected = 0;
            CheckmarkAccelNotes = false;
            LightsOut_Selected = 0;
            CheckmarkLightsOut = false;
            VnshNotes_Selected = 0;
            CheckmarkVnshNotes = false;
            FlipNotes_Selected = 0;
            CheckmarkFlipNotes = false;
            Seasick_Selected = 0;
            CheckmarkSeasick = false;
            EelNotes_Selected = 1;
            CheckmarkEelNotes = false;
        }

		function changeItem(huh:Int = 0)
            {
				curSelected += huh;
        
                if (curSelected >= menuItems.length)
                    curSelected = 0;
                if (curSelected < 0)
                    curSelected = menuItems.length - 1;
					
                switch (optionShit[curSelected]) 
                {
                    case 'Practice':
                        ExplainText.text = "PRACTICE MODE\n\n\n"
                        +"PRACTICE YOUR SONGS\n"
                        +"IN ANY DIFFICULTY\n"
                        +"AND ANY MODIFIER.\n"
                        +"YOUR HEALTH WON'T\n"
                        +"DECREASE IN THE\n"
                        +"PROCESS.\n\n"
                        +"SCORE RATE DROPS TO\n"
                        +"0x!";
                    case 'Fast Notes':
                        ExplainText.text = "FAST NOTES\n\n\n"
                        +"NOTES WILL GO\n"
                        +"FASTER THAN THEY\n"
                        +"USUALLY DO.\n"
                        +"WATCH OUT FOR THEM.\n"
                        +"\n"
                        +"\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"0.9x!";
                    case 'Perfect':
                        ExplainText.text = "PERFECT\n\n\n"
                        +"IT SEEMS AS IF\n"
                        +"NOTES BECAME WAY\n"
                        +"MORE DANGEROUS.\n"
                        +"MISS ONLY ONCE AND\n"
                        +"YOU LOSE.\n"
                        +"\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"4x THE CURRENT RATE!";
                    case 'Inv Notes':
                        ExplainText.text = "INVISIBLE NOTES\n\n\n"
                        +"IN THIS ONE THE\n"
                        +"NOTES BECOME FULL ON\n"
                        +"INVISIBLE.\n"
                        +"MEMORY IS REQUIRED\n"
                        +"FOR THIS.\n"
                        +"\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"1.5x!";
                    case 'Snake Notes':
                        ExplainText.text = "SNAKE NOTES\n\n\n"
                        +"NOTES WILL GO LIKE\n"
                        +"SNAKES, GOING\n"
                        +"SIDEWAYS AT ALL\n"
                        +"TIMES. DON'T LET\n"
                        +"THAT WORRY YOU.\n"
                        +"\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"0.7x!";
                    case 'Drunk Notes':
                        ExplainText.text = "DRUNK NOTES\n\n\n"
                        +"NOTES DON'T SEEM,\n"
                        +"TO BE ABLE TO THINK\n"
                        +"STRAIGHT AND GO\n"
                        +"FASTER AND SLOWER.\n"
                        +"\n"
                        +"\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"0.7x!";
                    case 'Accel Notes':
                        ExplainText.text = "ACCELERATING NOTES\n\n\n"
                        +"NOTES START TO\n"
                        +"ACCELERATE AS IF\n"
                        +"THEY WERE RACE\n"
                        +"CARS. WATCH OUT\n"
                        +"FOR THEM.\n"
                        +"\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"0.6x!";
                    case 'Lights Out':
                        ExplainText.text = "LIGHTS OUT\n\n\n"
                        +"IT SEEMS THAT THE\n"
                        +"LIGHTS HAVE\n"
                        +"TURNED OFF. IT'S\n"
                        +"EXTREMELY DARK\n"
                        +"IN THERE.\n"
                        +"\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"0.5x!";
                    case 'Vnsh Notes':
                        ExplainText.text = "VANISHING NOTES\n\n\n"
                        +"THE NOTES WANT TO\n"
                        +"PEACE OUT SO HARD\n"
                        +"THAT THEY START\n"
                        +"DISAPPEARING. PAY\n"
                        +"ATTENTION.\n"
                        +"\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"0.6x!";
                    case 'Flip Notes':
                        ExplainText.text = "FLIPPED NOTES\n\n\n"
                        +"NOTES SEEM TO\n"
                        +"BE FLIPPED ON\n"
                        +"THEIR OWN HEADS.\n"
                        +"DON'T GET REALLY\n"
                        +"CONFUSED.\n"
                        +"\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"0.5x!";
                    case 'Seasick':
                        ExplainText.text = "SEASICK\n\n\n"
                        +"EVERYONE IS\n"
                        +"SUDDENLY ON SOME\n"
                        +"KIND OF A SHIP.\n"
                        +"THE CAMERA WILL\n"
                        +"SWING LIKE A SHIP.\n"
                        +"\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"0.4x!";
                    case 'Eel Notes':
                        ExplainText.text = "EEL NOTES\n\n\n"
                        +"WOAH! THEY ARE\n"
                        +"BARKING EELS.\n"
                        +"NO ELECTRICITY, BUT\n"
                        +"THEY ARE LONG\n"
                        +"\n"
                        +"\n\n"
                        +"SCORE RATE DROPS TO\n"
                        +"0x!";
					case 'Play':
                        ExplainText.text = "CONTINUE\n\n\n"
                        +"START YOUR OWN\n"
                        +"BEEP BATTLE\n"
                        +"ADVENTURE.\n"
                        +"\n"
                        +"\n"
                        +"\n\n"
                        +"\n"
                        +"";
                    case 'Clean':
                            ExplainText.text = "CLEAR\n\n\n"
                            +"CLEAR ALL YOUR\n"
                            +"MODIFIER COMBOS\n"
                            +"BACK TO NOTHING.\n"
                            +"\n"
                            +"\n"
                            +"\n\n"
                            +"\n"
                            +"";
                }
				
                menuItems.forEach(function(spr:FlxSprite)
                {
                    spr.animation.play('Idle');
        
                    if (spr.ID == curSelected)
                    {
                        spr.animation.play('Select');  
                        camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
                    }
        
                    spr.updateHitbox();
                });
            }
}