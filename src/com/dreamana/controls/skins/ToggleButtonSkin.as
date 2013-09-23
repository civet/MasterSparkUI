package com.dreamana.controls.skins
{
	import com.dreamana.controls.Toggle;
	import com.dreamana.gui.UISkin;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	
	public class ToggleButtonSkin extends UISkin
	{
		//element
		protected var _back:Shape;
		protected var _face:Shape;
		
		//style
		protected var _faceColor:int;
		protected var _faceFilters1:Array;
		protected var _faceFilters2:Array;
		protected var _faceFilters3:Array;
		protected var _backColor:int;
		protected var _backFilters1:Array;
		protected var _backFilters2:Array;
		protected var _backFilters3:Array;
		
		
		protected var _faceFilters4:Array;
		protected var _backFilters4:Array;
		
		
		public function ToggleButtonSkin()
		{
			//default setting
			_faceColor = 0xffffff;
			_faceFilters1 = [getShadow(1)];//normal
			_faceFilters2 = [getShadow(1, true)];//down
			_faceFilters3 = [getShadow(2)];//over
			_backColor = 0xcccccc;
			_backFilters1 = [getShadow(2, true)];//normal
			_backFilters2 = [getShadow(2, true)];//down
			_backFilters3 = [];//over
			
			_faceFilters4 = [getShadow(2, true)];//over & selected
			_backFilters4 = [getShadow(2, true)];//over & selected
			
			
			//elements
			_back = new Shape();
			
			_face = new Shape();
			_face.x = 1;
			_face.y = 1;
			
			//displayList
			//this.addChild(_back);
			//this.addChild(_face);
			
			//elementList
			this.addPart("back", _back);
			this.addPart("face", _face);
		}
		
		override public function redraw():void
		{
			
			var g:Graphics;
			
			var w:int = _width;
			var h:int = _height;
			
			if(_state) {
				var args:Array = _state.split("|");
				var mouseState:String = args[0];
				var selectState:String = args[1];
			}
				
			switch(mouseState)
			{
				case Toggle.STATE_OVER:
					if(selectState == Toggle.UNSELECTED) {
						g = _back.graphics;
						g.clear();
						fillRect(g, getRectangle(0,0,w,h), _backColor );
						_back.filters = _backFilters3;
						
						g = _face.graphics;
						g.clear();
						fillRect(g, getRectangle(0,0,w-2,h-2), _faceColor );
						_face.filters = _faceFilters3;
					}
					else {
						g = _back.graphics;
						g.clear();
						fillRect(g, getRectangle(0,0,w,h), _backColor );
						_back.filters = _backFilters4;
						
						g = _face.graphics;
						g.clear();
						fillRect(g, getRectangle(0,0,w-2,h-2),  _faceColor );
						_face.filters = _faceFilters4;
					}
					break;
				
				case Toggle.STATE_DOWN:
					if(selectState == Toggle.UNSELECTED) {
						g = _back.graphics;
						g.clear();
						fillRect(g, getRectangle(0,0,w,h), _backColor );
						_back.filters = _backFilters1;
						
						g = _face.graphics;
						g.clear();
						fillRect(g, getRectangle(0,0,w-2,h-2), _faceColor );
						_face.filters = _faceFilters1;
					}
					else {
						g = _back.graphics;
						g.clear();
						fillRect(g, getRectangle(0,0,w,h), _backColor );
						_back.filters = _backFilters2;
						
						g = _face.graphics;
						g.clear();
						fillRect(g, getRectangle(0,0,w-2,h-2),  _faceColor );
						_face.filters = _faceFilters2;
					}
					
					break;
				
				case Toggle.STATE_DISABLED:
					if(selectState == Toggle.UNSELECTED) {
						g = _back.graphics;
						g.clear();
						fillRect(g, getRectangle(0,0,w,h), 0xcccccc );//disable - gray
						_back.filters = _backFilters1;
						
						g = _face.graphics;
						g.clear();
						fillRect(g, getRectangle(0,0,w-2,h-2), 0xeeeeee );//disable - gray
						_face.filters = _faceFilters1;
					}
					else {
						g = _back.graphics;
						g.clear();
						fillRect(g, getRectangle(0,0,w,h), 0xcccccc );//disable - gray
						_back.filters = _backFilters2;
						
						g = _face.graphics;
						g.clear();
						fillRect(g, getRectangle(0,0,w-2,h-2), 0xeeeeee );//disable - gray
						_face.filters = _faceFilters2;
					}
					break;
				
				case Toggle.STATE_NORMAL:
					
				default:
					if(selectState == Toggle.SELECTED) {
						g = _back.graphics;
						g.clear();
						fillRect(g, getRectangle(0,0,w,h), _backColor );
						_back.filters = _backFilters2;
						
						g = _face.graphics;
						g.clear();
						fillRect(g, getRectangle(0,0,w-2,h-2),  _faceColor );
						_face.filters = _faceFilters2;
					}
					else {
						g = _back.graphics;
						g.clear();
						fillRect(g, getRectangle(0,0,w,h), _backColor );
						_back.filters = _backFilters1;
						
						g = _face.graphics;
						g.clear();
						fillRect(g, getRectangle(0,0,w-2,h-2), _faceColor );
						_face.filters = _faceFilters1;
					}
					break;
			}
		}
		
		override public function setStyle(style:String, value:Object):void
		{
			switch(style) {
				case "face-color":
					_faceColor = value as Number;
					invalidate();
					break;
				
				case "border-color":
					_backColor = value as Number;
					invalidate();
					break;
			}
		}		
	}
}