package {
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	/**
	 * ...
	 * @author ME
	 */
	public class PlayerHUD extends FlxGroup {
		
		public var tpBar:FlxBar;
		public var hpBar:FlxBar;
		private var player:Player;
		
		public function PlayerHUD(player:Player) {
			super();
			this.player = player;/*
			tpBar = new FlxBar(10, 30, FlxBar.FILL_LEFT_TO_RIGHT, 100, 10, player, "energy");
			tpBar.createGradientBar([0xFF004000, 0xFF008000], [0xFF428901, 0xFF00C600, 0xFF8DEC00], 1, 180, true, 0xFF82BF8C);
			tpBar.scrollFactor.x = 0;
			tpBar.scrollFactor.y = 0;
			*/
			hpBar = new FlxBar(10, 10, FlxBar.FILL_LEFT_TO_RIGHT, 100, 10, player, "health");
			hpBar.createGradientBar([0xFF400000, 0xFF800000], [0xFFFF0000, 0xFFFF0000, 0xFFFF8080], 1, 180, true, 0xFF804040);
			hpBar.scrollFactor.x = 0;
			hpBar.scrollFactor.y = 0;
			/*
			add(tpBar);*/
			add(hpBar);
		}
		
		override public function update():void {
			super.update();
			if (player !== null) {/*
				tpBar.currentValue = player.energy;
				tpBar.setRange(0, 120);*/
				hpBar.currentValue = player.health;
				hpBar.setRange(0, 10);
			}
		}
	
	}

}