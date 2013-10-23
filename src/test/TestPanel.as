package test
{
	import com.dreamana.controls.Panel;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class TestPanel extends Sprite
	{
		
		public function TestPanel()
		{
			stage? init() : this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event=null):void
		{
			if(event) this.removeEventListener(event.type, init);
			
			//start
			var panel:Panel = new Panel();
			panel.setSize(200, 600);
			this.addChild(panel);
			
			panel.skin.setStyle("title", "Panel");
			
			panel.collapse();
			//panel.enabled = false;
		}
	}
}