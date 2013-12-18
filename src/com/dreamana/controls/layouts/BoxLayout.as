package com.dreamana.controls.layouts
{
	import com.dreamana.gui.UILayout;
	
	import flash.events.Event;
	
	
	public class BoxLayout extends UILayout
	{		
		public function BoxLayout()
		{
		}
		
		/**
		 * add element (with Method chaining)
		 * @param element	element could be DisplayObject or UILayout
		 * @param index		from 0 to length(-1)
		 * @return			self		
		 */		
		public function add(element:Object, index:int=-1):BoxLayout
		{
			if(index == -1) addElement(element);
			else addElementAt(element, index);
			return this;
		}
			
		//--- Getter/setters ---
		
		override public function get x():Number { return _x; }
		override public function set x(value:Number):void {
			//super.x = value;
			
			//change origin-x only, do not change displayobject.x
			_x = Math.round(value);
			this.invalidate();
		}
		
		override public function get y():Number { return _y; }
		override public function set y(value:Number):void {
			//super.y = value;
			
			//change origin-y only, do not change displayobject.y
			_y = Math.round(value);
			this.invalidate();
		}
		
		override public function set width(value:Number):void {
			//do nothing
		}
		
		override public function set height(value:Number):void {
			//do nothing
		}
	}
}