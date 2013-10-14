package com.dreamana.controls
{
	import com.dreamana.gui.UIComponent;
	
	import flash.events.Event;
	
	[Event(name="change", type="flash.events.Event")]
	
	public class ScrollBar extends UIComponent
	{
		public static const HORIZONTAL:String = "horizontal";
		public static const VERTICAL:String = "vertical";
		
		public var slider:Slider;
		public var spinner:Spinner;
		
		protected var _orientation:String;
		protected var _buttonWidth:int;
		protected var _buttonHeight:int;
		
		
		public function ScrollBar()
		{
			//default setting
			/*_width = 20;
			_height = 100;
			_buttonWidth = 20;
			_buttonHeight = 20;
			_orientation = VERTICAL;*/
			_width = 100;
			_height = 20;
			_buttonWidth = 20;
			_buttonHeight = 20;
			_orientation = HORIZONTAL;
			
			//view
			this.addChildren();
		}
		
		protected function addChildren():void
		{
			slider = new Slider();
			spinner = new Spinner();
			
			this.addChild(slider);
			this.addChild(spinner);
			
			if(_orientation == HORIZONTAL) {
				spinner.orientation = Spinner.HORIZONTAL;
				spinner.setSize(_width, _height);
				spinner.changeButtonSize(_buttonWidth, _buttonHeight);
				
				//slider.orientation = Slider.HORIZONTAL;
				slider.setSize(_width - _buttonWidth*2/* -2*/, _height);
				slider.x = _buttonWidth/* + 1*/;
				slider.y = 0;
			}
			else {
				//spinner.orientation = Spinner.VERTICAL;
				spinner.setSize(_width, _height);
				spinner.changeButtonSize(_buttonWidth, _buttonHeight);
				
				slider.orientation = Slider.VERTICAL;
				slider.setSize(_width, _height - _buttonHeight*2/* -2*/);
				slider.x = 0;
				slider.y = _buttonHeight/* + 1*/;
			}
			
			spinner.minimum = 0;
			spinner.maximum = 1.0;
			spinner.step = 0.1;
			slider.trackClickEnabled = true;	
			
			spinner.addEventListener(Event.CHANGE, onSpinnerChange);
			slider.addEventListener(Event.CHANGE, onSliderChange);
		}
		
		public function changeButtonSize(w:int, h:int):void
		{
			_buttonWidth = w;
			_buttonHeight = h;
			spinner.changeButtonSize(_buttonWidth, _buttonHeight);
		}
				
		override public function setSize(w:Number, h:Number, deferred:Boolean=true):void
		{
			//set size of children 
			if(_orientation == HORIZONTAL) {
				spinner.orientation = Spinner.HORIZONTAL;
				spinner.setSize(w, h);
				spinner.changeButtonSize(_buttonWidth, _buttonHeight);
				
				slider.orientation = Slider.HORIZONTAL;
				slider.setSize(w - _buttonWidth*2/* -2*/, h);
				slider.x = _buttonWidth/* + 1*/;
				slider.y = 0;
			}
			else {				
				spinner.orientation = Spinner.VERTICAL;
				spinner.setSize(w, h);
				spinner.changeButtonSize(_buttonWidth, _buttonHeight);
				
				slider.orientation = Slider.VERTICAL;
				slider.setSize(w, h - _buttonHeight*2/* -2*/)
				slider.x = 0;
				slider.y = _buttonHeight/* + 1*/;
			}
						
			super.setSize(w, h, deferred);
		}
				
		//--- Event Handler ---
		
		protected function onSpinnerChange(event:Event):void
		{
			slider.value = spinner.value;
			
			//dispatch
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function onSliderChange(event:Event):void
		{
			spinner.value = slider.value;
			
			//dispatch
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		//--- Getter/setters ---
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			
			//enabled | disabled state
			slider.enabled = _enabled;
			spinner.enabled = _enabled;
		}
		
		public function get value():Number { return slider.value; }
		public function set value(v:Number):void {
			slider.value = v;
			spinner.value = v;
		}
		
		public function get percent():Number { return slider.percent; }
		public function set percent(value:Number):void {
			slider.percent = value;
		}
		
		public function get step():Number { return spinner.step; }
		public function set step(value:Number):void { 
			spinner.step = value;
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
			}
		}
	}
}