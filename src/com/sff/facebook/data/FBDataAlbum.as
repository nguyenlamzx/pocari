package com.sff.facebook.data {
	
	import flash.net.URLVariables;

	public class FBDataAlbum extends FBDataContent {
		
		protected var arrPhotos : Array;
		
		public function FBDataAlbum( pData : Object = null ) {
			super( pData );
		}
		
		public function get description() : String { 
			return objData.description; 
		}
		
		public function get location() : String { 
			return objData.location; 
		}
		
		public function get link() : String { 
			return objData.link; 
		}
		
		public function get privacy() : String { 
			return objData.privacy; 
		}
		
		public function get numPhotos() : String { 
			return objData.count;
		}
		
		public function get photos() : Array { 
			return arrPhotos || null; 
		}
		
		/*
		public override function loadMoreInfos() : void {
			call( id+"/photos", [_onLoadMoreInfos, _onError] );
		}
		
		protected override function _onLoadMoreInfos( e : FBOAuthGraphEvent ) : void {
			arrPhotos = [];
			
			var n : int = e.data.data.length;
			for( var i:int = 0; i<n; i++) {
				arrPhotos.push( new FBDataPhoto( e.data.data[i] ) );
			}
			
			dispatchEvent( new FBEvent( FBEvent.DATA_MORE_INFOS, this ) );
		}
		
		public function create( pUserId : String, pName : String, pDescription : String = null) : void {
			var v : URLVariables = new URLVariables();
			v.name = pName;
			v.description = pDescription;
			
			_create( pUserId, "albums", v);
		}
		*/
				
		override public function toString() : String {
			return  '[FBDataAlbum id="'+id+'" name="'+name+'"]';
		}
	}
}
