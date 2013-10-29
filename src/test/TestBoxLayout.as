package test
{
	import com.dreamana.controls.layouts.HBoxLayout;
	import com.dreamana.controls.layouts.VBoxLayout;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class TestBoxLayout extends Sprite
	{
		public function TestBoxLayout()
		{
			stage? init() : this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event=null):void
		{
			if(event) this.removeEventListener(event.type, init);
			
			//start
			var vbox:VBoxLayout = new VBoxLayout(5);
			vbox.add(getRectangle())
				.add(getRectangle())
				;
				
			var hbox:HBoxLayout = new HBoxLayout(5);
			hbox.add(getRectangle())
				.add(getRectangle())
				.add(getRectangle())
				.add( new VBoxLayout(5).add(getRectangle()).add(getRectangle()) )
				;
				
			vbox.add(hbox)
				.add(getRectangle())
				;
		}
		
		private function getRectangle():Sprite
		{
			var s:Sprite = new Sprite();
			s.graphics.beginFill(0xffffff * Math.random());
			s.graphics.drawRect(0, 0, 10 + int(40* Math.random()), 10 + int(40* Math.random()));
			s.graphics.endFill();
			
			this.addChild(s);
			
			return s;
		}
	}
}