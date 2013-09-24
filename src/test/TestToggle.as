package test
{
	import com.dreamana.gui.*;
	import com.dreamana.controls.*;
	import com.dreamana.controls.skins.*;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
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
			btn.name = "";
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
					/*
					var skin:ButtonTextureSkin = new ButtonTextureSkin();
					
					var clip0:UITextureClip = new UITextureClip(new Rectangle(2, 2, 40, 20));
					var clip1:UITextureClip = new UITextureClip(new Rectangle(2, 46, 22, 22));
					
					skin.setStyle("normal-9grid", new Rectangle(5, 5, 22-10, 22-10));
					skin.setStyleAsync("normal-image", clip0);
					skin.setStyle("down-9grid", new Rectangle(5, 5, 22-10, 22-10));
					skin.setStyleAsync("down-image", clip1);
					
					//var texture:BitmapData = new ImageUI().bitmapData;
					//clip0.setData( texture );
					//clip1.setData( texture );
					
					toggle.skin = skin;
					
					var loader:Loader = new Loader();
					clip0.loader = loader;
					clip1.loader = loader;
					
					loader.load(new URLRequest("../assets/ui.png"));
					*/
					break;
				
				case "buttonSelect":
					toggle.selected = !toggle.selected;
					break;
								
				case "buttonDefault":
					toggle.skin = new ToggleButtonSkin();
					break;
			}
		}
		
	}
}