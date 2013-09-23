package com.dreamana.controls
{
	import com.dreamana.controls.skins.TextInputSkin;
	import com.dreamana.gui.SkinnableComponent;
	
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.text.TextField;
	
	
	[Event(name="textInput", type="flash.events.TextEvent")]
	
	public class TextInput extends SkinnableComponent
	{
		public static const STATE_NORMAL:String = "normal";
		public static const STATE_DISABLED:String = "disabled";
		
		protected var _text:String;
		protected var _textfieldProps:Object;
		
		protected var _textfield:TextField;
		
		
		public function TextInput()
		{
			//default setting
			_width = 100;
			_height = 20;
			_skinState = STATE_NORMAL;
			_skinClass = TextInputSkin;
			_text = "";
			
			//view
			this.addChildren();
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			if(partName == "textfield") {
				_textfield = instance as TextField;
				
				applyTextFieldProps();
				
				_textfield.text = _text;
				
				_textfield.addEventListener(TextEvent.TEXT_INPUT, onTextInput);
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if(partName == "textfield") {
				_textfield = instance as TextField;
				
				_textfield.removeEventListener(TextEvent.TEXT_INPUT, onTextInput);
			}
		}
		
		protected function applyTextFieldProps():void
		{
			if(!_textfield) return;
			
			for(var key:String in _textfieldProps) {
				if(_textfield.hasOwnProperty(key)) _textfield[key] = _textfieldProps[key];
			}
		}
		
		//--- PUBLIC METHODS ---
		
		public function setTextFieldProps(params:Object):void
		{
			_textfieldProps = params;
			
			applyTextFieldProps();
		}
		
		//--- EVENT HANDLERS ---
		
		protected function onTextInput(event:TextEvent):void
		{
			_text = _textfield.text + event.text;
			
			if(hasEventListener(event.type)) this.dispatchEvent( event );
		}
		
		//--- GETTER/SETTERS ---
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			
			//enabled | disabled state
			if(value) changeState( STATE_NORMAL );
			else changeState( STATE_DISABLED );
		}
		
		public function get text():String
		{ 
			//_text = _textfield ? _textfield.text : "";
			return _text;
		}
		
		public function set text(value:String):void
		{
			_text = value;
			if(_textfield) _textfield.text = _text;
		}
	}
}