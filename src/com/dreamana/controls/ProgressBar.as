package com.dreamana.controls
{
	import com.dreamana.controls.skins.ProgressBarSkin;
	import com.dreamana.gui.SkinnableComponent;
	
	public class ProgressBar extends SkinnableComponent
	{
		public static const STATE_NORMAL:String = "normal";
		public static const STATE_INDETERMINATE:String = "indeterminate";
		public static const STATE_DISABLED:String = "disabled";
		
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		
		protected var _value:Number;
		protected var _indeterminate:Boolean = false;
		protected var _direction:String;
		
		
		public function ProgressBar()
		{
			//default setting
			_width = 100;
			_height = 20;
			_direction = RIGHT;
			_value = 0.0;
			_skinProps = { 
				state: STATE_NORMAL,
				direction: _direction,
				value: _value
			};
			_skinClass = ProgressBarSkin;
			
			//view
			this.addChildren();
		}
				
		protected function changeState(state:String):void
		{
			_skinProps["state"] = state;
			this.updateSkinProps();
		}
		
		protected function changeDirection(direction:String):void
		{
			_direction = direction;
			
			_skinProps["direction"] = direction;
			this.updateSkinProps();
		}
		
		protected function changeValue(value:Number):void
		{
			_value = value;
			
			if(!_enabled) return;
			
			_skinProps["value"] = value;
			this.updateSkinProps();
		}
		
		//--- Event Handlers ---
		
		//--- Getter/setters ---
		
		override public function set enabled(v:Boolean):void
		{
			super.enabled = v;
			
			//enabled | disabled state
			if(_enabled) {
				if(_indeterminate) changeState( STATE_INDETERMINATE );
				else changeState( STATE_NORMAL );
				
				//update value
				changeValue(_value);
			}
			else {
				changeState( STATE_DISABLED );
			}
		}
		
		public function get indeterminate():Boolean { return _indeterminate; }
 		public function set indeterminate(value:Boolean):void {
			_indeterminate = value
			
			if(_enabled) {
				if(_indeterminate) changeState( STATE_INDETERMINATE );
				else changeState( STATE_NORMAL );
			}
		}
		
		public function get value():Number { return _value; }
		public function set value(v:Number):void {
			changeValue(v);
		}
		
		public function get direction():String { return _direction; }
		public function set direction(value:String):void {
			changeDirection(value);
		}
		
	}
}