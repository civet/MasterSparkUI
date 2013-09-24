package com.dreamana.controls.skins
{
	import com.dreamana.controls.Button;
	import com.dreamana.controls.Slider;
	import com.dreamana.gui.UISkin;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	public class SliderSkin extends UISkin
	{
		//element
		protected var _track:Sprite;
		protected var _handle:Sprite;
		
		//style
		protected var _handleColor:int;
		protected var _handleFilters:Array;
		protected var _trackColor:int;
		protected var _trackFilters:Array;
		
		
		public function SliderSkin()
		{
			//default setting
			_trackColor = 0xcccccc;
			_trackFilters = [getShadow(1, true)];//normal
			_handleColor = 0xffffff;
			_handleFilters = [getShadow(1)];//normal
			
			//elements
			_track = new Sprite();
			_handle = new Sprite();
						
			//elementList
			this.addPart("track", _track);
			this.addPart("handle", _handle);
		}
		
		override public function redraw():void
		{
			var g:Graphics;
			
			var w:int = _width;
			var h:int = _height;
			var state:String = _props["state"];
			var orientation:String = _props["orientation"];
			var handleWidth:int = _props["handleWidth"];
			var handleHeight:int = _props["handleHeight"];
			
			switch(state)
			{
				case Slider.STATE_NORMAL:
					g = _track.graphics;
					g.clear();
					fillRect(g, getRectangle(0,0,w,h), _trackColor );
					_track.filters = _trackFilters;
										
					g = _handle.graphics;
					g.clear();
					fillRect32(g, getRectangle(0, 0, handleWidth, handleHeight), 0x00 );
					fillRect(g, getRectangle(1, 1, handleWidth -2, handleHeight -2), _handleColor );
					_handle.filters = _handleFilters;
					break;
				
				case Slider.STATE_DISABLED:
					g = _track.graphics;
					g.clear();
					fillRect(g, getRectangle(0,0,w,h), 0xcccccc );//disable - gray
					_track.filters = _trackFilters;
					
					g = _handle.graphics;
					g.clear();
					fillRect32(g, getRectangle(0, 0, handleWidth, handleHeight), 0x00 );
					fillRect(g, getRectangle(1, 1, handleWidth -2, handleHeight -2), 0xeeeeee );//disable - gray
					_handle.filters = _handleFilters;
					break;
			}
		}
				
		override public function setStyle(style:String, value:Object):void
		{
			switch(style) {
				case "handle-color":
					_handleColor = value as Number;
					invalidate();
					break;
				
				case "track-color":
					_trackColor = value as Number;
					invalidate();
					break;
			}
		}			
	}
}