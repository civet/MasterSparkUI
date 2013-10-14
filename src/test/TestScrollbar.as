package test
{
	import com.dreamana.controls.Button;
	import com.dreamana.controls.Label;
	import com.dreamana.controls.ScrollBar;
	import com.dreamana.controls.skins.SliderSkin;
	import com.dreamana.controls.skins.SliderTextureSkin;
	import com.dreamana.controls.skins.SpinnerSkin;
	import com.dreamana.controls.skins.SpinnerTextureSkin;
	import com.dreamana.gui.UITextureClip;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	public class TestScrollBar extends Sprite
	{
		private var scrollbar:ScrollBar; 
		
		public function TestScrollBar()
		{
			stage? init() : this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event=null):void
		{
			if(event) this.removeEventListener(event.type, init);
			
			//start
			scrollbar = new ScrollBar();
			this.addChild(scrollbar);
			
			scrollbar.setSize(300, 20);
			scrollbar.percent = 0.25;
			scrollbar.step = 0.25;
			scrollbar.value = 0.25;
			
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
		
		private function coloring():void
		{
			var c0:uint = Math.random() * 0xffffff;//0xffffff;
			var c1:uint = Math.random() * 0xffffff;//0xffcc00;
			
			scrollbar.spinner.skin.setStyle("face-color", c1);
			scrollbar.spinner.skin.setStyle("border-color", c1);
			scrollbar.spinner.skin.setStyle("arrow-color", c0);
			scrollbar.slider.skin.setStyle("handle-color", c1);
			scrollbar.slider.skin.setStyle("track-color", c0);
		}
		
		private function skinningSpinner():void
		{
			var skin:SpinnerTextureSkin = new SpinnerTextureSkin();
			
			var clip0:UITextureClip = new UITextureClip(new Rectangle(2, 2, 40, 20));
			var clip1:UITextureClip = new UITextureClip(new Rectangle(2, 46, 22, 22));
			
			skin.setStyle("increment-normal-9grid", new Rectangle(5, 5, 40-10, 20-10));
			skin.setStyleAsync("increment-normal-image", clip0);
			skin.setStyle("increment-down-9grid", new Rectangle(5, 5, 22-10, 22-10));
			skin.setStyleAsync("increment-down-image", clip1);
			
			skin.setStyle("decrement-normal-9grid", new Rectangle(5, 5, 40-10, 20-10));
			skin.setStyleAsync("decrement-normal-image", clip0);
			skin.setStyle("decrement-down-9grid", new Rectangle(5, 5, 22-10, 22-10));
			skin.setStyleAsync("decrement-down-image", clip1);
			
			scrollbar.spinner.skin = skin;
			
			var loader:Loader = new Loader();
			clip0.loader = loader;
			clip1.loader = loader;
			
			loader.load(new URLRequest("../assets/ui.png"));
		}
		
		private function skinningSlider():void
		{
			var skin:SliderTextureSkin = new SliderTextureSkin();
			
			var clip0:UITextureClip = new UITextureClip(new Rectangle(2, 2, 40, 20));
			var clip1:UITextureClip = new UITextureClip(new Rectangle(2, 46, 22, 22));
			
			skin.setStyle("track-9grid", new Rectangle(5, 5, 40-10, 20-10));
			skin.setStyleAsync("track-image", clip0);
			skin.setStyle("handle-9grid", new Rectangle(5, 5, 22-10, 22-10));
			skin.setStyleAsync("handle-image", clip1);
			
			scrollbar.slider.skin = skin;
			
			var loader:Loader = new Loader();
			clip0.loader = loader;
			clip1.loader = loader;
			
			loader.load(new URLRequest("../assets/ui.png"));
		}
		
		
		private function onButtonClick(event:MouseEvent):void
		{
			switch(event.currentTarget.name)
			{
				case "buttonResize":
					var w:int, h:int;
					if(scrollbar.orientation == ScrollBar.HORIZONTAL) {
						w = 100 + int(Math.random() * 400);
						h = 10  + int(Math.random() * 40);
						scrollbar.changeButtonSize(h, h);
						scrollbar.setSize(w, h);
					}
					else {
						w = 10 + int(Math.random() * 40);
						h = 100 + int(Math.random() * 400);
						scrollbar.changeButtonSize(w, w);
						scrollbar.setSize(w, h);
					}
					break;		
				
				case "buttonColoring":
					coloring()
					break;
				
				case "buttonEnabler":
					scrollbar.enabled = !scrollbar.enabled;
					break;
				
				case "buttonSkinning":
					skinningSpinner();
					skinningSlider();
					break;
				
				case "buttonOrientation":
					scrollbar.orientation = (scrollbar.orientation == ScrollBar.HORIZONTAL)? ScrollBar.VERTICAL : ScrollBar.HORIZONTAL;
					break;
				
				case "buttonDefault":
					scrollbar.spinner.skin = new SpinnerSkin();
					scrollbar.slider.skin = new SliderSkin();
					break;
				
				case "buttonPercent":
					scrollbar.slider.percent = Math.random();
					break;
				
				case "buttonTrackClick":
					scrollbar.slider.trackClickEnabled = !scrollbar.slider.trackClickEnabled;
					break;
			}
		}
	}
}