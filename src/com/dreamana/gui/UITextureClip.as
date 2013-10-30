package com.dreamana.gui
{
	import com.dreamana.gui.UITextureProvider;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	

	public class UITextureClip extends UITextureProvider
	{
		private var _rect:Rectangle;
		private var _loader:Loader;
		
		public function UITextureClip(rect:Rectangle=null, loader:Loader=null)
		{
			_rect = rect;
			_loader = loader;
			if(_loader) this.registerListeners(_loader.contentLoaderInfo);
		}
		
		override public function dispose():void
		{
			this.unregisterListeners(_loader.contentLoaderInfo);
			
			super.dispose();
		}
				
		override public function setData(source:BitmapData):void
		{			
			//clipping
			if(source && _rect) {
				var clip:BitmapData = new BitmapData(_rect.width, _rect.height, true, 0x00000000);
				clip.copyPixels(source, _rect, new Point());
				
				_bitmapData = clip;
			}
			else {
				_bitmapData = source;
			}
			
			//update
			this.update();
		}
		
		private function registerListeners(dispatcher:IEventDispatcher):void
		{
			dispatcher.addEventListener(Event.COMPLETE, onLoadComplete);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}
		
		private function unregisterListeners(dispatcher:IEventDispatcher):void
		{
			dispatcher.removeEventListener(Event.COMPLETE, onLoadComplete);
			dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}
		
		//--- EVENT HANDLERS ---
		
		private function onLoadComplete(e:Event):void
		{
			var bmp:Bitmap = _loader.content as Bitmap;
			if(bmp) setData(bmp.bitmapData);
		}
		
		private function onIOError(e:IOErrorEvent):void
		{
			setData(null);
			
			trace(e.text);
		}
		
		//--- GETTER/SETTERS ---
		
		public function get loader():Loader { return _loader; }
		public function set loader(value:Loader):void {
			//unregister listeners
			if(_loader) this.unregisterListeners(_loader.contentLoaderInfo);
			
			//reset loader
			_loader = value;
			
			//register listeners
			if(_loader) this.registerListeners(_loader.contentLoaderInfo);
		}

		public function get rect():Rectangle { return _rect; }
		public function set rect(value:Rectangle):void { 
			_rect = value;
			
			//update?
			if(_loader) {
				var bmp:Bitmap = _loader.content as Bitmap;
				if(bmp) setData(bmp.bitmapData);
			}
		}
	}
}