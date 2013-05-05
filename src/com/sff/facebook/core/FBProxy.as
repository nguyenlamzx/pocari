package com.sff.facebook.core {
	
	import com.adobe.serialization.json.JSON;
	import com.facebook.graph.Facebook;
	import com.sff.facebook.data.*;
	import com.sff.facebook.data.FBDataAlbum;
	import com.sff.facebook.events.FBEvent;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.net.URLRequestMethod;
	
	public class FBProxy extends EventDispatcher {
		
		private static var instance			:FBProxy;
		
		private var currentUserId			:String;
		
		public function FBProxy() {
			
		}
		
		public static function start():FBProxy {
			if (!instance) {
				instance= new FBProxy();
			}
			return instance;
		}
	
		public function init(applicationId:String):void {
			Facebook.init(applicationId, onInitHandler);			
		}
		
		public function login(permissions:String = "publish_stream, user_photos"):void {
			var opts:Object = { scope:permissions };
			Facebook.login(onLoginHandler, opts);
		}
		
		private function onInitHandler(result:Object, fail:Object):void {
			dispatchEvent(new FBEvent(FBEvent.INIT, result ? true : false));
		}
		
		private function onLoginHandler(result:Object, fail:Object):void {
			currentUserId = result ? result.uid : "";
			
			dispatchEvent(new FBEvent(FBEvent.LOGIN, result ? true : false));
		}
		
		/**
		 * Get user profile
		 *********************************************************************/
		public function getProfile(paramsInput:String = ""):void {
			var params:Object = null;
			var requestType:String = URLRequestMethod.GET;
			
			if (requestType == URLRequestMethod.POST) {
				try {
					params = com.adobe.serialization.json.JSON.decode(paramsInput) as Object;
				} catch (err:Error) {
					trace("\n\nERROR DECODING JSON: " + err.message);
				}
			}
			Facebook.api("/me", onCompleteGetProfile, params, requestType); 
		}
		
		protected function onCompleteGetProfile(result:Object, fail:Object):void {
			if (result) {
				var userprofile:FBDataUser = new FBDataUser(result);
				dispatchEvent(new FBEvent(FBEvent.GET_USERPROFILE, true, userprofile));				
			} else {				 
				dispatchEvent(new FBEvent(FBEvent.GET_USERPROFILE, false));				
			}
		}
		
		//////////////////////////////////////////////////////////////////////////////
		//								CALL FUNCTIONS								//
		//////////////////////////////////////////////////////////////////////////////
		/**
		 * call method
		 * @param	type	[events, friends, albums, ...]
		 * @param	pId		[me, otherID]
		 * @param	params	
		 */
		public function call(type:String, strId:String = null, requestType:String = FBMethod.GET, params:Object = null):void {
			var path:String = (strId || currentUserId) + "/" + type;
			var prefix:String;// = (requestType == FBMethod.GET) ? "onGet" : "onPost";
			
			switch (requestType) {
				case FBMethod.POST:	
					prefix = "onPost";
					break;
				
				case FBMethod.GET:
					prefix = "onGet";
					break;
					
				case FBMethod.DELETE:
					prefix = "onDelete";
					break;
			}
			
			var callback:Function = this[prefix + capitalizedEachWord(type) + "Complete"] as Function;
			Facebook.api(path, callback, params, requestType);
		}
		
		public function query(type:String, strId:String = null, requestType:String = FBMethod.GET, params:Object = null):void {
			var path:String = (strId || currentUserId) + "/" + type;
			
			Facebook.api(path, onQueryComplete, params, requestType);
		}
		
		private function onQueryComplete(result:Object, fail:Object):void {
			if (result) {
				var arrAlbums	:Array = new Array();
				
				for each (var item:Object in result) {
					arrAlbums.push(new FBDataAlbum(item));
				}
				dispatchEvent(new FBEvent(FBEvent.ALBUMS_COMPLETE, true, result));				
			} else {				 
				dispatchEvent(new FBEvent(FBEvent.ALBUMS_COMPLETE, false));				
			}
		}
		
		public function getPhoto(photoId:String):void {
			Facebook.api(photoId, onGetPhotoComplete, null);
		}
		
		private function onGetPhotoComplete(result:Object, fail:Object):void {
			if (result) {
				dispatchEvent(new FBEvent(FBEvent.PHOTO_COMPLETE, true, new FBDataPhoto(result)));				
			} else {				 
				dispatchEvent(new FBEvent(FBEvent.PHOTO_COMPLETE, false));				
			}
		}
		
		protected function onGetAlbumsComplete(result:Object, fail:Object):void {
			if (result) {
				var arrAlbums	:Array = new Array();
				ExternalInterface.call('console.log', result);
				for each (var item:Object in result) {
					arrAlbums.push(new FBDataAlbum(item));
				}
				dispatchEvent(new FBEvent(FBEvent.ALBUMS_COMPLETE, true, arrAlbums));				
			} else {				 
				dispatchEvent(new FBEvent(FBEvent.ALBUMS_COMPLETE, false));				
			}
		}
		
		protected function onGetPhotoAlbumsComplete(result:Object, fail:Object):void {
			if (result) {
				var arrAlbums	:Array = new Array();
				
				for each (var item:Object in result) {
					arrAlbums.push(new FBDataAlbum(item));
				}
				dispatchEvent(new FBEvent(FBEvent.ALBUMS_COMPLETE, true, arrAlbums));				
			} else {				 
				dispatchEvent(new FBEvent(FBEvent.ALBUMS_COMPLETE, false));				
			}
		}
		
		protected function onPostAlbumsComplete(result:Object, fail:Object):void {
			if (result) {
				dispatchEvent(new FBEvent(FBEvent.ALBUMS_COMPLETE, true, result));				
			} else {				 
				dispatchEvent(new FBEvent(FBEvent.ALBUMS_COMPLETE, false));				
			}
		}
		
		protected function onGetFriendsComplete(result:Object, fail:Object):void {
			if (result) {
				var arrFriends:Array = new Array();
				
				for each (var item:Object in result) {
					arrFriends.push(new FBDataUser(item));
				}
				dispatchEvent(new FBEvent(FBEvent.FRIENDS_COMPLETE, true, arrFriends));
			} else {				 
				dispatchEvent(new FBEvent(FBEvent.FRIENDS_COMPLETE, false));
			}
		}
		
		protected function onGetEventsComplete(result:Object, fail:Object):void {
			if (result) {
				var arrEvents:Array = new Array();
				
				for each (var item:Object in result) {
					arrEvents.push(new FBDataEvent(item));
				}
				dispatchEvent(new FBEvent(FBEvent.EVENTS_COMPLETE, true, arrEvents));
			} else {				 
				dispatchEvent(new FBEvent(FBEvent.EVENTS_COMPLETE, false));
			}
		}
		
		// accounts = applications
		protected function onGetAccountsComplete(result:Object, fail:Object):void {
			if (result) {
				var arrApplications:Array = new Array();
				
				for each (var item:Object in result) {
					arrApplications.push(new FBDataApplication(item));
				}
				dispatchEvent(new FBEvent(FBEvent.ACCOUNT_COMPLETE, true, arrApplications));
			} else {				 
				dispatchEvent(new FBEvent(FBEvent.ACCOUNT_COMPLETE, false));
			}
		}
		
		protected function onGetVideosComplete(result:Object, fail:Object):void {
			if (result) {
				var arrVideos:Array = new Array();
				
				for each (var item:Object in result) {
					arrVideos.push(new FBDataVideo(item));
				}
				dispatchEvent(new FBEvent(FBEvent.VIDEOS_COMPLETE, true, arrVideos));
			} else {				 
				dispatchEvent(new FBEvent(FBEvent.VIDEOS_COMPLETE, false));
			}
		}
		
		protected function onGetPhotosComplete(result:Object, fail:Object):void {
			if (result) {
				var arrPhotos:Array = new Array();
				
				for each (var item:Object in result) {
					arrPhotos.push(new FBDataPhoto(item));
				}
				dispatchEvent(new FBEvent(FBEvent.PHOTOS_COMPLETE, true, arrPhotos));
			} else {				 
				dispatchEvent(new FBEvent(FBEvent.PHOTOS_COMPLETE, false));
			}
		}
		
		protected function onPostPhotosComplete(result:Object, fail:Object):void {
			if (result) {
				dispatchEvent(new FBEvent(FBEvent.PHOTOS_COMPLETE, true, new FBDataPhoto(result)));
			} else {				 
				dispatchEvent(new FBEvent(FBEvent.PHOTOS_COMPLETE, false));
			}
		}
		
		protected function onGetLikesComplete(result:Object, fail:Object):void {
			if (result) {
				var arrLikes:Array = new Array();
				
				for each (var item:Object in result) {
					arrLikes.push(new FBDataLike(item));
				}
				dispatchEvent(new FBEvent(FBEvent.LIKES_COMPLETE, true, arrLikes));
			} else {				 
				dispatchEvent(new FBEvent(FBEvent.LIKES_COMPLETE, false));
			}
		}
		
		protected function onPostLikesComplete(result:Object, fail:Object):void {
			if (result) {
				dispatchEvent(new FBEvent(FBEvent.LIKES_COMPLETE, true, result as Boolean));
			} else {				 
				dispatchEvent(new FBEvent(FBEvent.LIKES_COMPLETE, false));
			}
		}
		
		protected function onGetFeedComplete(result:Object, fail:Object):void {
			if (result) {
				var arrFeed:Array = new Array();
				
				for each (var item:Object in result) {
					arrFeed.push(new FBDataPost(item));
				}
				dispatchEvent(new FBEvent(FBEvent.FEED_COMPLETE, true, arrFeed));
			} else {				 
				dispatchEvent(new FBEvent(FBEvent.FEED_COMPLETE, false));
			}
		}
		
		protected function onGetPostsComplete(result:Object, fail:Object):void {
			if (result) {
				var arrPosts:Array = new Array();
				
				for each (var item:Object in result) {
					arrPosts.push(new FBDataPost(item));
				}
				dispatchEvent(new FBEvent(FBEvent.POSTS_COMPLETE, true, arrPosts));
			} else {				 
				dispatchEvent(new FBEvent(FBEvent.POSTS_COMPLETE, false));
			}
		}
		
		protected function onGetFriendlistsComplete(result:Object, fail:Object):void {
			if (result) {
				var arrFriendlists:Array = new Array();
				
				for each (var item:Object in result) {
					arrFriendlists.push(new FBDataFriendlists(item));
				}
				dispatchEvent(new FBEvent(FBEvent.FRIENDLISTS_COMPLETE, true, arrFriendlists));
			} else {				 
				dispatchEvent(new FBEvent(FBEvent.FRIENDLISTS_COMPLETE, false));
			}
		}
		
		protected function onGetHomeComplete(result:Object, fail:Object):void {
			if (result) {
				var arrHomeFeeds:Array = new Array();
				
				for each (var item:Object in result) {
					arrHomeFeeds.push(new FBDataPost(item));
				}
				dispatchEvent(new FBEvent(FBEvent.HOME_FEED_COMPLETE, true, arrHomeFeeds));
			} else {				 
				dispatchEvent(new FBEvent(FBEvent.HOME_FEED_COMPLETE, false));
			}
		}
		
		protected function onGetNotesComplete(result:Object, fail:Object):void {
			if (result) {
				var arrNotes:Array = new Array();
				
				for each (var item:Object in result) {
					arrNotes.push(new FBDataNote(item));
				}
				dispatchEvent(new FBEvent(FBEvent.NOTES_COMPLETE, true, arrNotes));
			} else {				 
				dispatchEvent(new FBEvent(FBEvent.NOTES_COMPLETE, false));
			}
		}
		
		protected function onGetLinksComplete(result:Object, fail:Object):void {
			if (result) {
				var arrLinks:Array = new Array();
				
				for each (var item:Object in result) {
					arrLinks.push(new FBDataLike(item));
				}
				dispatchEvent(new FBEvent(FBEvent.LINKS_COMPLETE, true, arrLinks));
			} else {				 
				dispatchEvent(new FBEvent(FBEvent.LINKS_COMPLETE, false));
			}
		}
		
		protected function onGetInterestsComplete(result:Object, fail:Object):void {
			if (result) {
				var arrInterests:Array = new Array();
				
				for each (var item:Object in result) {
					arrInterests.push(new FBDataInterest(item));
				}
				dispatchEvent(new FBEvent(FBEvent.INTERETS_COMPLETE, true, arrInterests));
			} else {				 
				dispatchEvent(new FBEvent(FBEvent.INTERETS_COMPLETE, false));
			}
		}
		
		protected function onGetGroupsComplete(result:Object, fail:Object):void {
			if (result) {
				var arrGroupss:Array = new Array();
				
				for each (var item:Object in result) {
					arrGroupss.push(new FBDataGroup(item));
				}
				dispatchEvent(new FBEvent(FBEvent.GROUPS_COMPLETE, true, arrGroupss));
			} else {				 
				dispatchEvent(new FBEvent(FBEvent.GROUPS_COMPLETE, false));
			}
		}
		
		private function capitalizedEachWord(text:String):String {
			var charCode	:Number;
			var word		:String = "";
			var newText		:String = "";
			var whitespace	:Boolean = true; // First capitalized
			
			for (var i:int = 0; i < text.length; i++) {
				word = text.substr(i, 1);
				
				if (word == " ") {
					whitespace = true;
					continue;
				}
				
				if (whitespace) {
					whitespace = false;
					
					// word.length = 1; ==> index = 0
					// [A,Z,a,z] = [65,90,97,122]
					charCode = word.charCodeAt(0);
					
					if (charCode >= 90 && charCode <= 122) {			
						charCode = word.charCodeAt(0) - 32;
						word = String.fromCharCode(charCode);
					}
				}
				newText += word;
			}
			
			return newText;
		}
		
		/*
		public function getInfos( pId : String = null ) : void
		{
			call( ( pId || currentUserId )+"", _getCBInfos );
		}
		
		protected function _getCBInfos( e : FBOAuthGraphEvent ) : void
		{
			removeURLLoader( e.currentTarget as URLLoader, _getCBInfos );
			
			dispatchEvent( new FBEvent( FBEvent.INFOS_COMPLETE, new FBDataUser( e.data ) ) );
		}
		
		
		public function getPhotos( pId : String = null ) : void
		{
			call( ( pId || currentUserId )+"/photos", _getCBPhotos );
		}
		
		protected function _getCBPhotos( e : FBOAuthGraphEvent ) : void
		{
			removeURLLoader( e.currentTarget as URLLoader, _getCBPhotos );
			
			var a : Array = [];
			
			var n : int = e.data.data.length;
			for( var i:int = 0; i<n; i++) 
			{
				a.push( new FBDataPhoto( e.data.data[i] ) );
			}
			
			dispatchEvent( new FBEvent( FBEvent.PHOTOS_COMPLETE, a ) );
		}
		
		
		public function getAlbums( pId : String = null ) : void
		{
			call( ( pId || currentUserId )+"/albums", _getCBAlbums );
		}
		
		protected function _getCBAlbums( e : FBOAuthGraphEvent ) : void
		{
			removeURLLoader( e.currentTarget as URLLoader, _getCBAlbums );
			
			var a : Array = [];
			
			var n : int = e.data.data.length;
			for( var i:int = 0; i<n; i++) 
			{
				a.push( new FBDataAlbum( e.data.data[i] ) );
			}
			
			dispatchEvent( new FBEvent( FBEvent.ALBUMS_COMPLETE, a ) );
		}
		
		
		public function getFriends( pId : String = null ) : void
		{
			call( ( pId || currentUserId )+"/friends", _getCBFriends );
		}
		
		protected function _getCBFriends( e : FBOAuthGraphEvent ) : void
		{
			removeURLLoader( e.currentTarget as URLLoader, _getCBFriends );
			
			var a : Array = [];
			
			var n : int = e.data.data.length;
			for( var i:int = 0; i<n; i++) 
			{
				a.push( new FBDataUser( e.data.data[i] ) );
			}
			
			dispatchEvent( new FBEvent( FBEvent.FRIENDS_COMPLETE, a));
		}
		
		
		public function getEvents( pId : String = null ) : void
		{
			call( ( pId || currentUserId )+"/events", _getCBEvents );
		}
		
		protected function _getCBEvents( e : FBOAuthGraphEvent ) : void
		{
			removeURLLoader( e.currentTarget as URLLoader, _getCBEvents );
			
			var a : Array = [];
			
			var n : int = e.data.data.length;
			for( var i:int = 0; i<n; i++) 
			{
				a.push( new FBDataEvent( e.data.data[i] ) );
			}
			
			dispatchEvent( new FBEvent( FBEvent.EVENTS_COMPLETE, a));
		}
		
		
		public function getHomeFeed( pId : String = null ) : void
		{
			call( ( pId || currentUserId )+"/home", _getCBHomeFeed );
		}
		
		protected function _getCBHomeFeed( e : FBOAuthGraphEvent ) : void
		{
			removeURLLoader( e.currentTarget as URLLoader, _getCBHomeFeed );
			
			var a : Array = [];
			
			var n : int = e.data.data.length;
			for( var i:int = 0; i<n; i++) 
			{
				a.push( new FBDataPost( e.data.data[i] ) );
			}
			
			dispatchEvent( new FBEvent( FBEvent.HOME_FEED_COMPLETE, a));
		}
		
		
		public function getFeed( pId : String = null ) : void
		{
			call( ( pId || currentUserId )+"/feed", _getCBFeed );
		}
		
		protected function _getCBFeed( e : FBOAuthGraphEvent ) : void
		{
			removeURLLoader( e.currentTarget as URLLoader, _getCBFeed );
			
			var a : Array = [];
			
			var n : int = e.data.data.length;
			for( var i:int = 0; i<n; i++) 
			{
				a.push( new FBDataPost( e.data.data[i] ) );
			}
			
			dispatchEvent( new FBEvent( FBEvent.FEED_COMPLETE, a));
		}
		
		
		public function getPosts( pId : String = null ) : void
		{
			call( ( pId || currentUserId )+"/posts", _getCBPosts );
		}
		
		protected function _getCBPosts( e : FBOAuthGraphEvent ) : void
		{
			removeURLLoader( e.currentTarget as URLLoader, _getCBPosts );
			
			var a : Array = [];
			
			var n : int = e.data.data.length;
			for( var i:int = 0; i<n; i++) 
			{
				a.push( new FBDataPost( e.data.data[i] ) );
			}
			
			dispatchEvent( new FBEvent( FBEvent.POSTS_COMPLETE, a));
		}
		
		
		public function getNotes( pId : String = null ) : void
		{
			call( ( pId || currentUserId )+"/notes", _getCBNotes );
		}
		
		protected function _getCBNotes( e : FBOAuthGraphEvent ) : void
		{
			removeURLLoader( e.currentTarget as URLLoader, _getCBNotes );
			
			var a : Array = [];
			
			var n : int = e.data.data.length;
			for( var i:int = 0; i<n; i++) 
			{
				a.push( new FBDataNote( e.data.data[i] ) );
			}
			
			dispatchEvent( new FBEvent( FBEvent.NOTES_COMPLETE, a));
		}
		
		
		public function getGroups( pId : String = null ) : void
		{
			call( ( pId || currentUserId )+"/groups", _getCBGroups );
		}
		
		protected function _getCBGroups( e : FBOAuthGraphEvent ) : void
		{
			removeURLLoader( e.currentTarget as URLLoader, _getCBGroups );
			
			var a : Array = [];
			
			var n : int = e.data.data.length;
			for( var i:int = 0; i<n; i++) 
			{
				a.push( new FBDataGroup( e.data.data[i] ) );
			}
			
			dispatchEvent( new FBEvent( FBEvent.GROUPS_COMPLETE, a));
		}
		
		
		public function getLikes( pId : String = null ) : void
		{
			call( ( pId || currentUserId )+"/likes", _getCBLikes );
		}
		
		protected function _getCBLikes( e : FBOAuthGraphEvent ) : void
		{
			removeURLLoader( e.currentTarget as URLLoader, _getCBLikes );
			
			var a : Array = [];
			
			var n : int = e.data.data.length;
			for( var i:int = 0; i<n; i++) 
			{
				a.push( new FBDataLike( e.data.data[i] ) );
			}
			
			dispatchEvent( new FBEvent( FBEvent.LIKES_COMPLETE, a));
		}
		
		
		public function getVideos( pId : String = null ) : void
		{
			call( ( pId || currentUserId )+"/videos", _getCBVideos );
		}
		
		protected function _getCBVideos( e : FBOAuthGraphEvent ) : void
		{
			removeURLLoader( e.currentTarget as URLLoader, _getCBVideos );
			
			var a : Array = [];
			
			var n : int = e.data.data.length;
			for( var i:int = 0; i<n; i++) 
			{
				a.push( new FBDataVideo( e.data.data[i] ) );
			}
			
			dispatchEvent( new FBEvent( FBEvent.VIDEOS_COMPLETE, a));
		}
		
		
		public function getLinks( pId : String = null ) : void
		{
			call( ( pId || currentUserId )+"/links", _getCBLinks );
		}
		
		protected function _getCBLinks( e : FBOAuthGraphEvent ) : void
		{
			removeURLLoader( e.currentTarget as URLLoader, _getCBVideos );
			
			var a : Array = [];
			
			var n : int = e.data.data.length;
			for( var i:int = 0; i<n; i++) 
			{
				a.push( new FBDataLink( e.data.data[i] ) );
			}
			
			dispatchEvent( new FBEvent( FBEvent.LINKS_COMPLETE, a));
		}
		
		
		public function getInterets( pInterest : String, pId : String = null ) : void
		{
			call( ( pId || currentUserId )+"/"+pInterest, _getCBInterets );
		}
		
		protected function _getCBInterets( e : FBOAuthGraphEvent ) : void
		{
			removeURLLoader( e.currentTarget as URLLoader, _getCBInterets );
			
			var a : Array = [];
			
			var n : int = e.data.data.length;
			for( var i:int = 0; i<n; i++) 
			{
				a.push( new FBDataInterest( e.data.data[i] ) );
			}
			
			dispatchEvent( new FBEvent( FBEvent.INTERETS_COMPLETE, a));
		}
		
		
		public function publish( pType : String, pId : String, pParams : Object = null ) : void
		{
			var v : URLVariables;
			if( pParams is URLVariables ) v = pParams as URLVariables;
			else
			{
				v = new URLVariables();
				for (var n : String in pParams )
				{
					v[n] = pParams[n];
					trace(n + " > " + pParams[n]);
				}
			}
			
			call( ( pId || currentUserId )+"/"+pType, [_onPublish, error], v, URLRequestMethod.POST );
		}
		
		protected function _onPublish( e : FBOAuthGraphEvent ) : void
		{
			dispatchEvent( new FBEvent( FBEvent.PUBLISHED, new FBAbstractData( e.data ) ) );
		}
		
		public function search( pType : String, pRequest : String ) : void
		{
			var v : URLVariables =  new URLVariables();
			v.q = pRequest;
			v.type = pType;
			
			call( "search", _onSearch, v, URLRequestMethod.GET );
		}
		
		protected function _onSearch( e : FBOAuthGraphEvent ) : void
		{
			dispatchEvent( new FBEvent( FBEvent.SEARCH_RESULT, e.data ) );
		}
		
		public function call( pPath:String, pCallBack : * = null, pData:URLVariables=null, pMethod:String="", pToken:String=null, pUrlDataFormat:String = null ):void
		{
			var callback : Function;
			var callbackError : Function;
			var callbackProgress : Function;
			
			if( pCallBack is Function ) callback = pCallBack;
			else if( pCallBack is Array )
			{
				callback = pCallBack[0];
				callbackError = pCallBack[1];
				callbackProgress = pCallBack[2];
			}
			
			var loader:URLLoader = facebook.call( pPath, pData, pMethod, pToken );
	        loader.dataFormat = pUrlDataFormat || URLLoaderDataFormat.TEXT;
	        loader.addEventListener( FBOAuthGraphEvent.DATA, callback || _getCallBack );
        	loader.addEventListener( FBOAuthGraphEvent.ERROR, callbackError || error );
			if( callbackProgress != null ) loader.addEventListener( ProgressEvent.PROGRESS, callbackProgress );
		}
		
		protected function _getCallBack( e : FBOAuthGraphEvent ):void
		{
			( e.currentTarget as URLLoader ).removeEventListener( FBOAuthGraphEvent.DATA, _getCallBack );
			
			dispatchEvent( new FBEvent( FBEvent.COMPLETE ) );
		}
		
		public function removeURLLoader( pUrlLoader : URLLoader, pCallBack : Function = null ) : void
		{
			pUrlLoader.removeEventListener( FBOAuthGraphEvent.DATA, pCallBack || _getCallBack );
			pUrlLoader.close();
			pUrlLoader = null;
		}
		
		public function getURLRequest( path : String, data:URLVariables=null, 
            method:String="", token:String=null) : URLRequest
        {
			return facebook.getURLRequest( path, data, method, token );
		}
		
		public function disconnect() : void
		{
			if( facebook ) {
				facebook.logOut();
				facebook.addEventListener(FBOAuthGraphEvent.AUTHORIZED, authorized);
			}
			dispatchEvent( new FBEvent( FBEvent.DISCONNECT ) );
		}
		
		public function get token() : String { return facebook.token; }
		public function get apiPath() : String { return facebook.apiPath; }

		public function dispose() : void
		{
			facebook.removeEventListener(FBOAuthGraphEvent.AUTHORIZED, authorized);
			facebook = null;
		}
		*/
	}
}
