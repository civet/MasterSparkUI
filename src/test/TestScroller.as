package test
{
	import com.dreamana.controls.Scroller;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class TestScroller extends Sprite
	{
		public function TestScroller()
		{
			stage? init() : this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event=null):void
		{
			if(event) this.removeEventListener(event.type, init);
			
			//start
			var texture:BitmapData = new Texture().bitmapData;
			var image:Sprite = new Sprite();
			image.graphics.beginBitmapFill(texture);
			image.graphics.drawRect(0, 0, 400, 400);
			image.graphics.endFill();
			
			var scroller:Scroller = new Scroller();
			this.addChild(scroller);
			
			scroller.setSize(200, 200);
			
			scroller.addContent(image);
		}
		
		[Embed(source="../assets/bg.jpg")] public var Texture:Class;
	}
}