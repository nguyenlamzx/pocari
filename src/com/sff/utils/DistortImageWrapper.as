/**
 * This class wraps distort image class.
 * It supports progressive update distort image - used to apply distort technique on movie
 * 
 * @author	sm.flashteam@gmail.com
 */
package com.sff.utils {
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Point;
	import org.flashsandy.display.DistortImage;
	
	// TODO: suport movieclip
	public class DistortImageWrapper extends DistortImage {
		// store corresponding information
		private var graphics		:Graphics;
		private var bmd				:BitmapData;
		
		/**
		 * Constructor
		 * 
		 * @param	w		Width of the image to be processed
		 * @param	h		Height of image to be processed
		 * @param	hseg	Horizontal precision
		 * @param	vseg	Vertical precision
		 * 
		 */
		public function DistortImageWrapper(w:Number,
										h:Number,
										hseg:uint=2,
										vseg:uint=2):void {
			super(w, h, hseg, vseg);
		}
		
		/**
		 * Distorts the provided BitmapData according to the provided Point instances and draws it onto the provided Graphics.
		 * 
		 * @param	graphics	Graphics on which to draw the distorted BitmapData
		 * @param	bmd			The undistorted BitmapData
		 * @param	tl			Point specifying the coordinates of the top-left corner of the distortion
		 * @param	tr			Point specifying the coordinates of the top-right corner of the distortion
		 * @param	br			Point specifying the coordinates of the bottom-right corner of the distortion
		 * @param	bl			Point specifying the coordinates of the bottom-left corner of the distortion
		 * 
		 */
		override public function setTransform(graphics:Graphics,
										bmd:BitmapData, 
										tl:Point, 
										tr:Point, 
										br:Point, 
										bl:Point):void {
											
			this.graphics = graphics;
			this.bmd = bmd;
			
			super.setTransform(graphics, bmd, tl, tr, br, bl);
		}
		
		/**
		 * Update image
		 */
		public function update():void {
			this.graphics.clear();
			__render(this.graphics, this.bmd);
		}
	}	
}