package com.dreamana.controls
{	
	import com.dreamana.controls.skins.ToggleButtonSkin;
	import com.dreamana.gui.SkinnableComponent;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	
	public class Toggle extends SkinnableComponent
	{
		public static const STATE_NORMAL:String = "normal";
		public static const STATE_OVER:String = "over";
		public static const STATE_DOWN:String = "down";
		public static const STATE_DISABLED:String = "disabled";
		
		public static const STATE_SELECTED:String = "selected";
		public static const STATE_UNSELECTED:String = "unselected";
		
		
		public function Toggle()
		{
			//default setting
			_width = 100;
			_height = 20;
			_state = STATE_NORMAL;
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
			changeState( STATE_DOWN + "|" + getSelectState() );
		}
		
		protected function onRelease(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onRelease);
			
			//up state (or disabled state)
			var composite:String;
			if(_enabled) {
				if( event.target == this ) {
					//toggle
					_selected = !_selected;
					
					composite = STATE_OVER;
				}
				else {
					composite = STATE_NORMAL;
				}				
			}
			else {
				composite = STATE_DISABLED ;
			}
			
			changeState( composite + "|" + getSelectState() );
		}
		
		protected function onOver(event:MouseEvent):void
		{
			//down | over state
			var composite:String;
			if(_enabled) {
				//composite = ( event.buttonDown ) ? STATE_DOWN : STATE_OVER;
				composite = STATE_OVER;
			}
			
			changeState( composite + "|" + getSelectState() );
		}
		
		protected function onOut(event:MouseEvent):void
		{
			//up state
			if(_enabled) {
				changeState( STATE_NORMAL + "|" + getSelectState() );
			}
		}
		
		protected function changeState(state:String):void
		{
			_state = state;
			_skin.state = state;
		}
		
		protected function getSelectState():String
		{
			return _selected ? STATE_SELECTED : STATE_UNSELECTED;
		}
		
		//--- Getter/setters ---
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			
			//enabled(up) | disabled state
			var composite:String;
			if(value) composite = STATE_NORMAL;
			else composite = STATE_DISABLED;
			
			changeState( composite + "|" + getSelectState() );
		}
				
		protected var _selected:Boolean;
		public function get selected():Boolean {
			return _selected;
		}
		public function set selected(value:Boolean):void {
			_selected = value;
			
			changeState( _state + "|" + getSelectState() );
		}
	}
}