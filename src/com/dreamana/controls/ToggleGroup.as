package com.dreamana.controls
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;

	[Event(name="select", type="flash.events.Event")]
	
	public class ToggleGroup extends EventDispatcher
	{
		protected var _items:Array = [];
		
		public function ToggleGroup()
		{
		}
		
		public function addItem(item:Toggle):void
		{
			_items[_items.length] = item;
			
			item.addEventListener(MouseEvent.CLICK, onItemClick);
		}
		
		public function removeItem(item:Toggle):void
		{
			var index:int = _items.indexOf(item);
			if(index >= 0) {
				_items.splice(index, 1);
			
				item.removeEventListener(MouseEvent.CLICK, onItemClick);
			}
		}
		
		public function select(item:Toggle):void
		{
			if(_selectedItem) _selectedItem.selected = false;
			
			_selectedItem = item;
			if(_selectedItem) _selectedItem.selected = true;
			
			//dispatch
			this.dispatchEvent(new Event(Event.SELECT));
		}
		
		//--- Event Handlers ---
		
		protected function onItemClick(event:MouseEvent):void
		{
			this.select( event.currentTarget as Toggle);
		}
		
		//--- Getter/setters ---
		
		protected var _selectedItem:Toggle;

		public function get selectedItem():Toggle
		{ 
			return _selectedItem;
		}
		
		public function set selectedItem(value:Toggle):void
		{
			this.select( value );
		}
		
		public function get selectedIndex():int
		{
			return _items.indexOf( _selectedItem );
		}

		public function set selectedIndex(value:int):void
		{
			this.select( _items[ value ] );
		}
	}
}