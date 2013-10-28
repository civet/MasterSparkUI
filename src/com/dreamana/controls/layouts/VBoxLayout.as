package com.dreamana.controls.layouts
{
	import com.dreamana.gui.UIComponent;
	import com.dreamana.utils.Broadcaster;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	public class VBoxLayout
	{
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		public static const CENTER:String = "center";
		public static const NONE:String = "none";
		
		protected var _elements:Array = [];
		protected var _spacing:int = 0;
		protected var _alignment:String = NONE;
		protected var _width:int = 0;
		protected var _height:int = 0;
				
		
		public function VBoxLayout(spacing:int=0, alignment:String="none")
		{
			_spacing = spacing;
			_alignment = alignment;
		}
		
		public function add(element:DisplayObject):VBoxLayout
		{
			_elements.push( element );
			update();
			
			//if it could dispatch RESIZE event
			element.addEventListener(Event.RESIZE, onChildResize);
			
			return this;
		}
		
		public function remove(element:DisplayObject):VBoxLayout
		{
			var i:int = _elements.indexOf(element);
			if(i >= 0) _elements.splice(i, 1);
			update();
			
			element.removeEventListener(Event.RESIZE, onChildResize);
			
			return this;
		}
		
		public function getElementAt(index:int):DisplayObject
		{
			return _elements[index];
		}
		
		public function getElementIndex(element:DisplayObject):int
		{
			return _elements.indexOf(element);
		}
			
		protected function update():void
		{
			_width = 0;
			_height = 0;
			var py:int = 0;
			var num:int = _elements.length;
			for(var i:int = 0; i < num; ++i)
			{
				var child:DisplayObject = _elements[i];
				child.y = py;
				
				py += child.height;
				py += _spacing;
				
				_width = (child.width > _width) ? child.width : _width;
				_height += child.height;
			}
			
			_height += _spacing * (num - 1);
			
			//do alignment
			if(_alignment != NONE)
			{
				for(i = 0; i < num; i++) 
				{
					child = _elements[i];
					switch(_alignment) {
						case LEFT:
							child.x = 0;
							break;
						
						case RIGHT:
							child.x = _width - child.width;
							break;
						
						case CENTER:
							child.x = _width - child.width >> 1;
							break;
					}
				}
			}
			
			//dispatch
			updated.dispatch( this );//eventTarget:this
		}
		
		//--- Event Handlers ---
		
		protected function onChildResize(event:Event):void
		{
			update();
		}
		
		//--- Getter/setters ---
		
		public function get spacing():Number { return _spacing; }
		public function set spacing(value:Number):void {
			_spacing = value;
			update();
		}
		
		public function get alignment():String { return _alignment; }
		public function set alignment(value:String):void {
			_alignment = value;
			update();
		}
		
		public function get numElements():int { return _elements.length; }
				
		public function get width():int { return _width; }
		public function get height():int { return _height; }
		
		//--- Signals ---
		
		public var updated:Broadcaster = new Broadcaster();
	}
}