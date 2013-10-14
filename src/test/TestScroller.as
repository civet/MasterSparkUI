package test
{
	import com.dreamana.controls.Button;
	import com.dreamana.controls.Label;
	import com.dreamana.controls.Scroller;
	import com.dreamana.controls.Toggle;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class TestScroller extends Sprite
	{
		private var scroller:Scroller;
		
		public function TestScroller()
		{
			stage? init() : this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event=null):void
		{
			if(event) this.removeEventListener(event.type, init);
			
			//start
			var image:Sprite = new Sprite();
			image.graphics.beginBitmapFill( new Texture().bitmapData );
			image.graphics.drawRect(0, 0, 400, 400);
			image.graphics.endFill();
			
			scroller = new Scroller();
			this.addChild(scroller);
			
			scroller.setSize(200, 200);
			scroller.addContent(image);
			
			scroller.dragContent = true;
						
			//toolbar
			var btn:Button;
			var tgl:Toggle;
			
			btn = new Button();
			btn.name = "buttonResize";
			btn.addChild(new Label("Resize"));
			btn.x = 540;
			btn.y = 0;
			this.addChild(btn);
			btn.addEventListener(MouseEvent.CLICK, onButtonClick);
			
			tgl = new Toggle();
			tgl.name = "buttonAutoHide";
			tgl.addChild(new Label("AutoHide"));
			tgl.x = 540;
			tgl.y = 30;
			this.addChild(tgl);
			tgl.addEventListener(MouseEvent.CLICK, onButtonClick);
		}
		
		private function onButtonClick(event:MouseEvent):void
		{
			var target:Object = event.currentTarget;
			
			switch(event.currentTarget.name)
			{
				case "buttonResize":
					scroller.setSize(200 + int(Math.random() * 400), 200 + int(Math.random() * 400));
					break;
				
				case "buttonAutoHide":
					scroller.autoHideScrollBar = Toggle(target).selected;
					break;
			}
		}
				
		[Embed(source="../assets/bg.jpg")] public var Texture:Class;
	}
}