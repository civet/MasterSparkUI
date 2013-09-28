package com.dreamana.controls.skins
{
	import com.dreamana.controls.Slider;
	import com.dreamana.gui.UISkin;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Rectangle;
	
	public class SliderTextureSkin extends UISkin
	{
		//element
		protected var _track:Sprite;
		protected var _handle:Sprite;
		
		//texture
		protected var _trackTexture:BitmapData;
		protected var _trackScale9Grid:Rectangle;
		protected var _handleTexture:BitmapData;
		protected var _handleScale9Grid:Rectangle;
		protected var _normalFilters:Array;
		protected var _disabledFilters:Array;
		
		
		public function SliderTextureSkin()
		{
			//default setting
			_normalFilters = [];
			_disabledFilters = [new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0])];
			
			//elements
			_track = new Sprite();
			_handle = new Sprite();
			
			//elementList
			this.addPart("track", _track);
			this.addPart("handle", _handle);
		}
		
		override protected function redraw():void
		{
			var g:Graphics;
			
			var w:int = _width;
			var h:int = _height;
			var state:String = _props["state"];
			var orientation:String = _props["orientation"];
			var handleWidth:int = _props["handleWidth"];
			var handleHeight:int = _props["handleHeight"];
			
			if(_trackTexture) {
				g = _track.graphics;
				g.clear();
				if(_trackScale9Grid) fill9Grid(g, _trackTexture, getRectangle(0,0,w,h), _trackScale9Grid, false );
				else fillBitmap(g, _trackTexture, getRectangle(0,0,w,h) );
			}
			
			if(_handleTexture) {
				g = _handle.graphics;
				g.clear();
				if(_handleScale9Grid) fill9Grid(g, _handleTexture, getRectangle(0, 0, handleWidth, handleHeight), _handleScale9Grid, false );
				else fillBitmap(g, _handleTexture, getRectangle(0, 0, handleWidth, handleHeight) );
			}
			
			switch(state)
			{
				case Slider.STATE_NORMAL:
					_track.filters = _normalFilters;
					_handle.filters = _normalFilters;
					break;
				
				case Slider.STATE_DISABLED:
					_track.filters = _disabledFilters;
					_handle.filters = _disabledFilters;
					break;
			}
		}
		
		override public function setStyle(style:String, value:Object):void
		{
			switch(style) {
				
				case "track-image":
					_trackTexture = value as BitmapData;
					invalidate();
					break;
				
				case "track-9grid":
					_trackScale9Grid = value as Rectangle;
					invalidate();
					break;
				
				case "handle-image":
					_handleTexture = value as BitmapData;
					invalidate();
					break;
				
				case "handle-9grid":
					_handleScale9Grid = value as Rectangle;
					invalidate();
					break;
			}
		}
	}
}