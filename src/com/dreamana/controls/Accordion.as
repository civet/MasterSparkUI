package com.dreamana.controls
{
	import com.dreamana.controls.layouts.VBoxLayout;
	import com.dreamana.gui.UIComponent;
	
	import flash.events.Event;
	
	[Event(name="resize", type="flash.events.Event")]
	
	public class Accordion extends UIComponent
	{
		protected var _vbox:VBoxLayout;
		
		public function Accordion()
		{
			_vbox = new VBoxLayout();
		}
		
		public function createPanel(w:int, h:int, title:String=""):Panel
		{
			var panel:Panel = new Panel();
			panel.setSize(w, h);
			panel.title = title;
			return panel;
		}
		
		public function addPanel(panel:Panel):Panel
		{
			return addPanelAt(panel, _vbox.numElements);
		}
		
		public function addPanelAt(panel:Panel, index:int):Panel
		{
			panel.draggable = false;
			panel.collapse();
			panel.addEventListener(Event.SELECT, onPanelSelect);
			
			_vbox.addElementAt(panel, index);
			
			this.addChildAt(panel, index);
			
			updateSize();
			
			return panel;
		}
		
		public function removePanel(panel:Panel):Panel
		{
			var panel:Panel;
			var index:int = _vbox.getElementIndex(panel);
			if(index >= 0) {
				panel = removePanelAt(index);
			}
			return panel;
		}
		
		public function removePanelAt(index:int):Panel
		{
			var panel:Panel = _vbox.removeElementAt(index) as Panel;
			
			this.removeChild(panel);
			
			updateSize();
			
			return panel;
		}
		
		public function getPanelAt(index:int):Panel
		{
			return _vbox.getElementAt(index) as Panel;
		}
		
		public function getPanelIndex(panel:Panel):int
		{
			return _vbox.getElementIndex(panel);
		}
		
		protected function updateSize():void
		{
			var oldWidth:Number = _width;
			var oldHeight:Number = _height;
			
			_width = 0;
			_height = 0;
			var num:int = _vbox.numElements;
			for(var i:int = 0; i < num; ++i)
			{
				var panel:Panel = _vbox.getElementAt(i) as Panel;
				
				_width = (panel.width > _width)? panel.width : _width;
				_height += panel.height;
			}
			
			//dispatch
			if(_width != oldWidth || _height != oldHeight)
				this.dispatchEvent(new Event(Event.RESIZE));
		}
		
		//--- Event Handlers ---
		
		protected function onPanelSelect(event:Event):void
		{
			var index:int = _vbox.getElementIndex( event.currentTarget );
			if(index >= 0) {
				var num:int = _vbox.numElements;
				for(var i:int = 0; i < num; ++i)
				{
					var panel:Panel = _vbox.getElementAt(i) as Panel;
					
					if(i == index) {
						if(!collapsible) panel.expand();
					}
					else panel.collapse();
				}
				
				updateSize();
			}
		}
		
		//--- Getter/Setters ---
		
		public var collapsible:Boolean = false;
		
		override public function set width(value:Number):void
		{
			var num:int = _vbox.numElements;
			for(var i:int = 0; i < num; ++i)
			{
				var panel:Panel = _vbox.getElementAt(i) as Panel;
				panel.setSize( value, panel.titleBarHeight + panel.contentHeight );
			}	
			
			super.width = value;
		}
		
		//TODO:
		override public function set height(value:Number):void
		{
			//do nothing
		}
	}
}