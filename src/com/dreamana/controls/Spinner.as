package com.dreamana.controls
{
	import com.dreamana.controls.skins.SpinnerSkin;
	import com.dreamana.gui.SkinnableComponent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	[Event(name="change", type="flash.events.Event")]
	
	public class Spinner extends SkinnableComponent
	{
		public static const STATE_NORMAL:String = "normal";
		public static const STATE_DISABLED:String = "disabled";
		
		public static const HORIZONTAL:String = "horizontal";
		public static const VERTICAL:String = "vertical";
				
		protected var _value:Number = 0.0;
		protected var _step:Number = 1.0;
		protected var _direction:int = 0;
		protected var _minimum:Number = Number.NEGATIVE_INFINITY;
		protected var _maximum:Number = Number.POSITIVE_INFINITY;
		
		protected var _delayTime:int = 500;
		protected var _repeatTime:int = 100;
		protected var _delayTimer:Timer;
		protected var _repeatTimer:Timer;
		
		protected var _decrementButton:Sprite;
		protected var _incrementButton:Sprite;
		protected var _buttonWidth:int;
		protected var _buttonHeight:int;
		protected var _orientation:String;
		
		
		public function Spinner()
		{
			//default setting
			_width = 20;
			_height = 20;
			_buttonWidth = 20;
			_buttonHeight = 9;
			_orientation = VERTICAL;
			_skinProps = {state: STATE_NORMAL, buttonWidth:_buttonWidth, buttonHeight:_buttonHeight, orientation:_orientation};
			_skinClass = SpinnerSkin;
			
			//timers
			_delayTimer = new Timer(_delayTime, 1);
			_delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onDelayComplete);
			
			_repeatTimer = new Timer(_repeatTime);
			_repeatTimer.addEventListener(TimerEvent.TIMER, onRepeat);
			
			//view
			this.addChildren();
		}
				
		override protected function partAdded(partName:String, instance:Object):void
		{
			if(partName == "incrementButton") {
				_incrementButton = instance as Sprite;
				_incrementButton.name = "buttonIncrement";
				_incrementButton.addEventListener(MouseEvent.MOUSE_DOWN, onButtonDown);
			}
			else if(partName == "decrementButton") {
				_decrementButton = instance as Sprite;
				_decrementButton.name = "buttonDecrement";
				_decrementButton.addEventListener(MouseEvent.MOUSE_DOWN, onButtonDown);
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if(partName == "incrementButton") {
				_incrementButton = instance as Sprite;
				_incrementButton.removeEventListener(MouseEvent.MOUSE_DOWN, onButtonDown);
			}
			else if(partName == "decrementButton") {
				_decrementButton = instance as Sprite;
				_decrementButton.removeEventListener(MouseEvent.MOUSE_DOWN, onButtonDown);
			}
		}
		
		protected function tick():void
		{
			var v:Number = _value;
			
			_value += _step * _direction;
			
			if(_value < _minimum) _value = allowValueWrap ? _maximum : _minimum;
			else if(_value > _maximum) _value = allowValueWrap ? _minimum : _maximum;
			
			//dispatch
			if(_value != v) this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function changeState(state:String):void
		{
			_skinProps["state"] = state;
			
			this.updateSkinProps();
		}
		
		public function changeButtonSize(w:int, h:int):void
		{
			_buttonWidth = w;
			_buttonHeight = h;
			
			_skinProps["buttonWidth"] = w;
			_skinProps["buttonHeight"] = h;
			
			this.updateSkinProps();
		}
		
		protected function changeOrientation(orientation:String):void
		{
			_skinProps["orientation"] = orientation;
			this.updateSkinProps();
		}
		
		//--- Event Handlers ---
		
		protected function onButtonDown(event:MouseEvent):void
		{
			var name:String = event.currentTarget.name;
			switch(name) {
				case "buttonIncrement":
					//tick once
					_direction = 1;
					tick();
					
					//go on until mouse release
					stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
					_delayTimer.start();
					break;
				
				case "buttonDecrement":
					//tick once
					_direction = -1;
					tick();
					
					//go on until mouse release
					stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
					_delayTimer.start();
					break;
			}
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			_delayTimer.stop();
			_repeatTimer.stop();
		}
		
		protected function onDelayComplete(event:TimerEvent):void
		{
			_repeatTimer.start();
		}
		
		protected function onRepeat(event:TimerEvent):void
		{
			tick();
		}
		
		//--- Getter/setters ---
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			
			//enabled | disabled state
			if(value) changeState( STATE_NORMAL );
			else changeState( STATE_DISABLED );
		}
		
		public function get value():Number { return _value; }
		public function set value(v:Number):void {
			
			if(v < _minimum) v = _minimum;
			else if(v > _maximum) v = _maximum;
						
			_value = v;
		}

		public function get minimum():Number { return _minimum; }
		public function set minimum(value:Number):void {
			_minimum = value;
			
			if(_value < _minimum) {
				_value = _minimum;
				
				//dispatch
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}

		public function get maximum():Number { return _maximum; }
		public function set maximum(value:Number):void {
			_maximum = value;
			
			if(_value > _maximum) {
				_value = _maximum;
				
				//dispatch
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		public function get step():Number { return _step; }
		public function set step(value:Number):void {
			_step = value;
		}
		
		public var allowValueWrap:Boolean = false;
		
		public function get reapeatTime():int { return _repeatTime; }
		public function set reapeatTime(value:int):void {
			_repeatTime = (value < 10) ? 10 : value;
			_repeatTimer.delay = _repeatTime;
		}
		
		
		public function get orientation():String { return _orientation; }
		public function set orientation(value:String):void
		{
			//if changed..
			if(_orientation != value) {
				_orientation = value;
				
				//swap width & height
				var w:int, h:int;
				w = _width;
				h = _height;
				setSize(h, w);
				
				//swap width & height of button
				w = _buttonWidth;
				h = _buttonHeight;
				changeButtonSize(h, w);
				
				//new orientation
				changeOrientation(_orientation);
			}
		}
	}
}