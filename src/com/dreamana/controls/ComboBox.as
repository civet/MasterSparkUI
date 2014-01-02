package com.dreamana.controls
{
	import com.dreamana.controls.skins.DropdownButtonSkin;
	import com.dreamana.controls.skins.DropdownListSkin;
	
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class ComboBox extends Autocomplete
	{
		public var button:Button;
		
		public function ComboBox()
		{
			super();
		}
		
		override protected function addChildren():void
		{
			input = new TextInput();
			
			list = new List();
			list.group.deselectable = false;
			
			scroller = new Scroller();
			scroller.autoHideScrollBar = true;
			scroller.skin = new DropdownListSkin();
			
			this.addChild(input);
			scroller.container.addChild(list);
			
			if(_autoCompleteEnabled) input.addEventListener(Event.CHANGE, onTextChange);
			
			//button
			button = new Button();
			button.skin = new DropdownButtonSkin();
			button.setSize(_height, _height);
			button.x = _width - button.width;
			input.addChild(button);
			button.addEventListener(MouseEvent.CLICK, onDropDown);
		}
		
		override public function setSize(w:Number, h:Number, deferred:Boolean=true):void
		{
			button.setSize(h, h);
			button.x = w - button.width;
			
			super.setSize(w, h, deferred);
		}
		
		override protected function focusOn(object:InteractiveObject):void
		{
			if(this.stage) {
				if(!_editable) stage.focus = stage;
				else if(object) stage.focus = object;
			}
		}
		
		//--- Event Handlers ---
		
		protected function onDropDown(event:MouseEvent):void
		{		
			if(list.data != _listData) {
				list.data = _listData;
				
				if(_listData && _listData.length > 0) {
					//reset list width
					list.itemWidth = _width - (_listData.length > maxLines ? scroller.vscrollbar.width : 0);
					
					//reset scroll size
					scroller.height = Math.min(list.height, _height * maxLines);
					
					//reset scroll position
					scrollToSelection();
				}
				else {
					//
				}
			}
			
			if(list.data && list.data.length > 0) {
				list.stage ? closeList() : openList();
			}
		}
		
		//--- Getter/setters ---
		
		protected var _autoCompleteEnabled:Boolean = true;
		
		public function get autoCompleteEnabled():Boolean { return _autoCompleteEnabled; }
		public function set autoCompleteEnabled(value:Boolean):void {
			_autoCompleteEnabled = value;
			
			if(_autoCompleteEnabled) input.addEventListener(Event.CHANGE, onTextChange);
			else input.removeEventListener(Event.CHANGE, onTextChange);
		}
		
		protected var _editable:Boolean = true;
		
		public function get editable():Boolean { return _editable; }
		public function set editable(value:Boolean):void
		{
			_editable = value;
			
			input.textField.mouseEnabled = value;
			input.textField.tabEnabled = value;
		}
	}
}