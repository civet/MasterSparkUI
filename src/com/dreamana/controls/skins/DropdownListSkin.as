package com.dreamana.controls.skins
{
	import com.dreamana.gui.UISkin;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	
	public class DropdownListSkin extends UISkin
	{
		//element
		protected var _back:Shape;
		
		//style
		protected var _backColor:int;
		protected var _backFilters:Array;
		protected var _borderColor:int;
		
		
		public function DropdownListSkin()
		{
			//default setting
			_backColor = 0xffffff;
			//_backFilters = [getShadow(2)];
			_borderColor = 0xcccccc;
			
			//elements
			_back = new Shape();
						
			//elementList
			this.addPart("back", _back);
		}
		
		override protected function redraw():void
		{
			var g:Graphics;
			
			var w:int = _width;
			var h:int = _height;
			
			g = _back.graphics;
			g.clear();
			fillRect(g, getRectangle(0, 0, w, h), _backColor);
			
			if(_borderColor >= 0) {
				g.lineStyle(1, _borderColor);
				g.drawRect(0, 0, w-1, h-1);
			}
						
			//_back.filters = _backFilters;
		}
		
		override public function setStyle(style:String, value:Object):void
		{
			switch(style) {
				case "background-color":
					_backColor = value as Number;
					invalidate();
					break;
				
				case "border-color":
					_borderColor = value as Number;
					invalidate();
					break;
			}
		}
	}
}