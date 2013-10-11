package com.dreamana.controls
{
	import com.dreamana.gui.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Scroller extends UIComponent
	{
		public var hscrollbar:ScrollBar;
		public var vscrollbar:ScrollBar;
		protected var _contentRoot:Sprite;
		protected var _contentMask:Shape;
		
				
		public function Scroller()
		{
			//default setting
			_width = 100;
			_height = 100;
			
			//view
			this.addChildren();
			this.redraw();
		}
		
		protected function addChildren():void
		{
			hscrollbar = new ScrollBar();
			vscrollbar = new ScrollBar();
			vscrollbar.orientation = ScrollBar.VERTICAL;
			vscrollbar.value = 1.0;
			
			_contentRoot = new Sprite();
			_contentMask = new Shape();
			
			this.addChild(_contentRoot);
			this.addChild(_contentMask);
			this.addChild(hscrollbar);
			this.addChild(vscrollbar);
			_contentRoot.mask = _contentMask;
			
			hscrollbar.addEventListener(Event.CHANGE, onHScrollBarChange);
			vscrollbar.addEventListener(Event.CHANGE, onVScrollBarChange);
		}
		
		override protected function redraw():void
		{
			var g:Graphics = _contentMask.graphics;
			g.beginFill(0x0);
			g.drawRect(0, 0, _width, _height);
			g.endFill();
			
			//reset scrollbar
			hscrollbar.width = _width - vscrollbar.width;
			vscrollbar.height = _height - hscrollbar.height;
			hscrollbar.y = _height - hscrollbar.height;
			vscrollbar.x = _width - vscrollbar.width;
			
			if(_contentRoot.width >= _width && _contentRoot.height >= _height)
			{
				var hPercent:Number = _width / _contentRoot.width;
				var vPercent:Number = _height / _contentRoot.height;
				hscrollbar.percent = hPercent;
				vscrollbar.percent = vPercent;
			}
			else {
				hscrollbar.percent = 1.0;
				vscrollbar.percent = 1.0;
			}
		}
		
		public function addContent(content:DisplayObject):void
		{
			_contentRoot.addChild(content);
			
			//this.invalidate();//Broadcaster.as bugfixing...
			redraw();
		}
		
		//--- Event Handlers ---
		
		protected function onHScrollBarChange(event:Event):void
		{
			_contentRoot.x = -hscrollbar.value * (_contentRoot.width - _width);
		}
		
		protected function onVScrollBarChange(event:Event):void
		{
			_contentRoot.y = -vscrollbar.value * (_contentRoot.height - _height);
		}
		
		//--- Getter/setters ---
	}
}