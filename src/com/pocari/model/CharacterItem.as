package com.pocari.model 
{
	import flash.display.BitmapData;
	
	
	public class CharacterItem 
	{
		private var _id		:String;
		private var _url	:String;
		private var _image	:BitmapData;
		
		public function CharacterItem(data:XML) {
			_id = data.@id
			_url = data.text();
		}
		
		public function get id():String {
			return _id;
		}
		
		public function get url():String {
			return _url;
		}
		
		public function get image():BitmapData {
			return _image;
		}
		
		public function set image(value:BitmapData):void {
			_image = value;
		}
		
	}

}