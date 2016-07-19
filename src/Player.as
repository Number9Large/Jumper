package {
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*
	
	/**
	 * ...
	 * @author Mad Mike
	 */
	public class Player extends FlxSprite {
		[Embed(source = "../art/Slime.png")]
		public var slime:Class;
		[Embed(source = "../art/SlimeBullet.png")]
		public var slimePart:Class;
		
		public var RUN_SPEED:int = 120;
		public var GRAVITY:int = 420;
		public var JUMP_SPEED:int = 210;
		
		public var _max_health:int = 10;
		private var _hurt_counter:Number = 0;
		
		public var loaded:Boolean = true;
		public var canJump:Boolean = false;
		public var isShooting:Boolean = false;
		public var isDiving:Boolean = false;
		public var isTeleporting:Boolean = false;
		public var tpRight:Boolean = false;
		public var tpLeft:Boolean = false;
		public var tpUp:Boolean = false;
		public var tpDown:Boolean = false;
		public var diveCout:int = 0;
		public var tpVelX:int = 0;
		public var tpVelY:int = 0;
		public var push:int = 1;
		public var wallJump:Boolean = false;
		
		public var slimeShot:FlxEmitter = new FlxEmitter(0, 0, 1);
		public var sEmInvTime:int = 60;
		
		public function Player(X:int, Y:int):void {
			super(X, Y);
			loadGraphic(slime, true, true, 18, 14);
			addAnimation("idle", [8, 9, 10, 11, 12, 13, 13, 0, 1, 2, 3, 4, 5, 6, 7], 16, true);
			addAnimation("run", [10, 11, 12, 13, 0, 1, 2, 3], 16, true);
			addAnimation("fly", [7], 16, false);
			addAnimation("dive", [25, 26, 27, 28], 23, false);
			addAnimation("diveEnd", [29, 30, 31, 32, 13, 0, 1, 2, 3, 4, 5, 6, 7], 23, false);
			addAnimation("jump", [1, 2, 3, 4, 5, 6, 7], 16, false);
			addAnimation("shoot", [34, 35, 36, 37, 38], 16, false);
			addAnimation("tpOut", [40, 41, 42, 43, 44, 45], 16, false);
			addAnimation("tpIn", [46, 47, 48, 49], 16, false);
			addAnimation("wallSlide", [50], 16, true);
			
			health = 1;
			
			width = 12;
			height = 13;
			offset.x = 6;
			offset.y = 0;
			
			drag.x = RUN_SPEED * 8;
			acceleration.y = GRAVITY;
			maxVelocity.x = RUN_SPEED;
			maxVelocity.y = JUMP_SPEED * 2;
			
			slimeShot.gravity = 420;
			slimeShot.particleDrag.x = 75;
			slimeShot.setRotation(0, 0);
			slimeShot.bounce = 0.5;
			slimeShot.makeParticles(slimePart);
			slimeShot.setYSpeed(120, 120);
		}
		
		override public function update():void {
			if (!alive) {
				if (finished) exists = false;
				else
					super.update();
				return;
			}
			if (_hurt_counter > 0) {
				_hurt_counter -= FlxG.elapsed * 3;
			}
			
			acceleration.x = 0; //Reset to 0 when no button is pushed
			controls();
			//stop in air whille tp
			if (isTeleporting) {
				acceleration.y = 0;
				velocity.y = 0;
			}
			if (wallJump && FlxG.keys.justPressed("UP")) {
				velocity.y = -JUMP_SPEED * 0.8;
				if (facing == RIGHT) {
					velocity.x = -120;
				} else if (facing == LEFT) {
					velocity.x = 120;
				}
			}
			if (!isTouching(ANY)) {
				acceleration.y = GRAVITY;
				wallJump = false;
			}
			//start of shooting
			if (FlxG.keys.justPressed("C") && !isDiving && !isShooting && !isTeleporting && loaded) {
				isShooting = true;
				play("shoot");
			}
			//end of shooting
			if (frame == 38 || FlxG.elapsed == 1) {
				isShooting = false;
			}
			//push
			/*if (FlxG.keys.justPressed("SHIFT") && push == 1) {
			   velocity.y -= 50;
			   push = 0;
			   if (velocity.x > 0) {
			   velocity.x += 500;
			   }
			   if (velocity.x < 0) {
			   velocity.x -= 500;
			   }
			   }*/
			if (isTouching(FLOOR)) {
				push = 1;
			}
			//run animation
			if (velocity.x != 0 && isTouching(FLOOR) && !isDiving && !isShooting && !isTeleporting) {
				play("run");
			}
			//idle animation
			if (!velocity.x && isTouching(FLOOR) && !isDiving && !isShooting && !isTeleporting) {
				play("idle");
			}
			//in air animation
			if (!isTouching(FLOOR) && !isDiving && !isShooting && !isTeleporting && !wallJump) {
				play("fly");
			}
			
			super.update();
		}
		
		public function controls():void {
			
			//left and right
			if (FlxG.keys.LEFT && !isTeleporting) {
				facing = LEFT;
				offset.x = 0;
				acceleration.x = -drag.x;
			}
			if (FlxG.keys.RIGHT && !isTeleporting) {
				facing = RIGHT;
				offset.x = 6;
				acceleration.x = drag.x;
			}
			//jump
			if (FlxG.keys.justPressed("UP") && isTouching(FLOOR) && !isTeleporting) {
				velocity.y = -JUMP_SPEED;
			}
			//dive
			if (FlxG.keys.justPressed("DOWN") && !isTouching(FLOOR) && !isDiving && !isShooting && !isTeleporting) {
				isDiving = true;
				play("dive");
				velocity.y = JUMP_SPEED;
			}
			//dive end
			if (isTouching(DOWN) && isDiving) {
				play("diveEnd");
				velocity.x = velocity.x * 0.7;
				if (frame == 7 || FlxG.keys.justPressed("UP") || FlxG.elapsed == 1) {
					isDiving = false;
				}
			}
			if (frame == 25 || frame == 26 || frame == 27 || frame == 28 && alive == true) {
				diveCout = 1;
			} else {
				diveCout = 0;
			}
			
			//slimeshot
			if (sEmInvTime > 0) {
				sEmInvTime--;
			}
			if (this.frame == 37 && this.facing == 0x0010) {
				slimeShot.setXSpeed(400, 400);
				slimeShot.x = this.x+6;
				slimeShot.y = this.y+6;
				slimeShot.start();
				this.loaded = false;
				sEmInvTime = 30;
			}
			if (this.frame == 37 && this.facing == 0x0001) {
				slimeShot.setXSpeed(-400, -400);
				slimeShot.x = this.x+3;
				slimeShot.y = this.y+6;
				slimeShot.start();
				this.loaded = false;
				sEmInvTime = 30;
			}
			if (this.overlaps(slimeShot) && sEmInvTime <= 0) {
				slimeShot.kill();
				this.loaded = true;
			}
			
		}
	}
}