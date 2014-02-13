package com.dreamana.gui
{	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	

	public class UITextureProvider extends UIAsyncProvider
	{
		private var _rect:Rectangle;
		private var _loader:Loader;
		
		public function UITextureProvider(rect:Rectangle=null, loader:Loader=null)
		{
			_rect = rect;
			_loader = loader;
			if(_loader) this.registerListeners(_loader.contentLoaderInfo);
		}
		
		override public function dispose():void
		{
			this.unregisterListeners(_loader.contentLoaderInfo);
			
			var bitmapData:BitmapData = _data as BitmapData;
			if(bitmapData) {
				try {
					bitmapData.dispose();
				}
				catch(e:Error) {
					trace(e.message);
				}
			}
			
			super.dispose();
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
		
		override public function setData(data:Object):void
		{			
			var source:BitmapData = data as BitmapData;
			if(source && _rect) {
				//clipping
				var clip:BitmapData = new BitmapData(_rect.width, _rect.height, true, 0x00000000);
				clip.copyPixels(source, _rect, new Point());
				
				_data = clip;
			}
			else {
				//all
				_data = source;
			}
			
			//update
			this.update();
		}
		
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