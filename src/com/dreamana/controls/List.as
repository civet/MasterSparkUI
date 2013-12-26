package com.dreamana.controls
{	
	import com.dreamana.controls.layouts.VBoxLayout;
	import com.dreamana.gui.SkinnableComponent;
	import com.dreamana.gui.UIComponent;
	import com.dreamana.gui.UISkin;
	
	import flash.events.Event;
	

	public class List extends UIComponent
	{
		protected var _itemClass:Class;
		protected var _itemWidth:int;
		protected var _itemHeight:int;
		
		protected var _group:ToggleGroup;
		protected var _layout:VBoxLayout;
		
		protected var _listData:Array;
		
		
		public function List()
		{
			//default setting
			_itemClass = ListItem;
			_itemWidth = 100;
			_itemHeight = 20;
			
			_group = new ToggleGroup();
			
			_layout = new VBoxLayout();
		}
				
		protected function removeAllItems():void
		{
			//remove from group
			var items:Array = _group.removeAllItems();
			
			//remove from displaylist
			var i:int = items.length;
			while(i--) {
				var item:ListItem = items[i] as ListItem;
				if(item.parent == this) this.removeChild(item);
				
				//recycle object to pool
				this.disposeItem(item);
			}
			
			//remove from layout
			_layout.removeAllElements();
		}
				
		override protected function redraw():void
		{
			//remove old items (and resue items)
			removeAllItems();
						
			//add new items
			var item:ListItem;
			var num:int = _listData ? _listData.length : 0;
			for(var i:int = 0; i < num; ++i)
			{
				var itemData:Object = _listData[i];
				
				//get object from pool
				item = this.createItem();
				
				//reset object
				item.reset( itemData );
				item.setSize( _itemWidth, _itemHeight );
				
				_group.addItem(item);
				_layout.addElement(item);
				this.addChild(item);
			}
		}
		
		protected function refresh():void
		{
			var w:int = _layout.width;
			var h:int = _layout.height;
			
			//update
			this.redraw();
			
			if(w != _layout.width || h != _layout.height) this.dispatchEvent(new Event(Event.RESIZE));
		}
		
		public function setItemRenderer(value:Class):void
		{
			_itemClass = value;
			
			//clear all old items (do not resue)
			removeAllItems();
			_itemPool.length = 0;
			
			//update
			refresh();
		}
				
		//--- Object Pool ----		
		
		protected var _itemPool:Array = [];
		
		protected function createItem():ListItem {
			return _itemPool.pop() || new _itemClass();
		}
		
		protected function disposeItem(item:ListItem):void {
			if(item) _itemPool.push(item);
		}
		
		//--- Getter/setters ---
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			
			//enabled | disabled state
			_group.enabled = false;
		}
		
		override public function get width():Number { return _layout.width; }
		override public function set width(value:Number):void {
			_layout.width = value;
		}
		
		override public function get height():Number { return _layout.height; }
		override public function set height(value:Number):void {
			_layout.height = value;
		}
		
		public function get itemWidth():int { return _itemWidth; }
		public function set itemWidth(value:int):void {
			_itemWidth = value;
			
			//update
			refresh();
		}
		
		public function get itemHeight():int { return _itemHeight; }
		public function set itemHeight(value:int):void {
			_itemHeight = value;
			
			//update
			refresh();
		}
		
		public function get data():Array { return _listData; }
		public function set data(value:Array):void
		{
			_listData = value;
			
			//update
			refresh();
		}
		
		public function get group():ToggleGroup { return _group; }
	}
}