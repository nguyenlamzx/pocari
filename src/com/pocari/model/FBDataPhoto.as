package com.pocari.model 
{
	import com.sff.facebook.data.FBAbstractData;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class FBDataPhoto extends FBAbstractData 
	{
		
		public function FBDataPhoto(pData:Object = null) {
			super(pData);
			
			objData.bitmapData = new BitmapData(136, 87);
		}
		
		public function get picture():String {
			return objData.picture;
		}
		
		public function get source():String {
			return objData.source;
		}
		
		public function get bitmapData():BitmapData {
			return objData.bitmapData;
		}
		
		public function set bitmapData(value:BitmapData):void {
			BitmapData(objData.bitmapData).setPixels(value.rect, value.getPixels(value.rect));
		}
	}

}