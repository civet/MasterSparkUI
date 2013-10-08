package com.dreamana.controls.skins
{
	import com.dreamana.gui.UISkin;
	import com.dreamana.controls.Button;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	

	public class ButtonTextureSkin extends UISkin
	{
		//element
		protected var _face:Shape;
		
		//texture
		protected var _normalTexture:BitmapData;
		protected var _normalScale9Grid:Rectangle;
		protected var _downTexture:BitmapData;
		protected var _downScale9Grid:Rectangle;
		protected var _faceFilters0:Array;
		protected var _faceFilters1:Array;
		
		
		public function ButtonTextureSkin()
		{
			//default setting
			_faceFilters0 = [];
			_faceFilters1 = [new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0])];
			
			//elements
			_face = new Shape();
			
			//elementList
			this.addPart("face", _face);
		}
		
		override protected function redraw():void
		{		
			var g:Graphics;
			
			var w:int = _width;
			var h:int = _height;
			var state:String = _props["state"];
			
			switch(state)
			{
				case Button.STATE_DOWN:
					if(_downTexture) {
						g = _face.graphics;
						g.clear();
						if(_downScale9Grid) fill9Grid( g, _downTexture, getRectangle(0,0,w,h), _downScale9Grid, false);
						else fillBitmap(g, _downTexture, getRectangle(0,0,w,h) );
					}			
					_face.filters = _faceFilters0;
					break;
				
				case Button.STATE_DISABLED:
					if(_normalTexture) {
						g = _face.graphics;
						g.clear();
						if(_normalScale9Grid) fill9Grid( g, _normalTexture, getRectangle(0,0,w,h), _normalScale9Grid, false);
						else fillBitmap(g, _normalTexture, getRectangle(0,0,w,h) );
					}
					_face.filters = _faceFilters1;
					break;
				
				case Button.STATE_NORMAL:
				case Button.STATE_OVER:
				default:
					if(_normalTexture) {
						g = _face.graphics;
						g.clear();
						if(_normalScale9Grid) fill9Grid( g, _normalTexture, getRectangle(0,0,w,h), _normalScale9Grid, false);
						else fillBitmap(g, _normalTexture, getRectangle(0,0,w,h) );
					}
					_face.filters = _faceFilters0;
					break;
			}
		}
		
		override public function setStyle(style:String, value:Object):void
		{
			switch(style) {
				
				case "normal-image":
					_normalTexture = value as BitmapData;
					invalidate();
					break;
				
				case "normal-9grid":
					_normalScale9Grid = value as Rectangle;
					invalidate();
					break;
				
				case "down-image":
					_downTexture = value as BitmapData;
					invalidate();
					break;
				
				case "down-9grid":
					_downScale9Grid = value as Rectangle;
					invalidate();
					break;
				
				case "over-image":
					//TODO:
					break;
				
				case "over-9grid":
					//TODO:
					break;
			}
		}
		
	}
}