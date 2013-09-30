package test
{
	import com.dreamana.controls.Scrollbar;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class TestScrollbar extends Sprite
	{
		public function TestScrollbar()
		{
			stage? init() : this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event=null):void
		{
			if(event) this.removeEventListener(event.type, init);
			
			//start
			var scrollbar:Scrollbar = new Scrollbar();
			this.addChild(scrollbar);
			
			scrollbar.percent = 0.25;
			scrollbar.value = 1;
			scrollbar.step = 0.25;
			//scrollbar.enabled = false;
			
			scrollbar.setSize(300, 20);
			
			scrollbar.orientation = Scrollbar.VERTICAL;
		}
	}
}