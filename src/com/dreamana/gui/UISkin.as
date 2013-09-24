package com.dreamana.gui
{	
	import com.dreamana.utils.OrderedObject;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * Skin Class for MasterSpark GUI Component
	 * 
	 * only skin parts would be added to DisplayList.
	 * inherited from UIComponent for using Deferred Rendering feature.
	 * 
	 * @author civet (dreamana.com)
	 */	
	public class UISkin extends UIComponent
	{
		public function UISkin()
		{
		}
		
		/* Initializing & drawing */
		
		protected var _props:Object;
		
		//public function setSize(w:int, h:int):void;
				
		public function setDrawingProps(props:Object):void
		{
			_props = props;
			
			invalidate();
		}
						
		/* elements managing */
		
		public var elements:OrderedObject = new OrderedObject();
		
		public function addPart(name:String, instance:Object):void
		{
			elements[name] = instance;
		}
		
		public function removePart(name:String):void
		{
			if(elements[name])
				delete elements[name];
		}
		
		public function getPart(name:String):Object
		{
			return elements[name];
		}
		
		public function getPartByIndex(index:int):Object
		{
			var props:Array = elements.propertyList;
			if(index < props.length && index >= 0)
			{
				return elements[ props[index] ];
			}
			return null;
		}
		
		public function containsPart(instance:Object):Boolean
		{
			for(var key:String in elements) {
				if(instance == elements[key]) return true;
			}
			return false;
		}
		
		/* styling and skinning */
		
		protected var _styleMap:Object = {};
		protected var _styleMapAsync:Object = {};
		
		/**
		 * Overriden in subclasses to set style.
		 * @param style
		 * @param value
		 */		
		public function setStyle(style:String, value:Object):void
		{
			_styleMap[style] = value;
		}
		
		public function getStyle(style:String):Object
		{
			return _styleMap[style];
		}
		
		public function getStyleMap():Object
		{
			return _styleMap;
		}
		
		/**
		 * Sets style asynchronous
		 * @param style
		 * @param value
		 */
		public function setStyleAsync(style:String, value:Object):void
		{
			var provider:UITextureProvider = value as UITextureProvider;
			if(provider) {
				_styleMapAsync[style] = value;
				
				provider.addUpdateHandler(onTextureUpdate);
			}
			else {
				this.setStyle(style, value);
			}
		}
		
		//--- Event Handlers ---
		
		private function onTextureUpdate(provider:UITextureProvider):void
		{
			for(var style:String in _styleMapAsync)
			{
				if(_styleMapAsync[style] == provider)
				{
					this.setStyle(style, provider.getData());
				}
			}
		}
		
		//--- Getter/Setters ---
		
		//--- Utils ---
		
		protected function getShadow(dist:Number, knockout:Boolean = false):DropShadowFilter
		{
			return new DropShadowFilter(dist, 45, 0x000000, 1, dist, dist, .3, 1, knockout);
		}
		
		/**
		 * Reuse rectangle 
		 */		
		protected var _rectangle:Rectangle = new Rectangle();
		protected function getRectangle(ox:int, oy:int, w:int, h:int):Rectangle
		{
			/*
			_rect.x = ox;
			_rect.y = oy;
			_rect.width = w;
			_rect.height = h;
			*/
			_rectangle.setTo(ox, oy, w, h);//FP11+
			return _rectangle;
		}
		
		/**
		 * Fill color only
		 * @param graphics
		 * @param w
		 * @param h
		 * @param color
		 */
		protected function fillRect(graphics:Graphics, rect:Rectangle, color:uint=0xffffff):void
		{
			graphics.lineStyle();
			graphics.beginFill(color, 1.0);
			graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			graphics.endFill();
		}
		
		protected function fillRect32(graphics:Graphics, rect:Rectangle, color:uint=0xffffffff):void
		{
			var alpha:Number = (color >> 24 & 0xff) / 0xff;
			var rgb:uint = color & 0x00ffffff;
			
			graphics.lineStyle();
			graphics.beginFill(rgb, alpha);
			graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			graphics.endFill();
		}
		
		/**
		 * Fill bitmap texture 
		 * @param bitmapData
		 * @param w
		 * @param h
		 * @param smooth
		 */		
		protected function fillBitmap(graphics:Graphics, bitmapData:BitmapData, rect:Rectangle, matrix:Matrix=null, smooth:Boolean=false):void
		{
			graphics.beginBitmapFill(bitmapData, matrix, true, smooth);
			graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			graphics.endFill();
		}
		
		/**
		 * Fill bitmap texture with Scale9Grid style
		 * inspired by ScaleBitmap(http://www.bytearray.org/?p=1206, by Didier Brun)
		 * 
		 * @param bitmapData
		 * @param scale9Grid
		 * @param w
		 * @param h
		 * @param smooth
		 */		
		public function fill9Grid(graphics:Graphics, bitmapData:BitmapData, rect:Rectangle, scale9Grid:Rectangle, smooth:Boolean=false):void
		{
			var widths:Array = [scale9Grid.left + 1, scale9Grid.width - 2, bitmapData.width - scale9Grid.right + 1];
			var heights:Array = [scale9Grid.top + 1, scale9Grid.height - 2, bitmapData.height - scale9Grid.bottom + 1];
			
			//draw width of middle part
			var mw:Number = rect.width - widths[0] - widths[2];
			var mh:Number = rect.height - heights[0] - heights[2];
			
			var left:Number = rect.x;
			var top:Number = rect.y;
			
			var j:int, i:int;
			var ox:Number=0, oy:Number=0;
			var dx:Number=0, dy:Number=0;
			var ow:Number, oh:Number;
			var dw:Number, dh:Number;
			var mtx:Matrix = new Matrix();
						
			// let's draw
			for(j=0; j < 3; ++j)
			{
				// original width
				ow = widths[j];
				// draw width						
				dw = (j==1)? mw : ow;
				
				// original & draw offset
				dy = oy = 0;
				mtx.a = dw / ow;
				
				for(i=0; i < 3; ++i)
				{
					// original height
					oh = heights[i];
					// draw height
					dh = (i==1)? mh : oh;
					
					if (dw > 0 && dh > 0)
					{
						// some matrix computation
						mtx.d = dh / oh;
						mtx.tx = -ox * mtx.a + dx;
						mtx.ty = -oy * mtx.d + dy;
						mtx.translate(left, top);
						
						// draw the cell
						graphics.beginBitmapFill(bitmapData, mtx, false, smooth);
						graphics.drawRect(dx + left, dy + top, dw, dh);
						graphics.endFill();
					}
					
					// offset incrementation
					oy += oh;
					dy += dh;
				}
				
				// offset incrementation
				ox += ow;
				dx += dw;
			}
			
			//question: endFill here better?
		}
		
		/**
		 * Draw wireframe only
		 * @param graphics
		 * @param w
		 * @param h
		 */		
		protected function drawWireFrame(graphics:Graphics, rect:Rectangle):void
		{
			graphics.lineStyle();
			graphics.beginFill(0xffffff);
			graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			graphics.endFill();
			
			graphics.lineStyle(0, 0x0);
			graphics.drawRect(rect.x, rect.y, rect.width -1, rect.height -1);
		}
	}
}