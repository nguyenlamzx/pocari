package com.sff.facebook.data {
	
	/**
	 * ...
	 * @author lam.nv@sutrixmedia.com
	 */
	public class FBDataFriendlists extends FBAbstractData {
		
		public function FBDataFriendlists(pData:Object = null) {
			super(pData);
		}
		
		public function get name():String {
			return objData.name;
		}
		
	}

}