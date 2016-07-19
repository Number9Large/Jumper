package {
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*
	import PlayState;
	[SWF(width="640",height="480",backgroundColor="#000000")] //Set the size and color of the Flash file
	[Frame(factoryClass="Preloader")]
	
	public class Jumper extends FlxGame {
		public function Jumper() {
			super(320, 240, PlayState, 2); //Create a new FlxGame object at 320x240 with 2x pixels, then load PlayState
		}
	}
}