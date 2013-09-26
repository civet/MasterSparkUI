package test
{
	import com.dreamana.gui.*;
	import com.dreamana.controls.*;
	import com.dreamana.controls.skins.*;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	public class TestTextInput extends Sprite
	{
		private var input:TextInput;
		
		
		public function TestTextInput()
		{
			stage? init() : this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event=null):void
		{
			if(event) this.removeEventListener(event.type, init);
			
			//start
			input = new TextInput();
			input.setSize(100, 80);
			input.setTextFieldProps({multiline:true, wordWrap:true});
			input.skin.setStyle("padding", 4);
			this.addChild(input);
			
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
			btn.name = "buttonDefault";
			btn.addChild(new Label("Default"));
			btn.x = 540;
			btn.y = 120;
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
					input.setSize(100 + int(Math.random() * 200), 100 + int(Math.random() * 200));
					break;		
				
				case "buttonColoring":
					input.skin.setStyle("background-color", 0xffffff * Math.random());
					break;
				
				case "buttonEnabler":
					input.enabled = !input.enabled;
					break;
				
				case "buttonSkinning":
					var skin:TextInputTextureSkin = new TextInputTextureSkin();
					
					var clip0:UITextureClip = new UITextureClip(new Rectangle(2, 2, 40, 20));
					
					skin.setStyle("background-9grid", new Rectangle(5, 5, 40-10, 20-10));
					skin.setStyleAsync("background-image", clip0);
					
					skin.setStyle("padding", 4);
					
					input.skin = skin;
										
					var loader:Loader = new Loader();
					clip0.loader = loader;
					
					loader.load(new URLRequest("../assets/ui.png"));
					break;
				
				case "buttonDefault":
					input.skin = new TextInputSkin();
					input.skin.setStyle("padding", 4);
					break;
			}
		}
	}
}