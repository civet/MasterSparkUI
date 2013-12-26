package com.dreamana.controls
{
	import com.dreamana.controls.skins.DropdownListSkin;
	import com.dreamana.gui.UIComponent;
	import com.dreamana.utils.trim;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	public class Autocomplete extends UIComponent
	{
		public var input:TextInput;
		public var list:List;
		public var scroller:Scroller;
		
		public var compareFunction:Function;//for match mode
		public var maxLines:int = 8;
		
		protected var _listData:Array;
		
		
		public function Autocomplete()
		{
			//default setting
			_width = 100;
			_height = 20;
			this.compareFunction = prefixMatch;
			
			//view
			this.addChildren();
		}
		
		protected function addChildren():void
		{
			input = new TextInput();
			
			list = new List();
			list.group.deselectable = false;
			
			scroller = new Scroller();
			scroller.autoHideScrollBar = true;
			scroller.skin = new DropdownListSkin();
			
			this.addChild(input);
			scroller.container.addChild(list);
					
			input.addEventListener(Event.CHANGE, onTextChange);
		}
		
		override public function setSize(w:Number, h:Number, deferred:Boolean=true):void
		{
			input.setSize(w, h);
			
			list.itemWidth = w - ((list.data && list.data.length > maxLines) ? scroller.vscrollbar.width : 0);
			
			scroller.width = w;
			scroller.height = Math.min(list.height, h * maxLines);
			
			super.setSize(w, h, deferred);
		}
		
		protected var pt:Point = new Point();
		protected function openList():void
		{
			if(this.stage) {
				pt.x = 0;
				pt.y = input.height;
				var pos:Point = this.localToGlobal(pt);
				scroller.x = pos.x;
				scroller.y = pos.y;
				stage.addChild(scroller);
				
				stage.addEventListener(MouseEvent.CLICK, onStageClick);
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			}
		}
		
		protected function closeList():void
		{
			var stageRef:Stage = this.stage ? this.stage : (list.parent as Stage);
			if(stageRef) {
				if(stageRef.contains(scroller)) stageRef.removeChild(scroller);
				
				stageRef.removeEventListener(MouseEvent.CLICK, onStageClick);
				stageRef.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			}
		}
		
		protected function searchFromList(keyword:String):Array
		{
			keyword = trim(keyword);
			
			var subListData:Array = null;
			
			if(keyword) {
				var num:int = _listData.length;
				for(var i:int = 0; i < num; ++i)
				{
					var itemData:Object = _listData[i];
					var label:String = itemData["label"];
					
					if( label && compareFunction(label, keyword) )
					{
						if(!subListData) subListData = [];
						subListData.push( itemData );
					}
				}
			}
			
			return subListData;
		}
		
		protected function confirmSelection():void
		{
			var itemData:Object = list.data[ list.group.selectedIndex ];
			var label:String = (itemData && itemData["label"]) ? itemData["label"] : "";
			
			if(multipleValuesEnabled) {
				var content:String = input.text;
				var index:int = content.lastIndexOf(separator);
				if(index != -1) input.text = content.substring(0, index) + ", " + label;
				else input.text = label;
				
				input.text += ", ";
			}
			else {
				input.text = label;
			}
			
			index = input.text.length;
			input.callTextFieldMethod("setSelection", index, index);
			
			if(this.stage) stage.focus = input.textField;
		}
		
		protected function scrollToSelection():void
		{
			var top:int = 0;
			var bottom:int = scroller.height - list.itemHeight - (scroller.hscrollbar.visible ? scroller.hscrollbar.height : 0);
			
			var i:int = list.group.selectedIndex;
			if(i != -1) {
				var itemY:Number = list.itemHeight * i;
				var posY:Number = scroller.container.y + itemY;
				if(posY < top) scroller.container.y = -itemY + top ;
				else if(posY > bottom) scroller.container.y = -itemY + bottom;
			}
			else {
				scroller.container.y = top;
			}
			
			scroller.updateScollBars();
		}
		
		protected function focusOn(object:InteractiveObject):void
		{
			if(object && this.stage) stage.focus = object;
		}
		
		//--- Event Handlers ---
				
		protected function onTextChange(event:Event):void
		{
			var content:String = input.text;
			var keyword:String;
			if(multipleValuesEnabled) {
				var index:int = content.lastIndexOf(separator);
				if(index != -1) keyword = content.substr(index+1);
				else keyword = content;
			}
			else {
				keyword = content;
			}
			
			var subListData:Array = searchFromList( keyword );
			list.data = subListData;
			
			if(subListData && subListData.length > 0) {
				//reset list width
				list.itemWidth = _width - (subListData.length > maxLines ? scroller.vscrollbar.width : 0);
				
				//reset scroll size
				scroller.height = Math.min(list.height, _height * maxLines);
				
				//reset scroll position
				scrollToSelection();
				
				//open list
				openList();
			}
			else {
				//close list
				closeList();
			}
		}
		
		protected function onStageClick(event:MouseEvent):void
		{
			var target:DisplayObject = event.target as DisplayObject;
			
			if(list.contains(target)) {
				confirmSelection();
				closeList();
				focusOn( input.textField );
				return;
			}
			
			if(!input.contains(target) && !scroller.contains(target)) closeList();
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			var group:ToggleGroup = list.group;
			
			switch(event.keyCode)
			{
				case Keyboard.UP:
					if(group.selectedIndex > 0) group.selectedIndex--;
					else group.selectedIndex = group.numItems-1;
					
					scrollToSelection();
					focusOn( stage );
					break;
				
				case Keyboard.DOWN:
					if(group.selectedIndex < group.numItems-1) group.selectedIndex++;
					else group.selectedIndex = 0;
					
					scrollToSelection();
					focusOn( stage );
					break;
				
				case Keyboard.ENTER:
					if(group.selectedIndex != -1) {
						confirmSelection();
						closeList();
						focusOn( input.textField );
					}
					break;
			}
						
			
		}
				
		//--- Getter/setters ---
		
		public function get data():Array { return _listData; }
		public function set data(value:Array):void
		{
			_listData = value;
		}
		
		public var multipleValuesEnabled:Boolean = false;
		
		public var separator:String = ",";
		
		//--- Utils ---
		
		public function prefixMatch(autocompletion:String, query:String):Boolean
		{
			autocompletion = autocompletion.toLowerCase();
			query = query.toLowerCase();
			return autocompletion.indexOf(query) == 0;
		}
		
		public function orderedMatch(autocompletion:String, query:String):Boolean
		{
			autocompletion = autocompletion.toLowerCase();
			query = query.toLowerCase();
			return autocompletion.indexOf(query) != -1;
		}
		
		/*
		public function anyMatch(autocompletion:String, query:String):Boolean
		{
			return ;
		}
		*/
	}
}