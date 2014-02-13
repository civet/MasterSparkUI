package com.dreamana.gui
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class UIAsyncProvider extends EventDispatcher
	{
		protected var _data:Object;
		protected var _listeners:Array = [];
		public const UPDATE:String = "update";
		
		public function UIAsyncProvider()
		{
		}
		
		public function addUpdateHandler(handler:Function):void
		{
			var index:int = _listeners.indexOf(handler);
			if(index == -1) _listeners[_listeners.length] = handler;
			
			this.addEventListener(UPDATE, handler);		
		}
		
		public function removeUpdateHandler(handler:Function):void
		{
			var index:int = _listeners.indexOf(handler);
			if(index != -1) _listeners.splice(index, 1);
			
			this.removeEventListener(UPDATE, handler);
		}
		
		protected function update():void
		{
			this.dispatchEvent(new Event(UPDATE));
		}
		
		public function dispose():void
		{
			_data = null;
			
			//update once
			this.update();
			
			//remove All UpdateHandlers
			var num:int = _listeners.length;
			for(var i:int = 0; i < num; ++i) {
				var handler:Function = _listeners[i];
				
				this.removeEventListener(UPDATE, handler);
			}
		}
		
		//--- Getter/setters ---
		
		public function setData(value:Object):void
		{
			_data = value;
			update();
		}
		
		public function getData():Object
		{
			return _data;
		}
	}
}