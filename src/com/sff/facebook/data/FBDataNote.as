package com.sff.facebook.data
{

	/**
	 * @author Manu Bonnet
	 * @project TEST_fbconnect
	 * @date 25 mai 10
	 */
	 
	public class FBDataNote extends FBDataContent
	{
		
		function FBDataNote( pData : Object = null )
		{
			super( pData );
		}
		
		public function get subject() : String { return objData.subject; };
		public function get message() : String { return objData.message; };
		
		/**
		*
		*/
		public override function toString() : String
		{
			return  '[FBDataNote id="'+id+'"]';
		}
	
	}
	
}