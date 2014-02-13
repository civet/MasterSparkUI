package test
{
	import com.dreamana.command.LoadSlice9;
	import com.dreamana.command.LoadTextureAtlas;
	import com.dreamana.controls.Button;
	import com.dreamana.controls.skins.ButtonTextureSkin;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class TestSpritesheet extends Sprite
	{
		public function TestSpritesheet()
		{
			stage? init() : this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event=null):void
		{
			if(event) this.removeEventListener(event.type, init);
		
			//start
			var button:Button = new Button();
			this.addChild(button);
			
			//skinning
			var skin:ButtonTextureSkin = new ButtonTextureSkin();
			button.skin = skin;
			
			var loadSlice9:LoadSlice9 = new LoadSlice9("../assets/ui-9slices.xml");
			var loadTexture:LoadTextureAtlas = new LoadTextureAtlas("../assets/ui-sprites.xml");
						
			skin.setStyleAsync("normal-9slice", loadSlice9.getSlice9("input"));
			skin.setStyleAsync("down-9slice", loadSlice9.getSlice9("shadow"));
			skin.setStyleAsync("normal-image", loadTexture.getSubTexture("input"));
			skin.setStyleAsync("down-image", loadTexture.getSubTexture("shadow"));
			
			loadSlice9.execute();
			loadTexture.execute();
		}
	}
}