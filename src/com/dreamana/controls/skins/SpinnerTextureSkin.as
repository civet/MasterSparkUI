package com.dreamana.controls.skins
{
	import com.dreamana.controls.Button;
	import com.dreamana.controls.Spinner;
	import com.dreamana.gui.UISkin;
	
	import flash.display.Graphics;
	
	
	public class SpinnerTextureSkin extends UISkin
	{
		//element
		protected var _incrementButton:Button;
		protected var _decrementButton:Button;
		
		//texture
		
		public function SpinnerTextureSkin()
		{
			//default setting
			
			//elements
			_incrementButton = new Button();
			_decrementButton = new Button();
			
			//use texture skin
			_incrementButton.skin = new ButtonTextureSkin();
			_decrementButton.skin = new ButtonTextureSkin();
			
			//elementList
			this.addPart("incrementButton", _incrementButton);
			this.addPart("decrementButton", _decrementButton);
		}
		
		/* Hack */
		override public function setDrawingProps(props:Object):void
		{
			var buttonWidth:int = props["buttonWidth"];
			var buttonHeight:int = props["buttonHeight"];
			
			_incrementButton.setSize(buttonWidth, buttonHeight);
			_decrementButton.setSize(buttonWidth, buttonHeight);
			
			super.setDrawingProps(props);			
		}
		
		override protected function redraw():void
		{
			var g:Graphics;
			
			var w:int = _width;
			var h:int = _height;
			var state:String = _props["state"];
			var buttonWidth:int = _props["buttonWidth"];
			var buttonHeight:int = _props["buttonHeight"];
			var orientation:String = _props["orientation"];
			
			if(orientation == Spinner.VERTICAL) {
				_incrementButton.x = w - _decrementButton.width >> 1;
				_incrementButton.y = 0;
				
				_decrementButton.x = w - _decrementButton.width >> 1;
				_decrementButton.y = h - _incrementButton.height;
			}
			else {
				_decrementButton.x = 0;
				_decrementButton.y = h - _decrementButton.height >> 1;
				
				_incrementButton.x = w - _decrementButton.width;
				_incrementButton.y = h - _incrementButton.height >> 1;
			}
			
			switch(state) {
				case Spinner.STATE_DISABLED:
					_incrementButton.enabled = false;
					_decrementButton.enabled = false;
					break;
				
				case Spinner.STATE_NORMAL:
				default:
					if(_incrementButton.enabled == false) _incrementButton.enabled = true;
					if(_decrementButton.enabled == false) _decrementButton.enabled = true;
					break;
			}
		}
		
		override public function setStyle(style:String, value:Object):void
		{
			var buttonName:String = style.substring(0, style.indexOf("-"));
			var buttonStyle:String = style.substr(style.indexOf("-")+1);
			
			switch(buttonName) {
				case "increment":
					_incrementButton.skin.setStyle(buttonStyle, value);
					break;
				
				case "decrement":
					_decrementButton.skin.setStyle(buttonStyle, value);
					break;
			}
		}
	}
}