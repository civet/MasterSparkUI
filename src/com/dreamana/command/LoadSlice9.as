package com.dreamana.command
{
	import com.dreamana.gui.UISlice9Provider;
	
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class LoadSlice9 extends BaseCommand
	{
		private var _url:String;
		private var _pool:Object = {};
		private var _loaded:Boolean;
		
		public function LoadSlice9(xmlURL:String)
		{
			_url = xmlURL;
		}
		
		override public function execute():void
		{
			if(_loaded) {
				//fast reuse
				for each(var provider:UISlice9Provider in _pool) {
					provider.setData( provider.getData() );
				}
			}
			else {
				//load xml
				loadXML(_url);
			}
		}
		
		public function getSlice9(name:String):UISlice9Provider
		{
			var provider:UISlice9Provider = _pool[name];
			if(provider == null) {
				provider = new UISlice9Provider();
				_pool[name] = provider;
			}
			return provider;
		}
		
		private function loadXML(url:String):void
		{
			var xmlloader:URLLoader = new URLLoader();
			xmlloader.addEventListener(Event.COMPLETE, onXMLLoaded);
			xmlloader.load(new URLRequest(url));
			
			//flag
			_loaded = true;	
		}
		
		//--- Event Handlers ---
		
		private function onXMLLoaded(event:Event):void
		{
			var xmlloader:URLLoader = event.currentTarget as URLLoader;
			xmlloader.removeEventListener(Event.COMPLETE, onXMLLoaded);
			
			try {
				var xml:XML = new XML(xmlloader.data);
			}
			catch(e:Error) {
				trace(e.message);
				return;
			}
			
			//update
			var xmllist:XMLList = xml.child("Rectage");
			var num:int = xmllist.length();
			for(var i:int=0; i < num; ++i)
			{
				var item:XML = xmllist[i];
				
				var provider:UISlice9Provider = _pool[item.@name];
				if(provider) {
					provider.setData( new Rectangle(item.@x, item.@y, item.@width, item.@height) );
				}
				else {
					provider = new UISlice9Provider();
					provider.setData( new Rectangle(item.@x, item.@y, item.@width, item.@height) );
					
					_pool[item.@name] = provider;
				}
			}
		}
		
		//--- GETTER/SETTERS ---
		
		public function get url():String { return _url; }
		public function set url(value:String):void {
			
			if(_url != value) _loaded = false;
			
			_url = value; 
		}
	}
}