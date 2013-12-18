package com.dreamana.controls
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;

	[Event(name="select", type="flash.events.Event")]
	
	[Event(name="change", type="flash.events.Event")]
	
	
	public class ToggleGroup extends EventDispatcher
	{
		protected var _items:Array = [];
		
		public function ToggleGroup()
		{
		}
		
		public function addItem(item:IToggle):void
		{
			_items[_items.length] = item;
			
			//change toggle mode
			item.autoToggleEnabled = false;
			
			item.addEventListener(MouseEvent.CLICK, onItemClick);
		}
		
		public function removeItem(item:IToggle):void
		{
			var index:int = _items.indexOf(item);
			if(index >= 0) {
				_items.splice(index, 1);
			
				item.removeEventListener(MouseEvent.CLICK, onItemClick);
			}
		}
		
		public function removeAllItems():Array
		{
			var item:IToggle;
			var i:int = _items.length;
			while(i--) {
				item = _items[i];
				item.removeEventListener(MouseEvent.CLICK, onItemClick);
			}
			
			var removed:Array = _items.concat();
			_items.length = 0;
			return removed;
		}
		
		public function getItem(index:int):IToggle
		{
			return _items[index];
		}
				
		public function select(item:IToggle):void
		{
			var changed:Boolean = (_selectedItem != item);
			
			if(multiselectable) {
				/* Mode: Multiselect */
				
				if(deselectable) {
					//1. toggle
					item.selected = !item.selected;
					
					//2. add to/remove from list
					if(item.selected) _selectedItems.push( item );
					else _selectedItems.splice( _selectedItems.indexOf(item), 1 );
				}
				else {
					//1. select
					item.selected = true;
					
					//2. add to list if not contains
					if(_selectedItems.indexOf(item) == -1) _selectedItems.push( item );
				}
				
				//update current selected item (focus on last one)
				_selectedItem = _selectedItems[_selectedItems.length-1];
			}
			else {
				/* Mode: Single select */
				
				if(changed) {
					if(_selectedItem) _selectedItem.selected = false;
					if(item) item.selected = true;
				}
				else {
					if(deselectable) item.selected = !item.selected;
				}
				
				//update list
				_selectedItems.length = 0;
				if(item.selected) _selectedItems[0] = item;
				
				//update current selected item
				_selectedItem = item.selected ? item : null;
			}
						
			//dispatch
			this.dispatchEvent(new Event(Event.SELECT));
			if(changed) this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		//--- Event Handlers ---
		
		protected function onItemClick(event:MouseEvent):void
		{
			this.select( event.currentTarget as IToggle);
		}
		
		//--- Getter/setters ---
		
		protected var _enabled:Boolean = true;
		
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void {
			_enabled = value;
			
			var i:int = _items.length;
			while(i--) IToggle( _items[i] ).enabled = _enabled;
		}
		
		public function get numItems():int { return _items.length; }
		
		protected var _selectedItem:IToggle;

		public function get selectedItem():IToggle { return _selectedItem; }
		public function set selectedItem(value:IToggle):void {
			this.select( value );
		}
		
		public function get selectedIndex():int {
			return _items.indexOf( _selectedItem );
		}
		public function set selectedIndex(value:int):void {
			this.select( _items[ value ] );
		}
		
		public var deselectable:Boolean = true;
				
		public var multiselectable:Boolean = false;
		
		protected var _selectedItems:Array = [];
		
		public function get selectedItems():Array {
			return _selectedItems;
		}
		
		public function get selectedIndices():Array {
			var a:Array = [];
			var num:int = _selectedItems.length;
			for(var i:int=0; i < num; ++i) {
				a.push( _items.indexOf( _selectedItems[i] ) );
			}
			return a;
		}
	}
}