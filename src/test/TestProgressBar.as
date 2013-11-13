package test
{
	import com.dreamana.controls.Button;
	import com.dreamana.controls.Label;
	import com.dreamana.controls.ProgressBar;
	import com.dreamana.controls.skins.ProgressBarSkin;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	
	public class TestProgressBar extends Sprite
	{
		private var progressBar:ProgressBar;
		
		public function TestProgressBar()
		{
			stage? init() : this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event=null):void
		{
			if(event) this.removeEventListener(event.type, init);
		
			//start
			progressBar = new ProgressBar();
			progressBar.setSize(200, 20);
			this.addChild(progressBar);
			
			progressBar.value = 0;
			progressBar.direction = ProgressBar.RIGHT;
			//progressBar.enabled = false;
			
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
			btn.name = "buttonDirection";
			btn.addChild(new Label("Direction"));
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
			
			btn = new Button();
			btn.name = "buttonSkinning";
			btn.addChild(new Label("Skinning"));
			btn.x = 540;
			btn.y = 150;
			this.addChild(btn);
			btn.addEventListener(MouseEvent.CLICK, onButtonClick);
			
			btn = new Button();
			btn.name = "buttonIndeterminate";
			btn.addChild(new Label("Indeterminate"));
			btn.x = 540;
			btn.y = 150;
			this.addChild(btn);
			btn.addEventListener(MouseEvent.CLICK, onButtonClick);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected var time:int;
		protected var step:Number = 0.05;
		protected function onEnterFrame(event:Event):void
		{
			var now:int = flash.utils.getTimer();
			if(now - time < 500) return;
			time = now;
			
			if(progressBar.value + step > 1.0) progressBar.value = 0;
			else progressBar.value += step;
		}
		
		private function onButtonClick(event:MouseEvent):void
		{
			switch(event.currentTarget.name)
			{
				case "buttonResize":
					progressBar.setSize(100 + int(Math.random() * 400), 10 + int(Math.random() * 40) );
					break;		
				
				case "buttonColoring":
					progressBar.skin.setStyle("face-color", 0xffffff * Math.random());
					progressBar.skin.setStyle("background-color", 0xffffff * Math.random());
					break;
				
				case "buttonEnabler":
					progressBar.enabled = !progressBar.enabled;
					break;
				
				case "buttonDirection":
					progressBar.direction = (progressBar.direction == ProgressBar.RIGHT)? ProgressBar.LEFT : ProgressBar.RIGHT;
					break;
				
				case "buttonDefault":
					progressBar.skin = new ProgressBarSkin();
					break;
				
				case "buttonSkinning":
					
					break;
				
				case "buttonIndeterminate":
					progressBar.indeterminate = !progressBar.indeterminate;
					
					if(progressBar.indeterminate) stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
					else stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
					break;
			}
		}
	}
}