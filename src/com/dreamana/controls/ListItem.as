package com.dreamana.controls
{
	import com.dreamana.controls.skins.ListItemSkin;
	import com.dreamana.gui.SkinnableComponent;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
		
	public class ListItem extends SkinnableComponent implements IToggle
	{
		//mouse state
		public static const STATE_NORMAL:String = "normal";
		public static const STATE_OVER:String = "over";
		public static const STATE_DOWN:String = "down";
		public static const STATE_DISABLED:String = "disabled";
		
		protected var _selected:Boolean;
		protected var _autoToggleEnabled:Boolean = true;
		
		public function ListItem()
		{
			//default setting
			_width = 100;
			_height = 20;
			_selected = false;
			_skinProps = {state: STATE_NORMAL, selected: _selected};
			_skinClass = ListItemSkin;
			
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
		
		/**
		 * reset the appearance by data
		 */
		public function reset(itemData:Object):void
		{
			for(var key:String in itemData) {
				_skinProps[key] = itemData[key];
			}
			this.updateSkinProps();
		}
		
		//--- Event Handlers ---
		
		protected var _isDown:Boolean;
		
		protected function onPress(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onRelease);
			
			//down state			
			changeState( STATE_DOWN );
			
			_isDown = true;
		}
		
		protected function onRelease(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onRelease);
			
			//up state (or disabled state)
			if(_enabled) changeState( (event.target == this)? STATE_OVER : STATE_NORMAL );
			else changeState( STATE_DISABLED );
			
			//auto toggle
			if(_enabled && event.target == this && _autoToggleEnabled)
			{
				_selected = !_selected;
				
				changeSelection( _selected );
			}
			
			_isDown = false;
		}
		
		protected function onOver(event:MouseEvent):void
		{
			//down | over state
			if(_enabled) {
				//changeState( (_isDown && event.buttonDown) ? STATE_DOWN : STATE_OVER );
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
			
			//enabled | disabled state
			if(value) changeState( STATE_NORMAL );
			else changeState( STATE_DISABLED );
		}
		
		public function get selected():Boolean { return _selected; }
		public function set selected(value:Boolean):void
		{
			_selected = value;
			
			changeSelection( _selected );
		}
		
		public function get autoToggleEnabled():Boolean { return _autoToggleEnabled; }
		public function set autoToggleEnabled(value:Boolean):void
		{
			_autoToggleEnabled = value;
		}
	}
}