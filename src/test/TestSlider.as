package test
{
	import com.dreamana.controls.*;
	import com.dreamana.controls.skins.*;
	import com.dreamana.gui.*;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	
	public class TestSlider extends Sprite
	{
		private var slider:Slider;
		
		public function TestSlider()
		{
			stage? init() : this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event=null):void
		{
			if(event) this.removeEventListener(event.type, init);
		
			//start
			slider = new Slider();
			slider.addEventListener(Event.CHANGE, onSliderChange);
			slider.orientation = Slider.VERTICAL;
			slider.setSize(20, 300);
			slider.value = 0.25;
			slider.percent = 0.25;
			slider.trackClickEnabled = false;
			this.addChild(slider);
			
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
			btn.name = "buttonColoring";
			btn.addChild(new Label("Coloring"));
			btn.x = 540;
			btn.y = 30;
			this.addChild(btn);
			btn.addEventListener(MouseEvent.CLICK, onButtonClick);
			
			btn = new Button();
			btn.name = "buttonEnabler";
			btn.addChild(new Label("Disabled/Enabled"));
			btn.x = 540;
			btn.y = 60;
			this.addChild(btn);
			btn.addEventListener(MouseEvent.CLICK, onButtonClick);
			
			btn = new Button();
			btn.name = "buttonSkinning";
			btn.addChild(new Label("Textured"));
			btn.x = 540;
			btn.y = 90;
			this.addChild(btn);
			btn.addEventListener(MouseEvent.CLICK, onButtonClick);
			
			btn = new Button();
			btn.name = "buttonOrientation";
			btn.addChild(new Label("Orientation"));
			btn.x = 540;
			btn.y = 120;
			this.addChild(btn);
			btn.addEventListener(MouseEvent.CLICK, onButtonClick);
			
			btn = new Button();
			btn.name = "buttonDefault";
			btn.addChild(new Label("Default"));
			btn.x = 540;
			btn.y = 150;
			this.addChild(btn);
			btn.addEventListener(MouseEvent.CLICK, onButtonClick);
			
			btn = new Button();
			btn.name = "buttonPercent";
			btn.addChild(new Label("Percent"));
			btn.x = 540;
			btn.y = 180;
			this.addChild(btn);
			btn.addEventListener(MouseEvent.CLICK, onButtonClick);
			
			btn = new Button();
			btn.name = "buttonTrackClick";
			btn.addChild(new Label("TrackClick"));
			btn.x = 540;
			btn.y = 210;
			this.addChild(btn);
			btn.addEventListener(MouseEvent.CLICK, onButtonClick);
		}
		
		private function onSliderChange(event:Event):void
		{
			//var slider:Slider = event.currentTarget as Slider;
			trace(slider.value);
		}
		
		private function onButtonClick(event:MouseEvent):void
		{
			switch(event.currentTarget.name)
			{
				case "buttonResize":
					if(slider.orientation == Slider.HORIZONTAL)
						slider.setSize(100 + int(Math.random() * 400), 10  + int(Math.random() * 40) );
					else
						slider.setSize(10 + int(Math.random() * 40), 100 + int(Math.random() * 400) );
					break;		
				
				case "buttonColoring":
					slider.skin.setStyle("track-color", 0xffffff * Math.random());
					slider.skin.setStyle("handle-color", 0xffffff * Math.random());
					break;
				
				case "buttonEnabler":
					slider.enabled = !slider.enabled;
					break;
				
				case "buttonSkinning":
					var skin:SliderTextureSkin = new SliderTextureSkin();
					
					var clip0:UITextureProvider = new UITextureProvider(new Rectangle(2, 2, 40, 20));
					var clip1:UITextureProvider = new UITextureProvider(new Rectangle(2, 46, 22, 22));
					
					skin.setStyle("track-9slice", new Rectangle(5, 5, 40-10, 20-10));
					skin.setStyleAsync("track-image", clip0);
					skin.setStyle("handle-9slice", new Rectangle(5, 5, 22-10, 22-10));
					skin.setStyleAsync("handle-image", clip1);
					
					//var texture:BitmapData = new ImageUI().bitmapData;
					//clip0.setData( texture );
					//clip1.setData( texture );
					
					slider.skin = skin;
					
					var loader:Loader = new Loader();
					clip0.loader = loader;
					clip1.loader = loader;
					
					loader.load(new URLRequest("../assets/ui.png"));
					break;
				
				case "buttonOrientation":
					slider.orientation = (slider.orientation == Slider.HORIZONTAL)? Slider.VERTICAL : Slider.HORIZONTAL;
					break;
				
				case "buttonDefault":
					slider.skin = new SliderSkin();
					break;
				
				case "buttonPercent":
					slider.percent = Math.random();
					break;
				
				case "buttonTrackClick":
					slider.trackClickEnabled = !slider.trackClickEnabled;
					break;
			}
		}
	}
}