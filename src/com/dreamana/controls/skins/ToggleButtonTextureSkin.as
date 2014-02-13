package com.dreamana.controls.skins
{
	import com.dreamana.controls.Toggle;
	import com.dreamana.gui.UISkin;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Rectangle;
	
	public class ToggleButtonTextureSkin extends UISkin
	{
		//element
		protected var _face:Shape;
		
		//texture
		protected var _normalTexture:BitmapData;
		protected var _normalSlice9:Rectangle;
		protected var _downTexture:BitmapData;
		protected var _downSlice9:Rectangle;
		protected var _faceFilters0:Array;
		protected var _faceFilters1:Array;
		
		
		public function ToggleButtonTextureSkin()
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
			var selected:Boolean = _props["selected"];
			
			if( !selected ) {
				if(_normalTexture) {
					g = _face.graphics;
					g.clear();
					if(_normalSlice9) fill9Grid( g, _normalTexture, getRectangle(0,0,w,h), _normalSlice9, false);
					else fillBitmap(g, _normalTexture, getRectangle(0,0,w,h) );
				}
			}
			else {
				if(_downTexture) {
					g = _face.graphics;
					g.clear();
					if(_downSlice9) fill9Grid( g, _downTexture, getRectangle(0,0,w,h), _downSlice9, false);
					else fillBitmap(g, _downTexture, getRectangle(0,0,w,h) );
				}
			}
			
			switch(state)
			{
				case Toggle.STATE_DISABLED:
					_face.filters = _faceFilters1;
					break;
				
				case Toggle.STATE_NORMAL:
				case Toggle.STATE_OVER:
				case Toggle.STATE_DOWN:
				default:
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
				
				case "normal-9slice":
					_normalSlice9 = value as Rectangle;
					invalidate();
					break;
				
				case "down-image":
					_downTexture = value as BitmapData;
					invalidate();
					break;
				
				case "down-9slice":
					_downSlice9 = value as Rectangle;
					invalidate();
					break;
				
				case "over-image":
					//TODO:
					break;
				
				case "over-9slice":
					//TODO:
					break;
			}
		}
	}
}