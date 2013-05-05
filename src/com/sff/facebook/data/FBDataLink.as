package com.sff.facebook.data
{
	import flash.net.URLVariables;

	/**
	 * @author Manu Bonnet
	 * @project TEST_fbconnect
	 * @date 25 mai 10
	 */
	 
	public class FBDataLink extends FBDataContent
	{
		
		function FBDataLink( pData : Object = null )
		{
			super( pData );
		}

		public function get picture() : String { return objData.picture; };
		public function get message() : String { return objData.message; };
		public function get link() : String { return objData.link; };
		public function get description() : String { return objData.description; };
		public function get caption() : String { return objData.caption; };
		
		/*
		*
		*/
		//public function create( pUserId : String, pLink : String, pName : String = "", pCaption : String = "", pDescription : String = "", pPicture : String = "", pProxy : FBProxy = null ) : void
		//{
			//var v : URLVariables = new URLVariables();
			//v.link = pLink;
			//v.name = pName;
			//v.caption = pCaption;
			//v.description = pDescription;
			//v.picture = pPicture;
			//
			//_create( pUserId, "feed", v, pProxy );
		//}
		
		/**
		*
		*/
		public override function toString() : String
		{
			return  '[FBDataLink id="'+id+'" name="'+name+'"]';
		}
	
	}
	
}