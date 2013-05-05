/**
 * Add tile feature for DisplayObject
 * 
 * @author	sm.flashteam@gmail.com	
 * @version	1.0
 */
package com.sff.utils {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	// TODO: support normal behaviour for scale
	public class Tile9Grid extends Sprite {
		private var displayObject		:DisplayObject;
		private var bmd					:BitmapData;
		private var matrix				:Matrix;
		
		private var rectLeft			:Number;
		private var rectTop				:Number;
		private var rectWidth			:Number;
		private var rectHeight			:Number;
		
		private var remainWidth			:Number;
		private var remainHeight		:Number;
		
		private var tileRect			:Rectangle;
		private var xScale				:Number = 1;
		private var yScale				:Number = 1;
		private var lastFrame			:int = 0;
		
		/**
		 * Add scale9Grid feature for a displayObject
		 * 
		 * @param	displayObject	Target object
		 * @param	addIntoStage	Auto replace the target object or not
		 */
		public function Tile9Grid(displayObject:DisplayObject, addIntoStage:Boolean = false) {
			// init variables
			this.displayObject = displayObject;

			matrix = new Matrix();
			matrix.scale(displayObject.scaleX, displayObject.scaleY);
			bmd = new BitmapData(displayObject.width, displayObject.height, true, 0x00000000);
			bmd.draw(displayObject, matrix);
			
			// replace target object if needed
			if (addIntoStage && displayObject.parent) {
				this.x = displayObject.x;
				this.y = displayObject.y;
				
				displayObject.parent.addChildAt(this, displayObject.parent.getChildIndex(displayObject));
				displayObject.parent.removeChild(displayObject);
			}
			
			// init all parameters
			updateParams();			
		}
		
		//////////////////////////////////////////////////////////////////////////////
		//							PROPERTY HANDLERS								//
		//////////////////////////////////////////////////////////////////////////////
		/**
		 * Getter for tileRect
		 */
		public function get tile9Grid():Rectangle {
			return tileRect.clone();
		}
		
		/**
		 * Setter for tileRect
		 * 
		 * @throws	ArgumentError	Rectangle is not valid
		 */
		public function set tile9Grid(value:Rectangle):void {
			// validate parameter
			if (value.left < 0 || value.width + value.left > bmd.width || 
				value.top < 0 || value.top + value.height > bmd.height || 
				value.height <= 0 || value.width <= 0) {
				
				throw new ArgumentError("Rectangle is not valid");
			}
			
			// store and update parameters
			tileRect = value.clone();			
			updateParams();
		}

		/**
		 * Getter / setter for scaleX
		 */
		override public function get scaleX():Number {
			return xScale; 
		}
		
		override public function set scaleX(value:Number):void {
			// validate parameter and update
			if (value >= 0) {
				xScale = value;
				updateParams();
			}
		}
		
		/**
		 * Getter / setter for scaleY
		 */
		override public function get scaleY():Number {
			return yScale; 
		}
		
		override public function set scaleY(value:Number):void {
			// validate parameter and update
			if (value >= 0) {
				yScale = value;			
				updateParams();
			}
		}
		
		/**
		 * Getter / setter for width
		 */
		override public function get width():Number {
			if (tileRect) {					
				return (bmd.width - (1 - xScale) * tileRect.width);
			} else {
				return (xScale * bmd.width);
			}
		}
		
		override public function set width(value:Number):void {
			if (value > 0) {
				if (tileRect) {
					var temp:Number = bmd.width - tileRect.width
					if (value > temp) {
						xScale = (value - temp) / (bmd.width - temp);
					} else {
						xScale = 0;
					}
				} else {
					xScale = value / bmd.width;
				}
				
				updateParams();
			}
		}
		
		/**
		 * Getter / setter for height
		 */
		override public function get height():Number {
			if (tileRect) {
				return (bmd.height - (1 - yScale) * tileRect.height);
			} else {
				return (yScale * bmd.height);
			}
		}
		
		override public function set height(value:Number):void {
			if (value > 0) {
				if (tileRect) {
					var temp:Number = bmd.height - tileRect.height;
					if (value > temp) {
						yScale = (value - temp) / (bmd.height - temp);
					} else {
						yScale = 0;
					}
				} else {
					yScale = value / bmd.height;
				}
				
				updateParams();
			}
		}
		
		//////////////////////////////////////////////////////////////////////////////
		//						MOVIECLIP SUPPORT FUNCTION 							//
		//////////////////////////////////////////////////////////////////////////////
		/**
		 * Event listener for movieclip - EnterFrame
		 * 
		 * @param	evt
		 */
		private function onEnterFrameHandler(evt:Event):void {
			// remove event if
			if (currentFrame == lastFrame) {
				displayObject.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			} else {
				// redraw 
				updateContent();
				
				// store
				lastFrame = currentFrame;
			}
		}
		
		/**
		 * Play movieclip
		 */
		public function play():void {
			if (totalFrames > 1) {
				MovieClip(displayObject).play();
				MovieClip(displayObject).addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			}
		}
		
		/**
		 * Stop movieclip
		 */
		public function stop():void {
			if (totalFrames > 1) {
				MovieClip(displayObject).stop();
				MovieClip(displayObject).addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			}
		}
		
		/**
		 * Goto a specific frame and play
		 */
		public function gotoAndPlay(frame:Object, scene:String = null):void {
			if (totalFrames > 1) {
				MovieClip(displayObject).gotoAndPlay(frame, scene);
				MovieClip(displayObject).addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			}
		}
		
		/**
		 * Goto a specific frame and stop
		 */
		public function gotoAndStop(frame:Object, scene:String = null):void {
			if (totalFrames > 1) {
				MovieClip(displayObject).gotoAndStop(frame, scene);
				MovieClip(displayObject).removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			}
		}
		
		/**
		 * Get current frame of movieclip
		 */
		public function get currentFrame():int {
			if (displayObject is MovieClip) {
				return MovieClip(displayObject).currentFrame;
			}
			
			return 1;
		}
		
		/**
		 * Get total frame of movieclip
		 */
		public function get totalFrames():int {
			if (displayObject is MovieClip) {
				return MovieClip(displayObject).totalFrames;
			}
			
			return 1;
		}
		
		//////////////////////////////////////////////////////////////////////////////
		//								MAIN FUNCTION 								//
		//////////////////////////////////////////////////////////////////////////////
		/**
		 * Init parameters that are used for draw 9 parts of object
		 */
		private function updateParams():void {
			if (tileRect) {
				rectLeft = tileRect.left;
				rectTop = tileRect.top;
				rectWidth = tileRect.width * xScale;
				rectHeight = tileRect.height * yScale;
				
				remainWidth = bmd.width - (rectLeft + tileRect.width);
				remainHeight = bmd.height - (rectTop + tileRect.height);
			}
			
			updateContent();
		}
		
		/**
		 * Redraw whole object
		 */
		private function updateContent():void {
			graphics.clear();
			
			if (displayObject is MovieClip) {
				bmd.dispose();
				
				matrix.identity();
				matrix.scale(displayObject.scaleX, displayObject.scaleY);
				
				bmd = new BitmapData(displayObject.width, displayObject.height, true, 0x00000000);
				bmd.draw(displayObject, matrix);
			}
			
			// if user do not specify tileRect, draw entire bitmap data
			if (!tileRect) {
				graphics.beginBitmapFill(bmd);
				graphics.moveTo(0,0);
				graphics.lineTo(0, bmd.height);
				graphics.lineTo(bmd.width, bmd.height);
				graphics.lineTo(bmd.width,0);
				graphics.endFill();
				return;
			}
			
			var h:Number;
			var maxH:Number;
			
			var w:Number;
			var maxW:Number;
			
			var i:int;
			var j:int;
			
			var startX:Number;
			var startY:Number;
			
			// first column - top conner
			graphics.beginBitmapFill(bmd);
			graphics.moveTo(0,0);
			graphics.lineTo(0,rectTop);
			graphics.lineTo(rectLeft,rectTop);
			graphics.lineTo(rectLeft,0);
			
			// first column - middle
			h = tileRect.height;
			maxH = rectHeight;
			
			for (i = 0; maxH > 0; i++) {
				if (h > maxH) {
					h = maxH;
				}
				maxH -= h;
				
				startY = i * tileRect.height + rectTop;
				
				matrix.identity();
				matrix.translate(0, i * tileRect.height);
				
				graphics.beginBitmapFill(bmd, matrix);
				graphics.moveTo(0, startY);
				graphics.lineTo(0, startY + h);
				graphics.lineTo(rectLeft, startY + h);
				graphics.lineTo(rectLeft, startY);
			}
			
			// first column - bottom conner
			h = rectTop + rectHeight;
			
			matrix.identity();
			matrix.translate(0, rectHeight - tileRect.height);
			
			graphics.beginBitmapFill(bmd, matrix);
			graphics.moveTo(0, h);
			graphics.lineTo(0, h + remainHeight);
			graphics.lineTo(rectLeft, h + remainHeight);
			graphics.lineTo(rectLeft, h);
			
			// second column - top
			w = tileRect.width;
			maxW = rectWidth;
			
			for (j = 0; maxW > 0; j++) {
				if (w > maxW) {
					w = maxW;
				}
				maxW -= w;
				
				startX = j * tileRect.width + rectLeft;
				
				matrix.identity();
				matrix.translate(j * tileRect.width, 0);
				
				graphics.beginBitmapFill(bmd, matrix);
				graphics.moveTo(startX, 0);
				graphics.lineTo(startX, rectTop);
				graphics.lineTo(startX + w, rectTop);
				graphics.lineTo(startX + w, 0);
			}
			
			// second column - middle
			h = tileRect.height;
			maxH = rectHeight;
			
			for (i = 0; maxH > 0; i++) {
				if (h > maxH) {
					h = maxH;
				}
				maxH -= h;
				
				startY = i * tileRect.height + rectTop;
				
				w = tileRect.width;
				maxW = rectWidth;
				
				for (j = 0; maxW > 0; j++) {
					if (w > maxW) {
						w = maxW;
					}
					maxW -= w;
					
					startX = j * tileRect.width + rectLeft;
					
					matrix.identity();
					matrix.translate(j * tileRect.width, i * tileRect.height);
					
					graphics.beginBitmapFill(bmd, matrix);
					graphics.moveTo(startX, startY);
					graphics.lineTo(startX, startY + h);
					graphics.lineTo(startX + w, startY + h);
					graphics.lineTo(startX + w, startY);
				}
			}
			
			// second column - bottom
			w = tileRect.width;
			maxW = rectWidth;
			startY = rectTop + rectHeight;
			
			for (j = 0; maxW > 0; j++) {
				if (w > maxW) {
					w = maxW;
				}
				maxW -= w;
				
				startX = j * tileRect.width + rectLeft;
				
				matrix.identity();
				matrix.translate(j * tileRect.width, rectHeight - tileRect.height);
				
				graphics.beginBitmapFill(bmd, matrix);
				graphics.moveTo(startX, startY);
				graphics.lineTo(startX, startY + remainHeight);
				graphics.lineTo(startX + w, startY + remainHeight);
				graphics.lineTo(startX + w, startY);
			}
			
			// third column - top
			matrix.identity();
			matrix.translate(rectWidth - tileRect.width, 0);
			
			graphics.beginBitmapFill(bmd, matrix);
			graphics.moveTo(rectLeft + rectWidth ,0);
			graphics.lineTo(rectLeft + rectWidth, rectTop);
			graphics.lineTo(rectLeft + rectWidth + remainWidth, rectTop);
			graphics.lineTo(rectLeft + rectWidth + remainWidth, 0);
			
			// third column - middle
			h = tileRect.height;
			maxH = rectHeight;
			startX = rectLeft + rectWidth;
			
			for (i = 0; maxH > 0; i++) {
				if (h > maxH) {
					h = maxH;
				}
				maxH -= h;
				
				startY = i * tileRect.height + rectTop;
				
				matrix.identity();
				matrix.translate(rectWidth - tileRect.width, i * tileRect.height);
				
				graphics.beginBitmapFill(bmd, matrix);
				graphics.moveTo(startX, startY);
				graphics.lineTo(startX, startY + h);
				graphics.lineTo(startX + remainWidth, startY + h);
				graphics.lineTo(startX + remainWidth, startY);
			}
			
			// third column - bottom
			matrix.identity();
			matrix.translate(rectWidth - tileRect.width, rectHeight - tileRect.height);
			
			graphics.beginBitmapFill(bmd, matrix);
			graphics.moveTo(rectLeft + rectWidth,rectTop + rectHeight);
			graphics.lineTo(rectLeft + rectWidth, rectTop + rectHeight + remainHeight);
			graphics.lineTo(rectLeft + rectWidth + remainWidth, rectTop + rectHeight + remainHeight);
			graphics.lineTo(rectLeft + rectWidth + remainWidth, rectTop + rectHeight);
			
			graphics.endFill();
		}
	}
}