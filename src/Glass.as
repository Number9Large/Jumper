package {
	import org.flixel.*;
	
	/**
	 * ...
	 * @author ME
	 */
	public class Glass extends FlxSprite {
		[Embed(source = "../art/stakan.png")]
		public var stakan:Class;
		[Embed(source = "../art/sPart.png")]
		public var sPart:Class;
		
		protected static const RUN_SPEED:int = 120;
		protected static const GRAVITY:int = 420;
		protected static const JUMP_SPEED:int = 210;
		
		public var controls:Boolean = false;
		public var glassEm:FlxEmitter = new FlxEmitter(0, 0, 10);
		
		public function Glass(parent:FlxGroup, X:Number, Y:Number) {
			super(X, Y)
			parent.add(glassEm);
			parent.add(this);
			
			loadGraphic(stakan, true, true, 24, 24);
			addAnimation("idle", [9], 1, false);
			addAnimation("slime", [5], 1, true);
			addAnimation("slimeIn", [0, 1, 2, 3, 4, 5], 17, false);
			addAnimation("slimeOut", [5, 6, 7, 8], 24, false);
			width = 8;
			height = 10;
			offset.x = 8;
			offset.y = 13;
			health = 2;
			drag.x = RUN_SPEED * 8;
			acceleration.y = GRAVITY;
			maxVelocity.x = RUN_SPEED;
			maxVelocity.y = JUMP_SPEED * 2;
			facing = RIGHT;
			play("idle");
			
			glassEm.gravity = 420;
			glassEm.particleDrag.x = 75;
			glassEm.setRotation(0, 0);
			glassEm.bounce = 0.3;
			glassEm.makeParticles(sPart, 10, 16, true);
			glassEm.setXSpeed(-50, 50);
			glassEm.setYSpeed(-50, -100);
		}
		
		override public function update():void {
			super.update();
			
			acceleration.x = 0;
			
			if (FlxG.keys.LEFT && controls && !isTouching(FLOOR)) {
				facing = LEFT;
				acceleration.x = -drag.x * 0.5;
			} else if (FlxG.keys.RIGHT && controls && !isTouching(FLOOR)) {
				facing = RIGHT;
				acceleration.x = drag.x * 0.5;
			}
			if (FlxG.keys.justPressed("UP") && isTouching(FLOOR) && controls) {
				velocity.y = -JUMP_SPEED * 0.6;
			}
		}
		
		public function jumpOffTheGlass():void {
			glassEm.x = x += 4;
			glassEm.y = y;
			glassEm.start(true, 3, 0.1, 5);
			controls = false;
		}
	}
}