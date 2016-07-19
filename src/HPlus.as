package {
	import org.flixel.*;
	
	/**
	 * ...
	 * @author ME
	 */
	public class HPlus extends FlxSprite {
		[Embed(source = "../art/Health Plus.png")]
		public var hPlus:Class;
		[Embed(source = "../art/hPlusSmall.png")]
		public var hPlusSmall:Class;
		[Embed(source = "../art/hPlusMedium.png")]
		public var hPlusMedium:Class;
		
		private static const GRAVITY:int = 420;
		
		private var player:Player;
		
		public function HPlus(X:Number, Y:Number, Type:String, player:Player) {
			super(X + Math.random() * 16, Y - 5 - Math.random() * 20);
			this.player = player;
			switch (Type) {
			case 'Big': 
				loadGraphic(hPlus, true, false, 20, 20);
				addAnimation("idle", [0, 1, 2, 3, 4, 5, 6, 7, 7, 7, 8, 9, 10, 11, 12, 7, 7, 7], 16);
				width = 20;
				height = 20;
				offset.x = 0;
				offset.y = 0;
				acceleration.y = GRAVITY;
				maxVelocity.x = 10;
				drag.x = 50;
				health = 5;
				solid = true;
				break;
			case 'Medium': 
				loadGraphic(hPlusMedium, true, false, 10, 10);
				addAnimation("idle", [0, 1, 2, 3, 4, 5, 6, 7, 8, 0, 0, 0, 9, 10, 11, 0, 0, 0], 16);
				width = 10;
				height = 10;
				offset.x = 0;
				offset.y = 0;
				acceleration.y = GRAVITY;
				maxVelocity.x = 10;
				drag.x = 50;
				health = 3;
				solid = true;
				break;
			case 'Small': 
				loadGraphic(hPlusSmall, true, false, 5, 5);
				addAnimation("idle", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 0, 0, 0], 16);
				width = 5;
				height = 5;
				offset.x = 0;
				offset.y = 0;
				acceleration.y = GRAVITY;
				maxVelocity.x = 10;
				drag.x = 50;
				health = 1;
				solid = true;
				break;
			default: 
			}
		}
		
		override public function update():void {
			super.update();
			play("idle");
			
			if (player.overlaps(this) && this.health > 0 && player.health < player._max_health) {
				player.health += this.health;
				if (player._max_health < player.health) {
					player.health = 10;
				}
				this.hurt(this.health);
			}	
		}
	}

}