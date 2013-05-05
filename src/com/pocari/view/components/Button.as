package com.pocari.view.components 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class Button extends Sprite 
	{
		public var mcHit:MovieClip;
		public var txtText:TextField;
		
		public function Button() {
			init();
		}
		
		private function init():void {
			buttonMode = true;
			mouseEnabled = true;
			mouseChildren = false;
			
			txtText.autoSize = 'left';
			
			addEventListener(MouseEvent.MOUSE_OUT, onOutHandler);
			addEventListener(MouseEvent.MOUSE_OVER, onOverHandler);
			
		}
		
		private function onOutHandler(e:MouseEvent):void 
		{
			mcHit.gotoAndStop(1);
		}
		
		private function onOverHandler(e:MouseEvent):void 
		{
			mcHit.gotoAndStop(2);
		}
		
		public function set label(text:String):void {
			txtText.text = text;
			txtText.x = mcHit.width / 2 - txtText.width / 2;
		}
		
	}

}