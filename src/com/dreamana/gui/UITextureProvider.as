package com.dreamana.gui
{
	import com.dreamana.utils.Broadcaster;
	
	import flash.display.BitmapData;

	public class UITextureProvider
	{
		protected var _bitmapData:BitmapData;
		
		public function UITextureProvider()
		{
		}
		
		public function addUpdateHandler(handler:Function):void
		{
			updated.add(handler);
		}
		
		public function removeUpdateHandler(handler:Function):void
		{
			updated.remove(handler);
		}
		
		protected function update():void
		{
			updated.dispatch( this );//eventTarget:this
		}
		
		public function dispose():void
		{
			if(_bitmapData) {
				try {
					_bitmapData.dispose();
				}
				catch(e:Error) {
					trace(e.message);
				}
				_bitmapData = null;
			}
			
			//update once
			this.update();
			
			//remove All UpdateHandlers
			updated.removeAll();
		}
		
		//--- Getter/setters ---
		
		public function setData(value:BitmapData):void
		{
			_bitmapData = value;
			update();
		}
		
		public function getData():Object
		{
			return _bitmapData;
		}
		
		//--- Signals ---
		
		public var updated:Broadcaster = new Broadcaster();
	}
}