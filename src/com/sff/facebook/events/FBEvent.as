package com.sff.facebook.events {
	import flash.events.Event;

	public class FBEvent extends Event {
		
		public static const INIT		:String = "_csfe_init_";
		
		public static const LOGIN		:String = "_csfe_login_";
				
		public static const CONNECTED			:String = "fbConnected";
		public static const DISCONNECT			:String = "fbDisconnected";
		public static const UNAUTHORIZED		:String = "fbUnauthorized";
		
		
		public static const ERROR				:String = "fbError";

		public static const COMPLETE			:String = "fbComplete";
		public static const PUBLISHED			:String = "fbPublished";
		
		public static const DATA_CREATED		:String = "fbDataCreated";
		public static const DATA_MORE_INFOS		:String = "fbDataMoreInfos";
		public static const DATA_PICTURE		:String = "fbDataPicture";
		public static const SEARCH_RESULT		:String = "fbSearchResult";
		
		public static const GET_USERPROFILE		:String = "fbUserProfile";
		public static const INFOS_COMPLETE		:String = "fbInfosComplete";
		public static const PHOTOS_COMPLETE		:String = "fbPhotosComplete";
		public static const PHOTO_COMPLETE		:String = "fbPhotoComplete";		
		public static const ALBUMS_COMPLETE		:String = "fbAlbumsComplete";
		public static const FRIENDS_COMPLETE	:String = "fbFriendsComplete";
		public static const FRIENDLISTS_COMPLETE:String = "fbFriendlistsComplete";
		public static const HOME_FEED_COMPLETE	:String = "fbHomeComplete";
		public static const POSTS_COMPLETE		:String = "fbPostsComplete";
		public static const FEED_COMPLETE		:String = "fbFeedComplete";
		public static const INTERETS_COMPLETE	:String = "fbInteretsComplete";
		public static const LIKES_COMPLETE		:String = "fbLikesComplete";
		public static const NOTES_COMPLETE		:String = "fbNotesComplete";
		public static const LINKS_COMPLETE		:String = "fbLinksComplete";
		public static const VIDEOS_COMPLETE		:String = "fbVideosComplete";
		public static const EVENTS_COMPLETE		:String = "fbEventsComplete";
		public static const GROUPS_COMPLETE		:String = "fbGroupsComplete";
		public static const ACCOUNT_COMPLETE	:String = "fbAccountComplete";
		static public const QUERY_COMPLETE		:String = "fbQueryComplete";
		
		private var objData 	:Object;
		private var bolSuccess	:Boolean;
		
		public function FBEvent( pType : String, pSuccess:Boolean = false, pData : Object = null, pBubbles : Boolean = false, pCancelable : Boolean = false ) {
			bolSuccess = pSuccess;
			objData = pData;
			
			super( pType, pBubbles, pCancelable );
		}
		
		public function get success():Boolean {
			return bolSuccess;
		}
		
		public function get currentData():Object {
			return objData;
		}

		override public function clone() : Event {
			return new FBEvent( type, bolSuccess, objData, bubbles, cancelable );
		}
	}
}