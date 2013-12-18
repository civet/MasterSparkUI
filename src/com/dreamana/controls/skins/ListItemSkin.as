package com.dreamana.controls.skins
{
	import com.dreamana.controls.Label;
	import com.dreamana.controls.ListItem;
	import com.dreamana.gui.UISkin;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.text.TextFormat;
	
	public class ListItemSkin extends UISkin
	{
		//element
		protected var _back:Shape;
		protected var _label:Label;
		
		//style
		protected var _boxSize:int;
		protected var _normalColor:int;
		protected var _hoverColor:int;
		protected var _selectedColor:int;
		protected var _normalFormat:TextFormat;
		protected var _hoverFormat:TextFormat;
		protected var _selectedFormat:TextFormat;
		
		
		public function ListItemSkin()
		{
			//default setting
			_boxSize = 19;
			_normalColor = 0xffffff;
			_hoverColor = 0xcccccc;
			_selectedColor = 0x0;
			_normalFormat = new TextFormat("Arial", 12, 0x666666);
			_hoverFormat = new TextFormat("Arial", 12, 0x333333);
			_selectedFormat = new TextFormat("Arial", 12, 0xffffff);
			
			//elements
			_back = new Shape();
			_label = new Label();
			
			//elementList
			this.addPart("back", _back);
			this.addPart("label", _label);
		}
		
		override protected function redraw():void
		{
			var g:Graphics;
			
			var w:int = _width;
			var h:int = _height;
			var size:int = _boxSize;
			var state:String = _props["state"];
			var selected:Boolean = _props["selected"];
						
			_label.text = _props["label"] ? _props["label"] : "";
			_label.x = _width - _label.width >> 1;
			_label.y = _height - _label.height >> 1;
			
			switch(state)
			{
				case ListItem.STATE_OVER:
					if( !selected ) {
						g = _back.graphics;
						g.clear();
						g.beginFill(_hoverColor, 1);
						g.drawRect(0, 0, _width, _height);
						
						/*g.lineStyle(1, 0x666666);
						g.beginFill(0xffffff);
						g.drawRect(size/4, size/4, size/2, size/2);
						g.endFill();*/
					}
					else {
						g = _back.graphics;
						g.clear();
						g.beginFill(_selectedColor, 1);
						g.drawRect(0, 0, _width, _height);
						
						/*var lineColor:int = _selectedFormat.color ? _selectedFormat.color as Number : 0x0;
						g.lineStyle(1, lineColor);
						g.beginFill(_selectedColor);
						g.drawRect(size/4, size/4, size/2, size/2);
						g.endFill();
						
						g.lineStyle(1, lineColor);
						g.moveTo(size/4, size/2);
						g.lineTo(size/2, size*3/4);
						g.lineTo(size*7/8, size/8);*/
					}
					
					_label.setTextFormat( selected ? _selectedFormat : _hoverFormat );
					
					break;
				
				case ListItem.STATE_DOWN:
					
					break;
				
				case ListItem.STATE_DISABLED:
					if( !selected ) {
						g = _back.graphics;
						g.clear();
						g.beginFill(0xeeeeee, 1);
						g.drawRect(0, 0, _width, _height);
						
						/*g.lineStyle(1, 0x666666);
						g.beginFill(0xeeeeee);//disable - gray
						g.drawRect(size/4, size/4, size/2, size/2);
						g.endFill();*/
					}
					else {
						g = _back.graphics;
						g.clear();
						g.beginFill(_selectedColor, 1);
						g.drawRect(0, 0, _width, _height);
						
						/*g.lineStyle(1, 0x666666);
						g.beginFill(0xeeeeee);//disable - gray
						g.drawRect(size/4, size/4, size/2, size/2);
						g.endFill();
						
						g.lineStyle(1, 0x333333);
						g.moveTo(size/4, size/2);
						g.lineTo(size/2, size*3/4);
						g.lineTo(size*7/8, size/8);*/
					}
					
					_label.setTextFormat( selected ? _selectedFormat : _normalFormat );
					
					break;
				
				case ListItem.STATE_NORMAL:
					
				default:
					if( selected ) {
						g = _back.graphics;
						g.clear();
						g.beginFill(_selectedColor, 1.0);
						g.drawRect(0, 0, _width, _height);
						
						/*lineColor = _selectedFormat.color ? _selectedFormat.color as Number : 0x0;
						g.lineStyle(1, lineColor);
						g.beginFill(_selectedColor);
						g.drawRect(size/4, size/4, size/2, size/2);
						g.endFill();
						
						g.lineStyle(1, lineColor);
						g.moveTo(size/4, size/2);
						g.lineTo(size/2, size*3/4);
						g.lineTo(size*7/8, size/8);*/
					}
					else {
						g = _back.graphics;
						g.clear();
						g.beginFill(_normalColor, 0);
						g.drawRect(0, 0, _width, _height);
						
						/*g.lineStyle(1, 0x666666);
						g.beginFill(0xffffff);
						g.drawRect(size/4, size/4, size/2, size/2);
						g.endFill();*/
					}
					
					_label.setTextFormat( selected ? _selectedFormat : _normalFormat );
					
					break;
			}
		}
		
		override public function setStyle(style:String, value:Object):void
		{
			switch(style) {
				case "box-size":
					_boxSize = value as Number;
					invalidate();
					break;
				
				case "over-color":
					_hoverColor = value as Number;
					invalidate();
					break;
			}
		}
	}
}