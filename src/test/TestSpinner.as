package test
{
	import com.dreamana.controls.Button;
	import com.dreamana.controls.Spinner;
	import com.dreamana.controls.TextInput;
	import com.dreamana.controls.skins.SpinnerTextureSkin;
	import com.dreamana.gui.UITextureClip;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	public class TestSpinner extends Sprite
	{
		private var spinner:Spinner;
		private var input:TextInput;
		
		public function TestSpinner()
		{
			stage? init() : this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event=null):void
		{
			if(event) this.removeEventListener(event.type, init);
			
			//start
			spinner = new Spinner();
			this.addChild(spinner);
			
			input = new TextInput();
			input.setTextFieldProps({restrict: "-0123456789."});
			this.addChild(input);
			
			spinner.x = 100;
			input.text = "0";
			
			spinner.minimum = 0;
			spinner.maximum = 10;
			spinner.allowValueWrap = true;
			spinner.addEventListener(Event.CHANGE, onSpinnerChange);
			
			//spinner.enabled = false;
			//input.enabled = false;
			
			/*
			input.setSize(100, 80);
			spinner.setSize(100, 80);
			spinner.changeButtonSize(100, 38);
			*/
			
			spinner.orientation = Spinner.HORIZONTAL;
			spinner.setSize(142, 20);
			spinner.changeButtonSize(20, 20);
			spinner.x = 0;
			input.x = 21;
			
			//skinning();
		}
		
		private function skinning():void
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
			
			spinner.skin = skin;
			
			var loader:Loader = new Loader();
			clip0.loader = loader;
			clip1.loader = loader;
			
			loader.load(new URLRequest("../assets/ui.png"));
		}
				
		private function onSpinnerChange(event:Event):void
		{
			input.text = "" + spinner.value;
		}
	}
}