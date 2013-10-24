package test
{
	import com.dreamana.controls.Button;
	import com.dreamana.controls.Label;
	import com.dreamana.controls.Panel;
	import com.dreamana.controls.Scroller;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class TestPanel extends Sprite
	{
		private var panel:Panel;
		
		public function TestPanel()
		{
			stage? init() : this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event=null):void
		{
			if(event) this.removeEventListener(event.type, init);
			
			//start
			panel = new Panel();
			panel.setSize(200, 200);
			this.addChild(panel);
			panel.title = "Panel";
			
			//panel.addContent( getScroller() );
						
			//toolbar
			var btn:Button;
			
			btn = new Button();
			btn.name = "buttonResize";
			btn.addChild(new Label("Resize"));
			btn.x = 540;
			btn.y = 0;
			this.addChild(btn);
			btn.addEventListener(MouseEvent.CLICK, onButtonClick);
			
			btn = new Button();
			btn.name = "buttonEnabler";
			btn.addChild(new Label("Disabled/Enabled"));
			btn.x = 540;
			btn.y = 30;
			this.addChild(btn);
			btn.addEventListener(MouseEvent.CLICK, onButtonClick);
			
			btn = new Button();
			btn.name = "buttonDraggable";
			btn.addChild(new Label("Draggable"));
			btn.x = 540;
			btn.y = 60;
			this.addChild(btn);
			btn.addEventListener(MouseEvent.CLICK, onButtonClick);
			
			btn = new Button();
			btn.name = "buttonToggle";
			btn.addChild(new Label("Collapse/Expand"));
			btn.x = 540;
			btn.y = 90;
			this.addChild(btn);
			btn.addEventListener(MouseEvent.CLICK, onButtonClick);
		}
		
		private function getScroller():Scroller
		{
			var image:Sprite = new Sprite();
			image.graphics.beginBitmapFill( new Texture().bitmapData );
			image.graphics.drawRect(0, 0, 400, 400);
			image.graphics.endFill();
			
			var scroller:Scroller = new Scroller();
			scroller.setSize(200, 180);
			scroller.addContent(image);
			scroller.dragContent = true;
			scroller.autoHideScrollBar = true;
						
			return scroller;
		}
		
		[Embed(source="../assets/bg.jpg")] public var Texture:Class;
		
		private function onButtonClick(event:MouseEvent):void
		{
			var target:Object = event.currentTarget;
			
			switch(event.currentTarget.name)
			{
				case "buttonResize":
					panel.setSize(100 + int(Math.random() * 300), 100 + int(Math.random() * 300));
					break;
				
				case "buttonEnabler":
					panel.enabled = !panel.enabled;
					break;
				
				case "buttonDraggable":
					panel.draggable = !panel.draggable;
					break;
				
				case "buttonToggle":
					panel.collapsed ? panel.expand() : panel.collapse();
					break;
			}
		}
	}
}