package com.dreamana.controls.layouts
{
	import flash.events.Event;
	
	public class HBoxLayout extends BoxLayout
	{
		public static const TOP:String = "top";
		public static const BOTTOM:String = "bottom";
		public static const MIDDLE:String = "middle";
		
		protected var _spacing:int = 0;
		protected var _alignment:String = TOP;
		
		
		public function HBoxLayout(spacing:int=0, alignment:String="none")
		{
			_spacing = spacing;
			_alignment = alignment;
		}
		
		override protected function updateSize():void
		{
			var i:int, num:int;
			var element:Object;
			
			//measure width and height
			var w:int = 0;
			var h:int = 0;
			num = _elements.length;
			for(i = 0; i < num; ++i)
			{
				element = _elements[i];
				
				w += element.width + _spacing;
				if(element.height > h) h = element.height;
			}
			w -= _spacing;
			
			this.setSize(w, h);
		}
		
		override protected function redraw():void
		{
			var i:int, num:int;
			var element:Object;
			
			//position elements
			var originX:int = _x;
			var originY:int = _y;
			var posX:int = 0;
			num = _elements.length;
			for(i = 0; i < num; ++i)
			{
				element = _elements[i];
				element.x = posX + originX;
				
				posX += element.width + _spacing;
				
				switch(_alignment) {
					case BOTTOM:
						element.y = _height - element.height + originY;
						break;
					
					case MIDDLE:
						element.y = (_height - element.height >> 1) + originY;
						break;
					
					case TOP:
					default:
						element.y = originY;
						break;
				}
			}
		}
		
		//--- Event Handlers ---
		
		//--- Getter/setters ---
		
		public function get spacing():Number { return _spacing; }
		public function set spacing(value:Number):void {
			_spacing = value;
			this.updateSize();
		}
		
		public function get alignment():String { return _alignment; }
		public function set alignment(value:String):void {
			_alignment = value;
			this.updateSize();
		}
	}
}