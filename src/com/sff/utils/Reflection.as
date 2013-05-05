package com.sff.utils {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Nguyen Van Lam
	 */
	public class Reflection {
		public static const HORIZONTAL 	:String = "horizontal";
		public static const VERTICAL 	:String = "vertical";
		
		private var target		:Sprite;
		private var mask		:Sprite;
		private var image		:Bitmap;
		private var maskPercent	:Number;
		
		public function Reflection(object:Sprite, maskPercent:Number = 0.4) {
			this.target = object;
			this.maskPercent = maskPercent;
			
			// Create image of reflection
			addImage();
			
			// Create mask for reflection
			addMask();
			
			image.mask = mask;
		}
		
		public static function create(object:Sprite):void {
			new Reflection(object);
		}
		
		private function addImage():void {
			image = new Bitmap(Bitmap(target.getChildAt(0)).bitmapData);
			image.cacheAsBitmap = true;
			image.smoothing = true;
			image.alpha = 0.8;
			flip(Reflection.VERTICAL);
			
			target.addChild(image);
			
			image.x = OriginalImage.x;
			image.y = -OriginalImage.y + OriginalImage.height;
		}
		
		private function addMask():void {
			var gra:Graphics;
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(100, 100, 3 * Math.PI / 2, 0, 0);
			
			mask = new Sprite();
			mask.name = "mask";
			gra = mask.graphics;
			gra.beginGradientFill(GradientType.LINEAR, [0xFF0000,0x0000FF], [0,1], [0,255], matrix);
			gra.drawRect(0, 0, 100, 100);
			gra.endFill();
			
			mask.cacheAsBitmap = true;
			mask.width = image.width;
			mask.height = image.height;
			
			target.addChild(mask);
			
			mask.x = image.x;
			mask.y = (maskPercent) * image.height - image.y / 3 ;
		}
		
		private function get OriginalImage():Bitmap {
			return target.getChildAt(0) as Bitmap;
		}
		
		public function remove():void {
			while (target.numChildren > 1) {
				target.removeChildAt(1);
			}
		}
		
		public function flip(direct:String = Reflection.VERTICAL):void {
			if (direct == Reflection.VERTICAL) {
				image.scaleY = -1;
			} else {
				image.scaleX = -1;
			}
		}
	}
}