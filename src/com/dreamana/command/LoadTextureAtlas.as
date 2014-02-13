package com.dreamana.command
{
	import com.dreamana.gui.UITextureProvider;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	
	public class LoadTextureAtlas extends BaseCommand
	{
		private var _url:String;
		private var _loader:Loader = new Loader();
		private var _pool:Object = {};
		private var _loaded:Boolean;
		
		
		public function LoadTextureAtlas(xmlURL:String)
		{
			_url = xmlURL;
		}
		
		override public function execute():void
		{
			if(_loaded) {
				//fast reuse
				var bmp:Bitmap = _loader.content as Bitmap;
				if(bmp) {
					for each(var provider:UITextureProvider in _pool) {
						provider.setData( bmp.bitmapData );
					}
				}
			}
			else {
				//load xml
				loadXML(_url);
			}
		}
		
		public function getSubTexture(name:String):UITextureProvider
		{
			var provider:UITextureProvider = _pool[name];
			if(provider == null) {
				provider = new UITextureProvider(null, _loader);
				_pool[name] = provider;
			}
			return provider;
		}
		
		private function loadXML(url:String):void
		{
			var xmlloader:URLLoader = new URLLoader();
			xmlloader.addEventListener(Event.COMPLETE, onXMLLoaded);
			xmlloader.load(new URLRequest(url));
		}
		
		private function loadImage(url:String):void
		{
			_loader.load(new URLRequest(url));
			
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
			
			var path:String = _url.substring(0, _url.lastIndexOf("/")+1) + xml.@imagePath;
			
			//set rects
			var xmllist:XMLList = xml.child("SubTexture");
			var num:int = xmllist.length();
			for(var i:int=0; i < num; ++i)
			{
				var item:XML = xmllist[i];
				
				var provider:UITextureProvider = _pool[item.@name];
				if(provider) {
					provider.rect = new Rectangle(item.@x, item.@y, item.@width, item.@height);
				}
				else {
					provider = new UITextureProvider(new Rectangle(item.@x, item.@y, item.@width, item.@height), _loader);
					_pool[item.@name] = provider;
				}
			}
			
			//load image
			loadImage(path);
		}
		
		//--- GETTER/SETTERS ---
		
		public function get url():String { return _url; }
		public function set url(value:String):void {
			
			if(_url != value) _loaded = false;
			
			_url = value; 
		}
		
		public function get loader():Loader { return _loader; }
	}
}