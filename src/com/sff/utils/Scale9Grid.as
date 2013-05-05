/**
 * Due to the limitation of scale9Grid of Flash (only apply on vector),
 * this class add scale9Grid feature for all display object, include MovieClip.
 * 
 * @author	sm.flashteam@gmail.com	
 * @version	1.0
 */
package com.sff.utils {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	// TODO: support normal behaviour for scale
	
	public class Scale9Grid extends Sprite {
		private var displayObject		:DisplayObject;
		private var bmd					:BitmapData;
		private var matrix				:Matrix;
		
		private var rectLeft			:Number;
		private var rectTop				:Number;
		private var rectWidth			:Number;
		private var rectHeight			:Number;
		
		private var remainWidth			:Number;
		private var remainHeight		:Number;
		
		private var scaleRect			:Rectangle;
		private var xScale				:Number = 1;
		private var yScale				:Number = 1;
		private var lastFrame			:int = 0;
		
		/**
		 * Add scale9Grid feature for a displayObject
		 * 
		 * @param	displayObject	Target object
		 * @param	addIntoStage	Auto replace the target object or not
		 */
		public function Scale9Grid(displayObject:DisplayObject, addIntoStage:Boolean = false) {
			// init variables
			this.displayObject = displayObject;

			matrix = new Matrix();
			bmd = new BitmapData(displayObject.width, displayObject.height, true, 0x00000000);
			bmd.draw(displayObject, null, null, null, null, true);
			
			// replace target object if needed
			if (addIntoStage && displayObject.parent) {
				this.x = displayObject.x;
				this.y = displayObject.y;
				
				displayObject.parent.addChildAt(this, displayObject.parent.getChildIndex(displayObject));
				displayObject.parent.removeChild(displayObject);
			}

			scaleX = displayObject.scaleX;
			scaleY = displayObject.scaleY;
			
			// init all parameters
			updateParams();			
		}
		
		//////////////////////////////////////////////////////////////////////////////
		//							PROPERTY HANDLERS								//
		//////////////////////////////////////////////////////////////////////////////
		/**
		 * Getter for scale9Grid
		 */
		override public function get scale9Grid():Rectangle {
			return scaleRect.clone();
		}
		
		/**
		 * Setter for scale9Grid
		 * 
		 * @throws	ArgumentError	Rectangle is not valid
		 */
		override public function set scale9Grid(value:Rectangle):void {
			// validate parameter
			if (value.left < 0 || value.width + value.left > bmd.width || 
				value.top < 0 || value.top + value.height > bmd.height || 
				value.height <= 0 || value.width <= 0) {
				
				throw new ArgumentError("Rectangle is not valid");
			}
			
			// store and update parameters
			scaleRect = value.clone();			
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
			if (scaleRect) {					
				return (bmd.width - (1 - xScale) * scaleRect.width);
			} else {
				return (xScale * bmd.width);
			}
		}
		
		override public function set width(value:Number):void {
			if (value > 0) {
				if (scaleRect) {
					var temp:Number = bmd.width - scaleRect.width
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
			if (scaleRect) {
				return (bmd.height - (1 - yScale) * scaleRect.height);
			} else {
				return (yScale * bmd.height);
			}
		}
		
		override public function set height(value:Number):void {
			if (value > 0) {
				if (scaleRect) {
					var temp:Number = bmd.height - scaleRect.height;
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
				if (!MovieClip(displayObject).hasEventListener(Event.ENTER_FRAME)) {
					MovieClip(displayObject).addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
				}
				
				MovieClip(displayObject).play();
			}
		}
		
		/**
		 * Stop movieclip
		 */
		public function stop():void {
			if (totalFrames > 1) {
				MovieClip(displayObject).stop();
			}
		}
		
		/**
		 * Goto a specific frame and play
		 */
		public function gotoAndPlay(frame:Object, scene:String = null):void {
			if (totalFrames > 1) {
				if (!MovieClip(displayObject).hasEventListener(Event.ENTER_FRAME)) {
					MovieClip(displayObject).addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
				}
				
				MovieClip(displayObject).gotoAndPlay(frame, scene);
			}
		}
		
		/**
		 * Goto a specific frame and stop
		 */
		public function gotoAndStop(frame:Object, scene:String = null):void {
			if (totalFrames > 1) {
				if (!MovieClip(displayObject).hasEventListener(Event.ENTER_FRAME)) {
					MovieClip(displayObject).addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
				}
				MovieClip(displayObject).gotoAndStop(frame, scene);
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
			if (scaleRect) {
				rectLeft = scaleRect.left;
				rectTop = scaleRect.top;
				rectWidth = scaleRect.width * xScale;
				rectHeight = scaleRect.height * yScale;
				
				remainWidth = bmd.width - (rectLeft + scaleRect.width);
				remainHeight = bmd.height - (rectTop + scaleRect.height);
			}
			
			updateContent();
		}
		
		/**
		 * Redraw whole object
		 */
		private function updateContent():void {
			graphics.clear();
			if (displayObject is MovieClip && lastFrame != currentFrame) {
				bmd.dispose();
				bmd = new BitmapData(displayObject.width, displayObject.height, true, 0x00000000);
				bmd.draw(displayObject, null, null, null, null, true);
			}
			
			// if user do not specify scale9Grid, draw entire bitmap data
			if (!scaleRect) {
				graphics.beginBitmapFill(bmd);
				graphics.moveTo(0,0);
				graphics.lineTo(0, bmd.height);
				graphics.lineTo(bmd.width, bmd.height);
				graphics.lineTo(bmd.width,0);
				graphics.endFill();
				return;
			}
			
			// first column - top conner
			graphics.beginBitmapFill(bmd);
			graphics.moveTo(0,0);
			graphics.lineTo(0,rectTop);
			graphics.lineTo(rectLeft,rectTop);
			graphics.lineTo(rectLeft,0);
			
			//
			// first column - middle
			matrix.identity();
			matrix.scale(1, yScale);
			matrix.translate(0, rectTop * (1 - yScale));			
			
			graphics.beginBitmapFill(bmd, matrix);
			graphics.moveTo(0,rectTop);
			graphics.lineTo(0,rectTop + rectHeight);
			graphics.lineTo(rectLeft,rectTop + rectHeight);
			graphics.lineTo(rectLeft, rectTop);

			// first column - bottom conner
			matrix.identity();
			matrix.translate(0, rectHeight - scaleRect.height);
			
			graphics.beginBitmapFill(bmd, matrix);
			graphics.moveTo(0,rectTop + rectHeight);
			graphics.lineTo(0,rectTop + rectHeight + remainHeight);
			graphics.lineTo(rectLeft,rectTop + rectHeight + remainHeight);
			graphics.lineTo(rectLeft, rectTop + rectHeight);
			
			// second column - top
			matrix.identity();
			matrix.scale(xScale, 1);
			matrix.translate(rectLeft * (1 - xScale), 0);
			
			graphics.beginBitmapFill(bmd, matrix);
			graphics.moveTo(rectLeft,0);
			graphics.lineTo(rectLeft,rectTop);
			graphics.lineTo(rectLeft + rectWidth, rectTop);
			graphics.lineTo(rectLeft + rectWidth, 0);

			// second column - middle
			matrix.identity();
			matrix.scale(xScale, yScale);
			matrix.translate(rectLeft * (1 - xScale), rectTop * (1 - yScale));
			
			graphics.beginBitmapFill(bmd, matrix);
			graphics.moveTo(rectLeft,rectTop);
			graphics.lineTo(rectLeft,rectTop + rectHeight);
			graphics.lineTo(rectLeft + rectWidth, rectTop + rectHeight);
			graphics.lineTo(rectLeft + rectWidth, rectTop);
			
			// second column - bottom
			matrix.identity();
			matrix.scale(xScale, 1);
			matrix.translate(rectLeft * (1 - xScale), rectHeight - scaleRect.height);
			
			graphics.beginBitmapFill(bmd, matrix);
			graphics.moveTo(rectLeft, rectTop + rectHeight);
			graphics.lineTo(rectLeft, rectTop + rectHeight + remainHeight);
			graphics.lineTo(rectLeft + rectWidth, rectTop + rectHeight + remainHeight);
			graphics.lineTo(rectLeft + rectWidth, rectTop + rectHeight);
			
			// third column - top
			matrix.identity();
			matrix.translate(rectWidth - scaleRect.width, 0);
			
			graphics.beginBitmapFill(bmd, matrix);
			graphics.moveTo(rectLeft + rectWidth ,0);
			graphics.lineTo(rectLeft + rectWidth, rectTop);
			graphics.lineTo(rectLeft + rectWidth + remainWidth, rectTop);
			graphics.lineTo(rectLeft + rectWidth + remainWidth, 0);
			
			// third column - middle
			matrix.identity();
			matrix.scale(1,yScale);
			matrix.translate(rectWidth - scaleRect.width, rectTop * (1 - yScale));
			
			graphics.beginBitmapFill(bmd, matrix);
			graphics.moveTo(rectLeft + rectWidth ,rectTop);
			graphics.lineTo(rectLeft + rectWidth, rectTop + rectHeight);
			graphics.lineTo(rectLeft + rectWidth + remainWidth, rectTop + rectHeight);
			graphics.lineTo(rectLeft + rectWidth + remainWidth, rectTop);

			// third column - bottom
			matrix.identity();
			matrix.translate(rectWidth - scaleRect.width, rectHeight - scaleRect.height);
			
			graphics.beginBitmapFill(bmd, matrix);
			graphics.moveTo(rectLeft + rectWidth,rectTop + rectHeight);
			graphics.lineTo(rectLeft + rectWidth, rectTop + rectHeight + remainHeight);
			graphics.lineTo(rectLeft + rectWidth + remainWidth, rectTop + rectHeight + remainHeight);
			graphics.lineTo(rectLeft + rectWidth + remainWidth, rectTop + rectHeight);
			graphics.endFill();
		}
	}
}