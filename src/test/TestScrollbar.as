package test
{
	import com.dreamana.controls.ScrollBar;
	import com.dreamana.controls.skins.SliderTextureSkin;
	import com.dreamana.controls.skins.SpinnerTextureSkin;
	import com.dreamana.gui.UITextureClip;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
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
			
			scrollbar.orientation = ScrollBar.VERTICAL;
			
			//scrollbar.enabled = false;
			
			//coloring();
			//skinningSpinner();
			//skinningSlider();
		}
		
		private function coloring():void
		{
			scrollbar.spinner.skin.setStyle("face-color", 0xffcc00);
			scrollbar.spinner.skin.setStyle("border-color", 0xffcc00);
			scrollbar.spinner.skin.setStyle("arrow-color", 0xffffff);
			scrollbar.slider.skin.setStyle("handle-color", 0xffcc00);
			scrollbar.slider.skin.setStyle("track-color", 0xffffff);
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
	}
}