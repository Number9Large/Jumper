package {
	import org.flixel.*;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Pig extends FlxSprite {
		[Embed(source = "../art/piggie.png")]
		public var piggie:Class;
		
		private var _move_speed:int = 400;
		private var _jump_power:int = 800;
		private var _max_health:int = 10;
		private var _hurt_counter:Number = 0;
		private var _can_jump:Boolean = true;
		private var _last_jump:Number = 0;
		private var _player:FlxSprite;
		
		public function Pig(X:Number, Y:Number, ThePlayer:FlxSprite):void {
			super(X, Y);
			loadGraphic(piggie, true, true, 64, 64);
			_player = ThePlayer;
			maxVelocity.x = 200;
			maxVelocity.y = 200;
			
			health = 1;
			acceleration.y = 420;
			drag.x = 350;
			width = 11;
			height = 14;
			offset.x = 33;
			offset.y = 21;
			addAnimation("jump", [0, 1, 2], 6, true);
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
			
			if (_last_jump > 0) {
				_last_jump -= FlxG.elapsed;
			}
			if (_player.x < x && _player.x - x < 100) {
				facing = RIGHT;
				velocity.x -= _move_speed * FlxG.elapsed;
			} else if (_player.x > x && _player.x - x > 100) {
				facing = LEFT;
				velocity.x += _move_speed * FlxG.elapsed;
			}
			if (_player.y < y && _can_jump) {
				velocity.y = -_jump_power;
				_last_jump = 2;
				_can_jump = false;
			}
			if (isTouching(FLOOR)) {
				_can_jump = true;
			}
			
			play("jump");
			super.update();
		
		}
		
		override public function hurt(Damage:Number):void {
			_hurt_counter = 1;
			super.hurt(Damage);
		}
	
	}
}