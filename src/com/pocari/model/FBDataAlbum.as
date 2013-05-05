package com.pocari.model 
{
	import com.sff.facebook.data.FBAbstractData;
	import flash.external.ExternalInterface;
	
	public class FBDataAlbum extends FBAbstractData 
	{
		private var _photos:Array;
		
		public function FBDataAlbum(pData:Object=null) {
			super(pData);
			
			_photos = [];
			
			if (pData.hasOwnProperty('photos') && pData.photos.hasOwnProperty('data')) {
				var items:Object = pData.photos.data;
				
				for each (var item:Object in items) {
					photos.push(new FBDataPhoto(item));
				}
			}			
		}
		
		public function get name():String {
			return objData.name;
		}
		
		public function get count():int {
			return objData.count;
		}
		
		public function get photos():Array {
			return _photos;
		}
		
		
	}

}