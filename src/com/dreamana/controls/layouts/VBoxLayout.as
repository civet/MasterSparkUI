package com.dreamana.controls.layouts
{
	import flash.events.Event;
	
	public class VBoxLayout extends BoxLayout
	{
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		public static const CENTER:String = "center";
		
		protected var _spacing:int = 0;
		protected var _alignment:String = LEFT;
		
		
		public function VBoxLayout(spacing:int=0, alignment:String="none")
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
				
				if(element.width > w) w = element.width;
				h += element.height + _spacing;
			}
			h -= _spacing;
			
			this.setSize(w, h);
		}
		
		override protected function redraw():void
		{
			var i:int, num:int;
			var element:Object;
			
			//position elements
			var originX:int = _x;
			var originY:int = _y;
			var posY:int = 0;
			num = _elements.length;
			for(i = 0; i < num; ++i)
			{
				element = _elements[i];
				element.y = posY + originY;
				
				posY += element.height + _spacing;
				
				switch(_alignment) {
					case RIGHT:
						element.x = _width - element.width + originX;
						break;
					
					case CENTER:
						element.x = (_width - element.width >> 1) + originX;
						break;
					
					case LEFT:
					default:
						element.x = originX;
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