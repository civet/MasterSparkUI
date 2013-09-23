package com.dreamana.controls
{	
	import com.dreamana.controls.skins.ToggleButtonSkin;
	import com.dreamana.gui.SkinnableComponent;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	
	public class Toggle extends SkinnableComponent
	{
		//mouse state
		public static const STATE_NORMAL:String = "normal";
		public static const STATE_OVER:String = "over";
		public static const STATE_DOWN:String = "down";
		public static const STATE_DISABLED:String = "disabled";
		
		//selection
		public static const SELECTED:String = "selected";
		public static const UNSELECTED:String = "unselected";
		
		protected var _mouseState:String;
		protected var _selected:Boolean;
		
		
		public function Toggle()
		{
			//default setting
			_width = 100;
			_height = 20;
			_mouseState = STATE_NORMAL;
			_selected = false;
			_skinState = _mouseState + "|"+ ( _selected ? SELECTED : UNSELECTED );
			_skinClass = ToggleButtonSkin;
			
			//view
			this.addChildren();
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN, onPress);
			this.addEventListener(MouseEvent.ROLL_OVER, onOver);
			this.addEventListener(MouseEvent.ROLL_OUT, onOut);
			this.buttonMode = true;
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onPress);
			this.removeEventListener(MouseEvent.ROLL_OVER, onOver);
			this.removeEventListener(MouseEvent.ROLL_OUT, onOut);
			this.buttonMode = false;
		}
		
		//--- Event Handlers ---
		
		protected function onPress(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onRelease);
			
			//down state			
			changeState( STATE_DOWN );
		}
		
		protected function onRelease(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onRelease);
			
			//up state (or disabled state)
			var mouseState:String;
			if(_enabled) {
				if( event.target == this ) {
					//auto toggle
					_selected = !_selected;
					
					mouseState = STATE_OVER;
				}
				else {
					mouseState = STATE_NORMAL;
				}				
			}
			else {
				mouseState = STATE_DISABLED ;
			}
			
			changeState( mouseState );
		}
		
		protected function onOver(event:MouseEvent):void
		{
			//down | over state
			if(_enabled) {
				//changeState( event.buttonDown ? STATE_DOWN : STATE_OVER );
				changeState( STATE_OVER );
			}			
		}
		
		protected function onOut(event:MouseEvent):void
		{
			//up state
			if(_enabled) {
				changeState( STATE_NORMAL );
			}
		}
				
		override protected function changeState(mouseState:String):void
		{
			_mouseState = mouseState;
			
			_skinState = _mouseState + "|" + ( _selected ? SELECTED : UNSELECTED );
			
			if(_skin) _skin.state = _skinState;
		}
				
		//--- Getter/setters ---
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			
			//enabled(up) | disabled state
			if(value) changeState( STATE_NORMAL );
			else changeState( STATE_DISABLED );
		}
				
		public function get selected():Boolean { return _selected; }
		
		public function set selected(value:Boolean):void {
			_selected = value;
			
			_skinState = _mouseState + "|" + ( _selected ? SELECTED : UNSELECTED );
			
			_skin.state = _skinState;
		}
	}
}