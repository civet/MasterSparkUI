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
		
		protected var _selected:Boolean;
		
		
		public function Toggle()
		{
			//default setting
			_width = 100;
			_height = 20;
			_selected = false;
			_skinProps = {state: STATE_NORMAL, selected: _selected};
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
		
		protected function changeState(state:String):void
		{
			_skinProps["state"] = state;
			this.updateSkinProps();
		}
		
		protected function changeSelection(selected:Boolean):void
		{
			_skinProps["selected"] = selected;
			this.updateSkinProps();
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
			if(_enabled) changeState( (event.target == this)? STATE_OVER : STATE_NORMAL );
			else changeState( STATE_DISABLED );
			
			//auto toggle
			if(_enabled && event.target == this)
			{
				_selected = !_selected;
				
				changeSelection( _selected );
			}
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
				
		//--- Getter/setters ---
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			
			//enabled(up) | disabled state
			if(value) changeState( STATE_NORMAL );
			else changeState( STATE_DISABLED );
		}
				
		public function get selected():Boolean { return _selected; }
		public function set selected(value:Boolean):void
		{
			_selected = value;
			
			changeSelection( _selected );
		}
	}
}