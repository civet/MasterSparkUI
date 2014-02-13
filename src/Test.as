package
{
	import com.dreamana.utils.Broadcaster;
	
	import flash.display.Sprite;
	
	[Embedd(witdh="640", height="480", frameRate="30")]
	
	public class Test extends Sprite
	{
		public function Test()
		{			
			test();
		}
		
		private var signal:Broadcaster = new Broadcaster();
		private var count:int = 4;
		
		private function test():void
		{
			signal.addOnce(onCall);
			signal.dispatch();
		}
		
		private function onCall():void
		{
			trace("call");
			trace("listeners: " + signal.listeners.length);
			
			if(count > 0) {
				count--;
				
				signal.addOnce(onCall);
				signal.dispatch();
			}
		}
		
	}
}