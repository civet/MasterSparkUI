package com.dreamana.controls.skins
{
	import com.dreamana.controls.TextInput;
	import com.dreamana.gui.UISkin;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	
	public class TextInputTextureSkin extends UISkin
	{
		public static var defaultFormat:TextFormat = new TextFormat("Arial", 12, 0x666666);
		
		//element
		protected var _back:Shape;
		protected var _textfield:TextField;
		
		//texture
		protected var _backTexture:BitmapData;
		protected var _backScale9Grid:Rectangle;
		protected var _backFilters0:Array;
		protected var _backFilters1:Array;
		protected var _padding:Object;
		
		
		public function TextInputTextureSkin()
		{
			//default setting
			_backFilters0 = [];
			_backFilters1 = [new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0])];
			_padding = {top:0, right:0, bottom:0, left:0};
			
			//elements
			_back = new Shape();
			
			_textfield = new TextField();
			_textfield.type = TextFieldType.INPUT;
			_textfield.defaultTextFormat = defaultFormat;
			_textfield.text = "";
			
			//this.addChild(_back);
			//this.addChild(_textfield);	
			
			this.addPart("back", _back);
			this.addPart("textfield", _textfield);
		}
		
		override public function adjustSize():void
		{
			//set textfield size
			_textfield.x = _padding.left;
			_textfield.y = _padding.top;
			_textfield.width = _width - _padding.left - _padding.right;
			_textfield.height = _height - _padding.top - _padding.bottom;
		
			super.adjustSize();
		}
		
		override public function redraw():void
		{
			var g:Graphics;
			
			var w:int = _width;
			var h:int = _height;
			var state:String = _props["state"];
			
			if(_backTexture) {
				g = _back.graphics;
				g.clear();
				if(_backScale9Grid) fill9Grid( g, _backTexture, getRectangle(0,0,w,h), _backScale9Grid, false);
				else fillBitmap(g, _backTexture, getRectangle(0,0,w,h) );
			}
			
			switch(state)
			{
				case TextInput.STATE_DISABLED:
					_back.filters = _backFilters1;
					break;
				
				case TextInput.STATE_NORMAL:
				default:
					_back.filters = _backFilters0;
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
				
				case "background-image":
					_backTexture = value as BitmapData;
					invalidate();
					break;
				
				case "background-9grid":
					_backScale9Grid = value as Rectangle;
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