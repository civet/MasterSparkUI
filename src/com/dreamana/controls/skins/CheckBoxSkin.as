package com.dreamana.controls.skins
{
	import com.dreamana.controls.Toggle;
	import com.dreamana.gui.UISkin;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	
	public class CheckBoxSkin extends UISkin
	{
		//element
		protected var _back:Shape;
		protected var _face:Shape;
		
		
		public function CheckBoxSkin()
		{
			//elements
			_back = new Shape();
			
			_face = new Shape();
			_face.x = 1;
			_face.y = 1;
			
			//elementList
			this.addPart("back", _back);
			this.addPart("face", _face);
		}
		
		override public function redraw():void
		{
			var g:Graphics;
			
			var w:int = _width;
			var h:int = _height;
			var size:int = _height -1;
			var state:String = _props["state"];
			var selected:Boolean = _props["selected"];
						
			switch(state)
			{
				case Toggle.STATE_OVER:
					if( !selected ) {
						g = _back.graphics;
						g.clear();
						g.beginFill(0xeeeeee, 1);
						g.drawRect(0, 0, _width, _height);
						
						g.lineStyle(1, 0x666666);
						g.beginFill(0xffffff);
						g.drawRect(size/4, size/4, size/2, size/2);
						g.endFill();
					}
					else {
						g = _back.graphics;
						g.clear();
						
						g.beginFill(0xeeeeee, 1);
						g.drawRect(0, 0, _width, _height);
						
						g.lineStyle(1, 0x666666);
						g.beginFill(0xffffff);
						g.drawRect(size/4, size/4, size/2, size/2);
						g.endFill();
						
						g.lineStyle(1, 0x333333);
						g.moveTo(size/4, size/2);
						g.lineTo(size/2, size*3/4);
						g.lineTo(size*7/8, size/8);
					}
					break;
				
				case Toggle.STATE_DOWN:
					
					break;
				
				case Toggle.STATE_DISABLED:
					if( !selected ) {
						g = _back.graphics;
						g.clear();
						
						g.beginFill(0xccffff, 0);
						g.drawRect(0, 0, _width, _height);
						
						g.lineStyle(1, 0x666666);
						g.beginFill(0xeeeeee);//disable - gray
						g.drawRect(size/4, size/4, size/2, size/2);
						g.endFill();
					}
					else {
						g = _back.graphics;
						g.clear();
						
						g.beginFill(0xccffff, 0);
						g.drawRect(0, 0, _width, _height);
						
						g.lineStyle(1, 0x666666);
						g.beginFill(0xeeeeee);//disable - gray
						g.drawRect(size/4, size/4, size/2, size/2);
						g.endFill();
						
						g.lineStyle(1, 0x333333);
						g.moveTo(size/4, size/2);
						g.lineTo(size/2, size*3/4);
						g.lineTo(size*7/8, size/8);
					}
					break;
				
				case Toggle.STATE_NORMAL:
					
				default:
					if( selected ) {
						g = _back.graphics;
						g.clear();
						
						g.beginFill(0xccffff, 0);
						g.drawRect(0, 0, _width, _height);
						
						g.lineStyle(1, 0x666666);
						g.beginFill(0xffffff);
						g.drawRect(size/4, size/4, size/2, size/2);
						g.endFill();
						
						g.lineStyle(1, 0x333333);
						g.moveTo(size/4, size/2);
						g.lineTo(size/2, size*3/4);
						g.lineTo(size*7/8, size/8);
					}
					else {
						g = _back.graphics;
						g.clear();
						g.beginFill(0xccffff, 0);
						g.drawRect(0, 0, _width, _height);
						
						g.lineStyle(1, 0x666666);
						g.beginFill(0xffffff);
						g.drawRect(size/4, size/4, size/2, size/2);
						g.endFill();
					}
					break;
			}
		}
	}
}