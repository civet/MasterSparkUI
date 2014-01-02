package com.dreamana.controls.skins
{
	import com.dreamana.controls.Button;
	import com.dreamana.gui.UISkin;
	
	import flash.display.Graphics;
	import flash.display.Shape;

	public class DropdownButtonSkin extends UISkin
	{
		//element
		protected var _arrow:Shape;
		
		//style
		protected var _arrowColor:int;
		
		
		public function DropdownButtonSkin()
		{
			//default setting
			_arrowColor = 0x666666;
			
			//elements
			_arrow = new Shape();
			
			//elementList
			this.addPart("arrow", _arrow);
		}
		
		override protected function redraw():void
		{
			var g:Graphics;
			
			var w:int = _width;
			var h:int = _height;
			var state:String = _props["state"];
			var buttonWidth:int = w;
			var buttonHeight:int = h;
			
			switch(state)
			{
				case Button.STATE_OVER:
					g = _arrow.graphics;
					g.clear();
					fillRect32(g, getRectangle(0, 0, buttonWidth, buttonHeight), 0x00 );
					g.beginFill(0x0);
					g.moveTo(int(buttonWidth/2), int(buttonHeight*3/4));
					g.lineTo(int(buttonWidth/4), int(buttonHeight/4));
					g.lineTo(int(buttonWidth*3/4), int(buttonHeight/4));
					g.endFill();
					break;
								
				case Button.STATE_DISABLED:
					g = _arrow.graphics;
					g.clear();
					fillRect32(g, getRectangle(0, 0, buttonWidth, buttonHeight), 0x00 );
					g.beginFill(0xcccccc);//disable - gray
					g.moveTo(int(buttonWidth/2), int(buttonHeight*3/4));
					g.lineTo(int(buttonWidth/4), int(buttonHeight/4));
					g.lineTo(int(buttonWidth*3/4), int(buttonHeight/4));
					g.endFill();
					break;
				
				case Button.STATE_NORMAL:
				case Button.STATE_DOWN:	
				default:
					g = _arrow.graphics;
					g.clear();
					fillRect32(g, getRectangle(0, 0, buttonWidth, buttonHeight), 0x00 );
					g.beginFill(_arrowColor);
					g.moveTo(int(buttonWidth/2), int(buttonHeight*3/4));
					g.lineTo(int(buttonWidth/4), int(buttonHeight/4));
					g.lineTo(int(buttonWidth*3/4), int(buttonHeight/4));
					g.endFill();
					break;
			}
		}
		
		override public function setStyle(style:String, value:Object):void
		{
			switch(style) {
				case "arrow-color":
					_arrowColor = value as Number;
					invalidate();
					break;
			}
		}
	}
}