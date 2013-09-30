package com.dreamana.controls.skins
{
	import com.dreamana.controls.Button;
	import com.dreamana.gui.UISkin;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	
	public class ButtonHyperlinkSkin extends UISkin
	{
		//element
		protected var _textfield:TextField;
		
		//style
		protected var _formatNormal:TextFormat;
		protected var _formatOver:TextFormat;
		protected var _formatDown:TextFormat;
		protected var _formatDisabled:TextFormat;
		
		
		public function ButtonHyperlinkSkin()
		{
			//default setting
			_formatNormal = new TextFormat("Arial", 12, 0x0000ff, null, null, false);
			_formatOver = new TextFormat("Arial", 12, 0x0000ff, null, null, true);
			_formatDown	= new TextFormat("Arial", 12, 0x1982D1, null, null, true);
			_formatDisabled = new TextFormat("Arial", 12, 0xc0c0c0, null, null, false);
			
			//elements
			_textfield = new TextField();
			_textfield.mouseEnabled = false;
			_textfield.width = _width;
			_textfield.height = _height;
			_textfield.autoSize = TextFieldAutoSize.LEFT;
			
			_textfield.text = "";
			
			//elementList
			this.addPart("textfield", _textfield);
		}
		
		override protected function redraw():void
		{
			var w:int = _width;
			var h:int = _height;
			var state:String = _props["state"];
			
			/*
			var fontSize:int = ?;
			_formatNormal.size = fontSize;
			_formatOver.size = fontSize;
			_formatDown.size = fontSize;
			_formatDisabled.size = fontSize;
			*/
			
			//align-center
			_textfield.x = w - _textfield.width >> 1;
			_textfield.y = h - _textfield.height >> 1;
			
			switch(state)
			{
				case Button.STATE_OVER:
					_textfield.setTextFormat(_formatOver);
					break;
				
				case Button.STATE_DOWN:
					_textfield.setTextFormat(_formatDown);
					break;
				
				case Button.STATE_DISABLED:
					_textfield.setTextFormat(_formatDisabled);
					break;
				
				case Button.STATE_NORMAL:				
				default:
					_textfield.setTextFormat(_formatNormal);
					break;
			}
		}
		
		override public function setStyle(style:String, value:Object):void
		{
			switch(style) {
				case "normal-format":
					_formatNormal = value as TextFormat;
					invalidate();
					break;
				
				case "over-format":
					_formatOver = value as TextFormat;
					invalidate();
					break;
				
				case "down-format":
					_formatDown = value as TextFormat;
					invalidate();
					break;
				
				case "disabled-format":
					_formatDisabled = value as TextFormat;
					invalidate();
					break;
				
				case "text":
					_textfield.text = value as String;
					invalidate();
					break;
			}
		}
		
	}
}