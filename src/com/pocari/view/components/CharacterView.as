package com.pocari.view.components 
{
	import com.pocari.view.base.IView;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class CharacterView extends Sprite implements IView
	{
		public var mcImage		:Sprite;
		
		private var _image		:Bitmap;
		
		public function CharacterView() {
			if (stage) {
				init();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
			}
		}
		
		private function onAddedToStageHandler(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
			
			init();
		}
		
		public function init(data:Object = null):void {
			buttonMode = true;
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		public function show(delay:Number = 0):Number {
			visible = true;
			return delay;
		}
		
		public function hide(delay:Number = 0):Number {
			visible = false;
			return delay;
		}
		
		public function set image(value:BitmapData):void {
			if (!value) {
				trace('CharacterView set image null');
				return;
			}
			mouseEnabled = true;
			
			if (!_image) {
				_image = new Bitmap();
			}
			_image.bitmapData = value;
			
			_image.width = 47;
			_image.scaleY = _image.scaleX;
			
			if (_image.height > 47) {
				_image.height = 47;
				_image.scaleX = _image.scaleY;
			}
			
			_image.x = -(_image.width / 2);
			_image.y = -(_image.height / 2);
			
			mcImage.alpha = 1;
			mcImage.addChild(_image);
		}
		
		public function dispose():void {
			
		}
		
	}

}