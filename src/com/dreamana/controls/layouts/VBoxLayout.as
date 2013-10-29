package com.dreamana.controls.layouts
{
	import flash.events.Event;
	
	public class VBoxLayout extends BoxLayout
	{
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		public static const CENTER:String = "center";
		public static const NONE:String = "none";
		
		protected var _spacing:int = 0;
		protected var _alignment:String = NONE;
		
		
		public function VBoxLayout(spacing:int=0, alignment:String="none")
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
			
			var posY:int = 0;
			var num:int = _elements.length;
			for(var i:int = 0; i < num; ++i)
			{
				var element:Object = _elements[i];
				element.y = posY + offsetY;
				
				posY += element.height;
				posY += _spacing;
				
				_width = (element.width > _width) ? element.width : _width;
				_height += element.height;
			}
			
			_height += _spacing * (num - 1);
			
			//do alignment
			for(i = 0; i < num; i++) 
			{
				element = _elements[i];
				switch(_alignment) {
					case LEFT:
						element.x = offsetX;
						break;
					
					case RIGHT:
						element.x = _width - element.width + offsetX;
						break;
					
					case CENTER:
						element.x = (_width - element.width >> 1) + offsetX;
						break;
					
					case NONE:
						//TODO: how to?
						element.x = offsetX;
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