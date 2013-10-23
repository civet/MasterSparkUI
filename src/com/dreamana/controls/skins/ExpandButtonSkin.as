package com.dreamana.controls.skins
{
	import com.dreamana.controls.Toggle;
	import com.dreamana.gui.UISkin;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	
	public class ExpandButtonSkin extends UISkin
	{
		//element
		protected var _arrow:Shape;
		
		//style
		protected var _arrowColor:int;
		
		public function ExpandButtonSkin()
		{
			//default setting
			_arrowColor = 0x666666;
			
			//elements
			_arrow = new Shape();
			
			//elementList
			//this.addPart("back", _arrow);
			this.addPart("face", _arrow);
		}
		
		override protected function redraw():void
		{
			var g:Graphics;
			
			var w:int = _width;
			var h:int = _height;
			var state:String = _props["state"];
			var selected:Boolean = _props["selected"];
			var buttonWidth:int = w;
			var buttonHeight:int = h;
			
			switch(state)
			{
				/*
				case Toggle.STATE_OVER:
					
					break;
				*/
				case Toggle.STATE_DISABLED:
					if( selected ) {
						g = _arrow.graphics;
						g.clear();
						fillRect32(g, getRectangle(0, 0, buttonWidth, buttonHeight), 0x00 );
						g.beginFill(0xcccccc);//disable - gray
						g.moveTo(int(buttonWidth/2), int(buttonHeight*3/4));
						g.lineTo(int(buttonWidth/4), int(buttonHeight/4));
						g.lineTo(int(buttonWidth*3/4), int(buttonHeight/4));
						g.endFill();
					}
					else {
						g = _arrow.graphics;
						g.clear();
						fillRect32(g, getRectangle(0, 0, buttonWidth, buttonHeight), 0x00 );
						g.beginFill(0xcccccc);//disable - gray
						g.moveTo(int(buttonWidth*3/4), int(buttonHeight/2));
						g.lineTo(int(buttonWidth/4), int(buttonHeight/4));
						g.lineTo(int(buttonWidth/4), int(buttonHeight*3/4));
						g.endFill();
					}
					break;
				
				case Toggle.STATE_NORMAL:
				case Toggle.STATE_DOWN:
				default:
					if( selected ) {
						g = _arrow.graphics;
						g.clear();
						fillRect32(g, getRectangle(0, 0, buttonWidth, buttonHeight), 0x00 );
						g.beginFill(_arrowColor);
						g.moveTo(int(buttonWidth/2), int(buttonHeight*3/4));
						g.lineTo(int(buttonWidth/4), int(buttonHeight/4));
						g.lineTo(int(buttonWidth*3/4), int(buttonHeight/4));
						g.endFill();
					}
					else {
						g = _arrow.graphics;
						g.clear();
						fillRect32(g, getRectangle(0, 0, buttonWidth, buttonHeight), 0x00 );
						g.beginFill(_arrowColor);
						g.moveTo(int(buttonWidth*3/4), int(buttonHeight/2));
						g.lineTo(int(buttonWidth/4), int(buttonHeight/4));
						g.lineTo(int(buttonWidth/4), int(buttonHeight*3/4));
						g.endFill();
					}
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