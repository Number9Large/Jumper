package {
	import org.flixel.*;
	
	/**
	 * ...
	 * @author ME
	 */
	public class Crate extends FlxSprite {
		[Embed(source = "../art/Cookie.png")]
		public var cookieClass:Class;
		[Embed(source = "../art/bPart.png")]
		public var bPart:Class;
		
		protected static const GRAVITY:int = 420;
		
		public var hp:int;
		public var dropCheck:Boolean = false;
		
		public var hurtCounter:int = 0;
		
		public function Crate(x:Number, y:Number) {
			super(x, y);
			acceleration.y = GRAVITY;
			offset.x = 0;
			offset.y = 0;
		}
		
		override public function update():void {
			super.update();
			acceleration.x = 0;
		}
	}
}