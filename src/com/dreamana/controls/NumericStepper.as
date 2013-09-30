package com.dreamana.controls
{
	import com.dreamana.gui.UIComponent;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class NumericStepper extends UIComponent
	{
		public var input:TextInput;
		public var spinner:Spinner;
		
		protected var _spinnerWidth:int;
		protected var _spinnerHeight:int;
		
		
		public function NumericStepper()
		{
			//default setting
			_width = 100;
			_height = 20;
			_spinnerWidth = 20;
			_spinnerHeight = 20;
						
			//view
			this.addChildren();
		}
		
		protected function addChildren():void
		{
			input = new TextInput();
			spinner = new Spinner();
			
			this.addChild(input);
			this.addChild(spinner);
			
			//set size of children 
			input.setSize(_width - _spinnerWidth, _height, false);
			spinner.setSize(_spinnerWidth, _spinnerHeight, false);
			spinner.x = input.width;
			
			input.setTextFieldProps({restrict: "-0123456789."});
			updateInput();
						
			input.addEventListener(KeyboardEvent.KEY_DOWN, onInputKeyDown);
			spinner.addEventListener(Event.CHANGE, onSpinnerChange);
		}
				
		override public function setSize(w:Number, h:Number, deferred:Boolean=true):void
		{
			//set size of children 
			_spinnerWidth = h;
			_spinnerHeight = h;
			input.setSize(w - _spinnerWidth, h, deferred);
			spinner.setSize(_spinnerWidth, _spinnerHeight, deferred);
			spinner.changeButtonSize(h, h/2-1);
			spinner.x = input.width;
			
			super.setSize(w, h, deferred);
		}
		
		protected function updateInput():void
		{
			input.text = (spinner.value == 0) ? '0' : spinner.value.toFixed(_precision);
		}
		
		//--- Event Handlers ---
		
		protected function onSpinnerChange(event:Event):void
		{
			updateInput();
			
			//dispatch
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function onInputKeyDown(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.ENTER)
			{
				spinner.value = parseFloat( input.text );
				
				updateInput();
				
				//dispatch
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		//--- Getter/setters ---
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			
			//enabled | disabled state
			input.enabled = _enabled;
			spinner.enabled = _enabled;
		}
		
		/**
		 * fractionDigits 
		 */
		protected var _precision:int = 0;
		public function get precision():int { return _precision; }
		public function set precision(value:int):void
		{
			_precision = value;
			updateInput();
		}
		
		public function get step():Number { return spinner.step; }
		public function set step(value:Number):void {
			spinner.step = value;
		}
		
		public function get value():Number { return spinner.value; }
		public function set value(v:Number):void {
			spinner.value = v;
		}
		
		public function get minimum():Number { return spinner.minimum; }
		public function set minimum(value:Number):void {
			spinner.minimum = value;
		}
		
		public function get maximum():Number { return spinner.maximum; }
		public function set maximum(value:Number):void {
			spinner.maximum = value;
		}
		
		public function get allowValueWrap():Boolean { return spinner.allowValueWrap; }
		public function set allowValueWrap(value:Boolean):void {
			spinner.allowValueWrap = value;
		}
	}
}