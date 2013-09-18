package com.dreamana.controls
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class Label extends TextField
	{
		public static var defaultFormat:TextFormat = new TextFormat("Arial", 12, 0x666666);
		
		public function Label(text:String="", format:TextFormat=null, offsetX:int=0, offsetY:int=0)
		{
			//default settings
			this.selectable = false;
			this.mouseEnabled = false;
			this.defaultTextFormat = (format)? format : defaultFormat;
			this.width = 100;
			this.height = 20;
			this.autoSize = TextFieldAutoSize.LEFT;
			
			this.text = text;
			
			this.x += offsetX;
			this.y += offsetY;
		}
	}
}