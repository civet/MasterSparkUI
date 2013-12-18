package com.dreamana.gui
{
	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * Base Class for Layout
	 * 
	 * There's no need to add layout to DisplayList.
	 * inherited from UIComponent for using Deferred Rendering feature.
	 * 
	 * @author civet (dreamana.com)
	 */
	public class UILayout extends UIComponent
	{
		protected var _elements:Array = [];
		
		public function UILayout()
		{
		}
		
		public function addElement(element:Object):Object
		{
			return addElementAt(element, _elements.length);
		}
		
		public function addElementAt(element:Object, index:int):Object
		{
			if( !(element is DisplayObject || element is UILayout) ) 
				throw new Error("This type of element is unsupported.");
			
			if(index == _elements.length) _elements[index] = element;
			else _elements.splice( index, 0, element );
			
			element.addEventListener(Event.RESIZE, onElementResize);
			
			this.updateSize();
			
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
				
				this.updateSize();
			}
			return element;
		}
		
		public function removeAllElements():Array
		{
			var element:Object;
			var i:int = _elements.length;
			while(i--) {
				element = _elements[i];
				element.removeEventListener(Event.RESIZE, onElementResize);
			}
			
			var removed:Array = _elements.concat();
			_elements.length = 0;
			
			this.updateSize();
			
			return removed;
		}
		
		public function getElementAt(index:int):Object
		{
			return _elements[index];
		}
		
		public function getElementIndex(element:Object):int
		{
			return _elements.indexOf(element);
		}
		
		protected function updateSize():void
		{
			//override in subclasses
			
			//1. measure
			//2. invalidate
		}
		
		//--- Event Handlers ---
		
		protected function onElementResize(event:Event):void
		{
			this.updateSize();
		}
		
		//--- Getter/setters ---
		
		public function get numElements():int { return _elements.length; }
	}
}