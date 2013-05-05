package com.sff.facebook.data
{

	/**
	 * @author Manu Bonnet
	 * @project TEST_fbconnect
	 * @date 25 mai 10
	 */
	 
	public class FBDataInterest extends FBAbstractData
	{
		
		function FBDataInterest( pData : Object = null )
		{
			super( pData );
		}
		
		public function get name() : String { return objData.name; };
		public function get link() : String { return objData.link; };
		public function get numFans() : int { return objData.fan_count; };
		public function get category() : String { return objData.category; };
		
		/**
		*
		*/
		public override function toString() : String
		{
			return  '[FBDataLike id="'+id+'" name="'+name+'"]';
		}
	
	}
	
}