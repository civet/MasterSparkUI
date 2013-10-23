package com.dreamana.controls.skins
{
	import com.dreamana.controls.Label;
	import com.dreamana.controls.Panel;
	import com.dreamana.controls.Toggle;
	import com.dreamana.gui.UISkin;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	public class PanelSkin extends UISkin
	{
		//element
		protected var _contentArea:Sprite;
		protected var _titleBar:Sprite;
		protected var _title:Label;
		protected var _toggle:Toggle;
		
		//style
		protected var _contentAreaColor:int;
		protected var _contentAreaFilters:Array;
		protected var _titleBarColor:int;
		protected var _titleBarFilters:Array;
		
		public function PanelSkin()
		{
			//default setting
			_contentAreaColor = 0xeeeeee;
			_contentAreaFilters = [getShadow(1)];
			_titleBarColor = 0xffffff;
			_titleBarFilters = [getShadow(1)];
			
			//elements
			_contentArea = new Sprite();
			_titleBar = new Sprite();
			_title = new Label();
			_toggle = new Toggle();
			_toggle.skin = new ExpandButtonSkin();
			_toggle.selected = true;
			
			//elementList
			this.addPart("contentArea", _contentArea);
			this.addPart("titleBar", _titleBar);
			this.addPart("title", _title);
			this.addPart("toggle", _toggle);
		}
		
		override public function setDrawingProps(props:Object):void
		{
			var titleWidth:int = props["titleWidth"];
			var titleHeight:int = props["titleHeight"];
			
			var size:int = titleHeight;
			var toggleWidth:int = size;
			var toggleHeight:int = size;
			
			_toggle.setSize(toggleWidth, toggleHeight);
			_title.x = size + 2;
			
			super.setDrawingProps(props);		
		}
		
		override protected function redraw():void
		{
			var g:Graphics;
			
			var w:int = _width;
			var h:int = _height;
			var state:String = _props["state"];
			var titleWidth:int = _props["titleWidth"];
			var titleHeight:int = _props["titleHeight"];
			var contentWidth:int = _props["contentWidth"];
			var contentHeight:int = _props["contentHeight"];
			
			switch(state)
			{
				case Panel.STATE_NORMAL:
					g = _titleBar.graphics;
					g.clear();
					fillRect(g, getRectangle(0, 0, titleWidth, titleHeight), _titleBarColor );
					_titleBar.filters = _titleBarFilters;
					
					g = _contentArea.graphics;
					g.clear();
					fillRect(g, getRectangle(0, 0, contentWidth, contentHeight), _contentAreaColor );
					_contentArea.filters = _contentAreaFilters;
					_contentArea.y = titleHeight;
					break;
				
				case Panel.STATE_DISABLED:
					g = _titleBar.graphics;
					g.clear();
					fillRect(g, getRectangle(0, 0, titleWidth, titleHeight),  0xeeeeee );//disable - gray
					_titleBar.filters = _titleBarFilters;
					
					g = _contentArea.graphics;
					g.clear();
					fillRect(g, getRectangle(0, 0, contentWidth, contentHeight), 0xcccccc );//disable - gray
					_contentArea.filters = _contentAreaFilters;
					_contentArea.y = titleHeight;
					break;
			}
		}
		
		override public function setStyle(style:String, value:Object):void
		{
			switch(style) {
				case "titlebar-color":
					_titleBarColor = value as Number;
					invalidate();
					break;
				
				case "title":
					_title.text = value as String;
					break;
			}
		}
	}
}