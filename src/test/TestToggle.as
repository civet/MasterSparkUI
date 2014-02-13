package test
{
	import com.dreamana.controls.*;
	import com.dreamana.controls.skins.*;
	import com.dreamana.gui.*;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	public class TestToggle extends Sprite
	{
		private var toggle:Toggle;
		private var button:Button;
		
		public function TestToggle()
		{
			stage? init() : this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event=null):void
		{
			if(event) this.removeEventListener(event.type, init);
			
			//start
			toggle = new Toggle();
			this.addChild(toggle);
			toggle.addEventListener(MouseEvent.CLICK, onClick);
			
			toggle.addChild(new Label("Toggle", null, 30));
			
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
			btn.name = "buttonSelect";
			btn.addChild(new Label("Select/Unselect"));
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
			btn.name = "buttonChangeSkin";
			btn.addChild(new Label("Change Skin"));
			btn.x = 540;
			btn.y = 180;
			this.addChild(btn);
			btn.addEventListener(MouseEvent.CLICK, onButtonClick);
		}
		
		private function onClick(event:MouseEvent):void
		{
			trace("click!");
		}
		
		private function onButtonClick(event:MouseEvent):void
		{
			switch(event.currentTarget.name)
			{
				case "buttonResize":
					toggle.setSize(100 + int(Math.random() * 200), 100 + int(Math.random() * 200));
					break;		
				
				case "buttonColoring":
					toggle.skin.setStyle("border-color", 0xffffff * Math.random());
					toggle.skin.setStyle("face-color", 0xffffff * Math.random());
					break;
				
				case "buttonEnabler":
					toggle.enabled = !toggle.enabled;
					break;
				
				case "buttonSkinning":
					var skin:ToggleButtonTextureSkin = new ToggleButtonTextureSkin();
					
					var clip0:UITextureProvider = new UITextureProvider(new Rectangle(2, 2, 40, 20));
					var clip1:UITextureProvider = new UITextureProvider(new Rectangle(2, 46, 22, 22));
					
					skin.setStyle("normal-9slice", new Rectangle(5, 5, 40-10, 20-10));
					skin.setStyleAsync("normal-image", clip0);
					skin.setStyle("down-9slice", new Rectangle(5, 5, 22-10, 22-10));
					skin.setStyleAsync("down-image", clip1);
					
					//var texture:BitmapData = new ImageUI().bitmapData;
					//clip0.setData( texture );
					//clip1.setData( texture );
					
					toggle.skin = skin;
					
					var loader:Loader = new Loader();
					clip0.loader = loader;
					clip1.loader = loader;
					
					loader.load(new URLRequest("../assets/ui.png"));
					
					break;
				
				case "buttonSelect":
					toggle.selected = !toggle.selected;
					break;
								
				case "buttonDefault":
					toggle.skin = new ToggleButtonSkin();
					break;
				
				case "buttonChangeSkin":
					if(toggle.skin is ToggleButtonSkin) {
						toggle.skin = new CheckBoxSkin();
					}
					else {
						toggle.skin = new ToggleButtonSkin();
					}
					break;
			}
		}
		
	}
}