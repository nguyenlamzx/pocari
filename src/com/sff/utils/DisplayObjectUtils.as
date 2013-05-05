/**
 * This class defines all utility functions for DisplayObject.
 * 
 * @author	sm.flashteam@gmail.com
 * @version	1.0
 */
package com.sff.utils {
	import com.adobe.images.JPGEncoder;
	import com.adobe.images.PNGEncoder;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	
	public class DisplayObjectUtils {
		public function DisplayObjectUtils() {
			// nothing to do here
		}
		
		/**
		 * TODO: need test this function carefully
		 * 
		 * Duplicate a display object
		 * 
		 * @param	target		the display object to duplicate
		 * @return				a duplicate instance of target
		 */
		/*public static function duplicate(target:DisplayObject):DisplayObject {
			var targetClass:Class = Object(target).constructor;
			var duplicate:DisplayObject = new targetClass() as DisplayObject;
			
			// duplicate properties
			duplicate.transform = target.transform;
			duplicate.filters = target.filters;
			duplicate.cacheAsBitmap = target.cacheAsBitmap;
			duplicate.opaqueBackground = target.opaqueBackground;
			
			if (target.scale9Grid) {
				duplicate.scale9Grid = target.scale9Grid;
			}
		
			return duplicate;
		}*/
		
		/**
		 * Create a JPEG image
		 * 
		 * @param	target		object will be used to draw
		 * @param	width		width of image
		 * @param	height		height of image
		 * @return				Image data - can be upload to server by a Loader
		 */
		public static function createJPGImage(target:DisplayObject, width:Number = 0, height:Number = 0):ByteArray {
			if (width == 0) {
				width = target.width;
			}
			
			if (height == 0) {
				height = target.height;
			}
			
			var jpegEnc:JPGEncoder = new JPGEncoder(100);
			var bmp:BitmapData = new BitmapData(width, height);
			bmp.draw(target);
			
			return jpegEnc.encode(bmp);
		}
		
		/**
		 * Create a PNG image
		 * 
		 * @param	target		object will be used to draw
		 * @param	width		width of image
		 * @param	height		height of image
		 * @return				Image data - can be upload to server by a Loader
		 */
		public static function createPNGImage(target:DisplayObject, width:Number = 0, height:Number = 0):ByteArray {
			if (width == 0) {
				width = target.width;
			}
			
			if (height == 0) {
				height = target.height;
			}
			
			var bmp:BitmapData = new BitmapData(width, height, true);
			bmp.draw(target);
			
			return PNGEncoder.encode(bmp);
		}
		
		/**
		 * Resize a DisplayObject according to the maximum size
		 */
		private function resizeAccordingToMaxSize(target:DisplayObject, maxWidth:Number, maxHeight:Number, autoCenter:Boolean = false):void {
			if (target.width > maxWidth) {
				target.width = maxWidth;
				target.scaleY = target.scaleX;
			}
			
			if (target.height > maxHeight) {
				target.height = maxHeight;
				target.scaleX = target.scaleY;
			}
			
			if (autoCenter) {
				target.x = (maxWidth - target.width) / 2;
				target.y = (maxHeight - target.height) / 2;
			}
		}
		
		/**
		 * Resize a DisplayObject according to the maximum size
		 */
		private function resizeAccordingToMinSize(target:DisplayObject, maxWidth:Number, maxHeight:Number, autoCenter:Boolean = false):void {

		}
	}
}