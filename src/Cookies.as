package {
	import org.flixel.*;
	
	/**
	 * ...
	 * @author ME
	 */
	public class Cookies extends FlxSprite {
		[Embed(source = "../art/Cookie.png")]
		public var cookieClass:Class;
		
		public var cookies:int = 0;
		
		private static const GRAVITY:int = 420;
		
		public function Cookies(crate:Crate) {
			super(crate.x + Math.random() * crate.width, crate.y + Math.random() * crate.height);
			loadGraphic(cookieClass, true, false, 5, 5);
			addAnimation("0", [0], 1);
			width = 5;
			height = 5;
			offset.x = 0;
			offset.y = 0;
			acceleration.y = GRAVITY;
			maxVelocity.x = 10;
			drag.x = 50;
		}
		override public function update():void {
			super.update();
			play("0");
		}
	
	}

}