package com.dreamana.controls.skins
{
	import com.dreamana.controls.ProgressBar;
	import com.dreamana.gui.UISkin;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class ProgressBarSkin extends UISkin
	{
		//element
		protected var _back:Shape;
		protected var _face:Shape;
		
		//style
		protected var _faceColor:int;
		protected var _faceFilters:Array;
		protected var _backColor:int;
		protected var _backFilters:Array;
		
		protected var _onFrameLoop:Function;
		protected var _matrix:Matrix = new Matrix();
		
		
		public function ProgressBarSkin()
		{
			//default setting
			_faceColor = 0xffffff;
			_faceFilters = [getShadow(1)];//normal
			_backColor = 0xcccccc;
			_backFilters = [getShadow(2, true)];//normal
			
			//elements
			_back = new Shape();
			
			_face = new Shape();
			_face.x = 1;
			_face.y = 1;
			
			//elementList
			this.addPart("back", _back);
			this.addPart("face", _face);
		}
		
		override protected function redraw():void
		{
			var g:Graphics;
			
			var w:int = _width;
			var h:int = _height;
			var state:String = _props["state"];
			var direction:String = _props["direction"];
			var value:Number = _props["value"];
			
			var faceLength:int = Math.round( (w-2) * value );
			var faceThickness:int = h-2;
			
			switch(state)
			{
				case ProgressBar.STATE_INDETERMINATE:
					g = _back.graphics;
					g.clear();
					fillRect(g, getRectangle(0,0,w,h), _backColor );
					_back.filters = _backFilters;
					
					_face.filters = _faceFilters;
					
					//stop animation
					if(_onFrameLoop != null) {
						this.removeEventListener(Event.ENTER_FRAME, _onFrameLoop);
						_onFrameLoop = null;
					}
					
					//play animation
					var pattern:BitmapData = getPattern(faceThickness);
					var rectangle:Rectangle = getRectangle(0, 0, w-2, h-2);
					var step:int = (direction == ProgressBar.RIGHT) ? 2 : -2;
					
					_onFrameLoop = function(event:Event):void
					{
						var g:Graphics = _face.graphics;
						g.clear();
						fillRect(g, rectangle, _faceColor );
						fillBitmap(g, pattern, rectangle, _matrix);
						
						_matrix.tx += step;
						if(_matrix.tx >= faceThickness * 1.5) _matrix.tx = 0;
					};
					this.addEventListener(Event.ENTER_FRAME, _onFrameLoop);
					
					break;
				
				case ProgressBar.STATE_DISABLED:
					//stop animation
					if(_onFrameLoop != null) {
						this.removeEventListener(Event.ENTER_FRAME, _onFrameLoop);
						_onFrameLoop = null;
					}
					
					g = _back.graphics;
					g.clear();
					fillRect(g, getRectangle(0,0,w,h), 0xcccccc );//disable - gray
					_back.filters = _backFilters;
					
					g = _face.graphics;
					g.clear();
					if(direction == ProgressBar.LEFT) 
						fillRect(g, getRectangle(w-2-faceLength, 0, faceLength, faceThickness), 0xeeeeee );//disable - gray
					else 
						fillRect(g, getRectangle(0, 0, faceLength, faceThickness), 0xeeeeee );
					_face.filters = _faceFilters;
					break;
				
				case ProgressBar.STATE_NORMAL:
					
				default:
					//stop animation
					if(_onFrameLoop != null) {
						this.removeEventListener(Event.ENTER_FRAME, _onFrameLoop);
						_onFrameLoop = null;
					}
					
					g = _back.graphics;
					g.clear();
					fillRect(g, getRectangle(0,0,w,h), _backColor );
					_back.filters = _backFilters;
										
					g = _face.graphics;
					g.clear();
					if(direction == ProgressBar.LEFT) 
						fillRect(g, getRectangle(w-2-faceLength, 0, faceLength, faceThickness), _faceColor );
					else 
						fillRect(g, getRectangle(0, 0, faceLength, faceThickness), _faceColor );
					_face.filters = _faceFilters;
					break;
			}
		}
		
		protected var _patternSize:int = 0;
		protected var _pattern:BitmapData;
		protected function getPattern(size:int):BitmapData
		{
			if(size == _patternSize) {
				return _pattern;
			}
			else {
				if(_pattern) _pattern.dispose();
				_patternSize = size;
			}
			
			var tile:Shape = new Shape();
			var g:Graphics = tile.graphics;
			g.beginFill(0x0, 0.5);
			g.moveTo(0, size);
			g.lineTo(size, 0);
			g.lineTo(size * 1.5, 0);
			g.lineTo(size * 0.5, size);
			g.endFill();
			
			_pattern = new BitmapData(size * 1.5, size, true, 0x00);
			_pattern.draw(tile);
			
			return _pattern;
		}
		
		override public function setStyle(style:String, value:Object):void
		{
			switch(style) {
				case "face-color":
					_faceColor = value as Number;
					invalidate();
					break;
				
				case "background-color":
					_backColor = value as Number;
					invalidate();
					break;
			}
		}
		
	}
}