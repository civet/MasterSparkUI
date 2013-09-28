package com.dreamana.controls.skins
{
	import com.dreamana.controls.TextInput;
	import com.dreamana.gui.UISkin;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	
	public class TextInputSkin extends UISkin
	{
		public static var defaultFormat:TextFormat = new TextFormat("Arial", 12, 0x666666);
		
		//element
		protected var _back:Shape;
		protected var _textfield:TextField;
		
		//style
		protected var _backColor:int;
		protected var _backFilters:Array;
		protected var _padding:Object;
		
		
		public function TextInputSkin()
		{
			//default setting
			_backColor = 0xffffff;
			_backFilters = [getShadow(2, true)];
			_padding = {top:0, right:0, bottom:0, left:0};
			
			//elements
			_back = new Shape();
			
			_textfield = new TextField();
			_textfield.type = TextFieldType.INPUT;
			_textfield.defaultTextFormat = defaultFormat;
			_textfield.text = "";
			
			//elementList
			this.addPart("back", _back);
			this.addPart("textfield", _textfield);
		}
		
		override protected function redraw():void
		{
			var g:Graphics;
			
			var w:int = _width;
			var h:int = _height;
			var state:String = _props["state"];
			
			//set textfield size
			_textfield.x = _padding.left;
			_textfield.y = _padding.top;
			_textfield.width = w - _padding.left - _padding.right;
			_textfield.height = h - _padding.top - _padding.bottom;
			
			switch(state) {
				case TextInput.STATE_DISABLED:
					g = _back.graphics;
					g.clear();
					fillRect(g, getRectangle(0,0,w,h), 0xeeeeee );//disable - gray
					_back.filters = _backFilters;
					break;
				
				case TextInput.STATE_NORMAL:
				
				default:
					g = _back.graphics;
					g.clear();
					fillRect(g, getRectangle(0,0,w,h), _backColor );
					_back.filters = _backFilters;
					break;
			}
		}
		
		/**
		 * padding
		 * @param args [padding | top, right, bottom, left]
		 * @return 
		 */	
		public function setPadding(...args):void
		{
			if(args.length == 1) {
				var p:int = args[0]; 
				_padding.top = p;
				_padding.right = p;
				_padding.bottom = p;
				_padding.left = p;
			}
			else if(args.length == 4) {
				_padding.top = args[0];
				_padding.right = args[1];
				_padding.bottom = args[2];
				_padding.left = args[3];
			}
			
			this.invalidate();
		}
		
		override public function setStyle(style:String, value:Object):void
		{
			switch(style) {
				case "background-color":
					_backColor = value as Number;
					invalidate();
					break;
				
				case "padding":
					setPadding(value as Number);
					break;
				case "padding-top":
					setPadding(value as Number, _padding.right, _padding.bottom, _padding.left);
					break;
				case "padding-right":
					setPadding(_padding.top, value as Number, _padding.bottom, _padding.left);
					break;
				case "padding-bottom":
					setPadding(_padding.top, _padding.right, value as Number, _padding.left);
					break;
				case "padding-left":
					setPadding(_padding.top, _padding.right, _padding.bottom, value as Number);
					break;
			}
		}
		
	}
}