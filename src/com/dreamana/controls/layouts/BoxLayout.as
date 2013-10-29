package com.dreamana.controls.layouts
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	[Event(name="resize", type="flash.events.Event")]
	
	public class BoxLayout extends EventDispatcher
	{
		protected var _x:Number = 0;
		protected var _y:Number = 0;
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		protected var _elements:Array = [];
		
		public function BoxLayout()
		{
		}
		
		public function add(element:Object, index:int=-1):BoxLayout
		{
			if(index == -1) addElement(element);
			else addElementAt(element, index);
			return this;
		}
		
		public function addElement(element:Object):Object
		{
			return addElementAt(element, _elements.length);
		}
		
		public function addElementAt(element:Object, index:int):Object
		{
			if( !(element is DisplayObject || element is BoxLayout) ) 
				throw new Error("This type of element is unsupported.");
			
			if(index == _elements.length) _elements[index] = element;
			else _elements.splice( index, 0, element );
			
			element.addEventListener(Event.RESIZE, onElementResize);
			update();
			
			return element;
		}
		
		public function removeElement(element:Object):Object
		{
			var element:Object;
			var i:int = _elements.indexOf( element );
			if(i >= 0) {
				element = removeElementAt(i);
			}
			return element;
		}
		
		public function removeElementAt(index:int):Object
		{
			var element:Object;
			var removed:Array = _elements.splice(index, 1);
			if(removed && removed.length > 0) {
				element = removed[0];
				element.removeEventListener(Event.RESIZE, onElementResize);
				update();
			}
			return element;
		}
		
		public function getElementAt(index:int):Object
		{
			return _elements[index];
		}
		
		public function getElementIndex(element:Object):int
		{
			return _elements.indexOf(element);
		}
		
		protected function update():void
		{
			//override in subclass
			
			//dispatch
			this.dispatchEvent(new Event(Event.RESIZE));
		}
		
		//--- Event Handlers ---
		
		protected function onElementResize(event:Event):void
		{
			update();
		}
		
		//--- Getter/setters ---
		
		public function get numElements():int { return _elements.length; }
		
		public function get width():Number { return _width; }
		public function get height():Number { return _height; }
		
		public function get x():Number { return _x; }
		public function set x(value:Number):void {
			_x = value;
			update();
		}
		
		public function get y():Number { return _y; }
		public function set y(value:Number):void {
			_y = value;
			update();
		}
	}
}