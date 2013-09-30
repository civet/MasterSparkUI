package test
{
	import com.dreamana.controls.NumericStepper;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextFormat;
	
	public class TestNumericStepper extends Sprite
	{
		private var stepper:NumericStepper; 
		
		public function TestNumericStepper()
		{
			stage? init() : this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event=null):void
		{
			if(event) this.removeEventListener(event.type, init);
		
			//start
			stepper = new NumericStepper();
			this.addChild(stepper);
			
			/*stepper.setSize(200, 40);
			stepper.minimum = -10;
			stepper.maximum = 10;
			stepper.allowValueWrap = true;*/
		}
	}
}