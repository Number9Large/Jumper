package {
	import adobe.utils.CustomActions;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import Crates.*;
	import org.flixel.system.FlxTile;
	
	public class PlayState extends FlxState {
		[Embed(source = "../levels/mapCSV_Group1_Map1.csv", mimeType = "application/octet-stream")]
		public var levelMap:Class;
		[Embed(source = "../art/tilemap.png")]
		public var levelTiles:Class;
		[Embed(source = "../art/sPart.png")]
		public var sPart:Class;
		[Embed(source = "../art/tpPart.png")]
		public var tpPart:Class;
		
		public var map:FlxTilemap = new FlxTilemap;
		public var player:Player;
		public var enemy:Pig;
		public var glass:Glass;
		public var glassEm:FlxEmitter = new FlxEmitter(0, 0, 10);
		public var boxEm:FlxEmitter = new FlxEmitter(0, 0, 10);
		public var tpEm:FlxEmitter;
		public var sprites:FlxGroup = new FlxGroup();
		public var boxes:FlxGroup = new FlxGroup();
		public var mapData:Array;
		public var slimeIter:Number = 1;
		
		override public function create():void {
			add(map.loadMap(new levelMap, levelTiles, 16, 16, 0, 0, 1, 1));
			map.setTileProperties(1, FlxObject.ANY, wallJump, Player, 23);
			mapData = map.getData();
			map.solid = true;
			boxes.add(new CrateBox(35, 25));
			boxes.add(new CrateBox(55, 25));
			sprites.add(boxes);
			sprites.add(player = new Player(25, 33));
			sprites.add(glass = new Glass(35, 35));
			sprites.add(glassEm);
			sprites.add(boxEm);
			sprites.add(player.slimeShot);
			
			
			glassEm.gravity = 420;
			glassEm.particleDrag.x = 75;
			glassEm.setRotation(0, 0);
			glassEm.bounce = 0.3;
			glassEm.makeParticles(sPart, 10, 16, true);
			glassEm.setXSpeed(-50, 50);
			glassEm.setYSpeed(-50, -100);
			
			add(new PlayerHUD(player));
			add(sprites);
			
			FlxG.camera.follow(player, FlxCamera.STYLE_PLATFORMER);
			FlxG.camera.setBounds(0, 0, 320, 240);
			FlxG.worldBounds.make(0, 0, 320, 240);
			super.create();
		}
		
		override public function update():void {
			super.update();
			
			spritesCol();
			boxStuff();
			glassStuff();
			playerStuff();
			if (FlxG.keys.justPressed("R")) FlxG.switchState(new PlayState);
		}
		
		public function boxStuff():void {
			for each (var box:CrateBox in boxes.members) {
				if (player.diveCout == 1 && box.hp >= 0 && player.overlaps(box)) {
					box.hp = 0;
				}
				for each (var item:Crate in boxes.members) {
					if (item.hp > 0 && box.hp > 0) {
						FlxG.collide(box, item);
						FlxG.collide(box, player);
					}
				}
				if (box.hp <= 0 && !box.dropCheck) {
					add(sprites.add(new HPlus(box.x + (Math.random() * 8), box.y, "Small", player)));
					add(sprites.add(new HPlus(box.x + (Math.random() * 8), box.y, "Small", player)));
					add(sprites.add(new HPlus(box.x + (Math.random() * 8), box.y, "Small", player)));
					
					boxEm.gravity = 420;
					boxEm.particleDrag.x = 75;
					boxEm.bounce = 0.2;
					boxEm.makeParticles(box.bPart, 10, 16, true);
					boxEm.setXSpeed(-50, 50);
					boxEm.setYSpeed(-40, -70);
					boxEm.x = box.x + 8;
					boxEm.y = box.y - 4;
					add(boxEm);
					boxEm.start(true, 2, 0.1, 10);
					
					box.dropCheck = true;
				}
			}
		}
		
		public function glassStuff():void {
			if (player.overlaps(glass) && player.diveCout == 1 && glass.alive == true) {
				player.kill();
				player.isDiving = false;
				player.diveCout = 0;
				player.isTeleporting = false;
				glass.play("slimeIn");
			}
			if (glass.frame == 5 && !glass.controls) {
				glass.play("slime");
				glass.controls = true;
				FlxG.camera.follow(glass, FlxCamera.STYLE_PLATFORMER);
			}
			if (FlxG.keys.justPressed("SPACE") && glass.controls) {
				glass.play("slimeOut");
			}
			
			if (glass.frame == 8 && glass.controls) {
				glassEm.x = glass.x += 4;
				glassEm.y = glass.y;
				glassEm.start(true, 3, 0.1, 5);
				glass.controls = false;
				player.exists = true;
				player.alive = true;
				player.x = glass.x -= 5;
				player.y = glass.y -= 5;
				player.velocity.x = glass.velocity.x;
				player.velocity.y = glass.velocity.y;
				FlxG.camera.follow(player, FlxCamera.STYLE_PLATFORMER);
				glass.kill();
			}
		}
		
		public function playerStuff():void {
			if (player.overlaps(map)) {
				player.y++;
			}
		}
		
		public function spritesCol():void {
			FlxG.collide(sprites, map);
		}
		
		public function wallJump(tile:FlxTile, player:Player):void {
			if (player.isTouching(FlxObject.WALL) && FlxG.keys.SHIFT) {
				player.wallJump = true;
				player.play("wallSlide");
			}
		}
	}
}