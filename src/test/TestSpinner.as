package test
{
	import com.dreamana.controls.Button;
	import com.dreamana.controls.Spinner;
	import com.dreamana.controls.TextInput;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TextEvent;
	
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
			input.skin.setStyle("background-color", 0xeeeeee);
			input.text = "0";
			
			spinner.minimum = 0;
			spinner.maximum = 10;
			spinner.allowValueWrap = true;
			spinner.addEventListener(Event.CHANGE, onSpinnerChange);
			
			input.addEventListener(TextEvent.TEXT_INPUT, onTextInput);
			
			/*input.setSize(100, 80);
			spinner.setSize(100, 80);
			spinner.changeButtonSize(100, 38);*/
		}
		
		protected function onTextInput(event:TextEvent):void
		{
			spinner.value = parseInt(input.text);
		}
		
		protected function onSpinnerChange(event:Event):void
		{
			input.text = "" + spinner.value;
		}
	}
}