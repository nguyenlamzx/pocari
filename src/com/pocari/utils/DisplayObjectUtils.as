package com.pocari.utils 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author ...
	 */
	public class DisplayObjectUtils 
	{
		public static function resize(object:Object, desiredWidth:Number, desiredHeight:Number, fit:Boolean = true):void {
			object.width = desiredWidth;
			object.scaleY = object.scaleX;
			
			if (fit) 
			{
				if (object.height > desiredHeight) {
					object.height = desiredHeight
					object.scaleX = object.scaleY;
				}
			}
			else 
			{
				if (object.height < desiredHeight) {
					object.height = desiredHeight
					object.scaleX = object.scaleY;
				}
			}
			
			if (object.scaleX > 1) {
				object.scaleX = object.scaleY = 1;
			}
		}
		
		public static function alignCenter(object:Object, boundary:Rectangle):void {
			trace(boundary);
			object.x = boundary.x + boundary.width / 2 - object.width / 2;
			object.y = boundary.y + boundary.height / 2 - object.height / 2;
			trace(object.x, object.y);
		}
		
		public static function drawBitmap(bmp:Bitmap, masker:MovieClip):void {
			var bitmap:Bitmap;
			var bmpData:BitmapData;
			
			//draw
			var bounds:Rectangle = masker.getBounds(bmp);
			bmp.mask = masker;
			bmpData = new BitmapData( int( bounds.width + 0.5 ), int( bounds.height + 0.5 ), true, 0 );
			bmpData.draw( bmp, new Matrix(1,0,0,1,-bounds.x,-bounds.y) );
		
			bitmap = new Bitmap(bmpData, "auto", true);
			masker.x = bitmap.x;
			masker.y = bitmap.y;
			
			
			//Model.instance.currentFace = bitmap;
		}
		
	}

}