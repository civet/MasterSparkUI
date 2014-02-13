package com.dreamana.gui
{
	import flash.geom.Rectangle;

	public class UISlice9Provider extends UIAsyncProvider
	{
		public function UISlice9Provider()
		{
		}
		
		//--- GETTER/SETTERS ---
		
		override public function setData(data:Object):void
		{			
			var rect:Rectangle = data as Rectangle;
			
			_data = rect;
			
			//update
			this.update();
		}
	}
}