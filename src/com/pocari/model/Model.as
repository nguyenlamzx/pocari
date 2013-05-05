package com.pocari.model 
{
	import com.pocari.FbService;
	import flash.external.ExternalInterface;
	
	public class Model 
	{
		private static const MY_CHARACTERS		:String = 'my-characters';
		private static const CHARACTER_SAMPLE	:String = 'characters-sample';
		
		protected static var _instance			:Model;
		
		private var _xml						:XML;
		
		private var _albums						:Array;
		
		private var _listMyCharacters			:Array;
		private var _listCharactersSample		:Array;
		
		public function Model() {
			if (Model._instance) {
				throw new Error('Singleton class');
			}
			Model._instance = this;
			
			_albums = [];
		}
		
		public static function get instance():Model {
			if (!Model._instance) {
				Model._instance = new Model();
			}
			
			return _instance;
		}
		
		public function parseData(xml:XML):void {
			_xml = xml;
			
			var i:int = 0;
			var len:int = 0;
			var list:XMLList = null;
			
			list = _xml.characters.(@id == CHARACTER_SAMPLE).character;
			len = list.length();
			_listCharactersSample = [];
			
			for (i = 0; i < len; i++) {
				_listCharactersSample.push(new CharacterItem(list[i]));
			}
			
			list = _xml.characters.(@id == MY_CHARACTERS).character;
			len = list.length();
			_listMyCharacters = [];
			
			for (i = 0; i < len; i++) {
				_listMyCharacters.push(new CharacterItem(list[i]));
			}
		}
		
		public function addAlbum(album:FBDataAlbum):void {
			if (!_albums) {
				_albums = [];
			}
			try {
				_albums.push(album);
			} catch (err:Error){
				ExternalInterface.call('console.log', "addAlbum", err);
			}
		}
		
		public function clearAlbums():void {
			_albums = [];
		}
		
		/*********************************************************
		 * Getter
		 */
		public function get xml():XML {
			return _xml;
		}
		
		public function get listMyCharacters():Array {
			return _listMyCharacters;
		}
		
		public function get listCharactersSample():Array {
			return _listCharactersSample;
		}
		
		public function get fb():FbService {
			return FbService.instance;
		}
		
		public function get albums():Array {
			return _albums;
		}
		
		/***********************************************************/
	}
}