package Crates {
	import org.flixel.*;
	
	/**
	 * ...
	 * @author ME
	 */
	public class CrateBox extends Crate {
		[Embed(source = "../../art/CrateBox.png")]
		public var crateBoxImg:Class;
		
		public function CrateBox(x:Number, y:Number) {
			super(x, y);
			loadGraphic(crateBoxImg, true, false, 16, 16);
			addAnimation("0", [3], 1);
			addAnimation("1", [2], 1);
			addAnimation("2", [1], 1);
			addAnimation("3", [0], 1);
			width = 16;
			height = 16;
			maxVelocity.x = 60;
			drag.x = 1000;
			health = 3;
			hp = 3;
		}
		
		override public function update():void {
			super.update();
			play(hp.toString());
		}
	}
}