package com.dreamana.controls
{
	import com.dreamana.controls.layouts.VBoxLayout;
	import com.dreamana.gui.UIComponent;
	
	import flash.events.Event;
	
	
	public class Accordion extends UIComponent
	{
		protected var _layout:VBoxLayout;
		
		public function Accordion()
		{
			_layout = new VBoxLayout();
			_layout.addEventListener(Event.RESIZE, onLayoutResize);
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
			return addPanelAt(panel, _layout.numElements);
		}
		
		public function addPanelAt(panel:Panel, index:int):Panel
		{
			panel.draggable = false;
			panel.collapse();
			panel.addEventListener(Event.SELECT, onPanelSelect);
			
			_layout.addElementAt(panel, index);
			
			this.addChildAt(panel, index);
			
			//updateSize();
			
			return panel;
		}
		
		public function removePanel(panel:Panel):Panel
		{
			var panel:Panel;
			var index:int = _layout.getElementIndex(panel);
			if(index >= 0) {
				panel = removePanelAt(index);
			}
			return panel;
		}
		
		public function removePanelAt(index:int):Panel
		{
			var panel:Panel = _layout.removeElementAt(index) as Panel;
			
			this.removeChild(panel);
			
			//updateSize();
			
			return panel;
		}
		
		public function getPanelAt(index:int):Panel
		{
			return _layout.getElementAt(index) as Panel;
		}
		
		public function getPanelIndex(panel:Panel):int
		{
			return _layout.getElementIndex(panel);
		}
		
		//--- Event Handlers ---
		
		protected function onPanelSelect(event:Event):void
		{
			var index:int = _layout.getElementIndex( event.currentTarget );
			if(index >= 0) {
				var num:int = _layout.numElements;
				for(var i:int = 0; i < num; ++i)
				{
					var panel:Panel = _layout.getElementAt(i) as Panel;
					
					if(i == index) {
						if(!collapsible) panel.expand();
					}
					else panel.collapse();
				}
				
				//updateSize();
			}
		}
		
		protected function onLayoutResize(event:Event):void
		{
			this.setSize(_layout.width, _layout.height);
		}
		
		//--- Getter/Setters ---
		
		public var collapsible:Boolean = false;
		
		override public function set width(value:Number):void
		{
			var num:int = _layout.numElements;
			for(var i:int = 0; i < num; ++i)
			{
				var panel:Panel = _layout.getElementAt(i) as Panel;
				panel.width = value; //BUG FIXED: panel setSize() bug fixed.
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