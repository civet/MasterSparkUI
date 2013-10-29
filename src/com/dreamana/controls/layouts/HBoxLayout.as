package com.dreamana.controls.layouts
{
	import flash.events.Event;
	
	public class HBoxLayout extends BoxLayout
	{
		public static const TOP:String = "top";
		public static const BOTTOM:String = "bottom";
		public static const MIDDLE:String = "middle";
		public static const NONE:String = "none";
		
		protected var _spacing:int = 0;
		protected var _alignment:String = NONE;
		
		
		public function HBoxLayout(spacing:int=0, alignment:String="none")
		{
			_spacing = spacing;
			_alignment = alignment;
		}
		
		override protected function update():void
		{
			var offsetX:int = Math.round(_x);
			var offsetY:int = Math.round(_y);
			
			var oldWidth:Number = _width;
			var oldHeight:Number = _height;
			
			_width = 0;
			_height = 0;
			
			var posX:int = 0;
			var num:int = _elements.length;
			for(var i:int = 0; i < num; ++i)
			{
				var element:Object = _elements[i];
				element.x = posX + offsetX;
				
				posX += element.width;
				posX += _spacing;
				
				_width += element.width;
				_height = (element.height > _height) ? element.height : _height;
			}
			
			_width += _spacing * (num - 1);
			
			//do alignment
			for(i = 0; i < num; i++) 
			{
				element = _elements[i];
				switch(_alignment) {
					case TOP:
						element.y = offsetY;
						break;
					
					case BOTTOM:
						element.y = (_height - element.height) + offsetY;
						break;
					
					case MIDDLE:
						element.y = (_height - element.height >> 1) + offsetY;
						break;
					
					case NONE:
						//TODO: how to?
						element.y = offsetY;
						break;
				}
			}
			
			//dispatch
			if(_width != oldWidth || _height != oldHeight) 
				this.dispatchEvent(new Event(Event.RESIZE));
		}
		
		//--- Event Handlers ---
		
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
	}
}