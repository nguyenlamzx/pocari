package com.sff.utils {
	
	import flash.display.Shape;
	
	public class DrawPieChart {
		
		public function DrawPieChart() { }
		
		public static var CONVERT_TO_RADIANS:Number = Math.PI / 180;
		
		public static function drawChart(shape:Shape, radius:Number, percent:Number, colour:uint = 0xFF0000, rotationOffset:Number = 0) {
			if (percent > 1) {
				percent = 1;
			}
			var angle:Number = 360 * percent;
			
			shape.graphics.clear();
			shape.graphics.lineStyle(0);
			shape.graphics.moveTo(0,0);
			shape.graphics.beginFill(colour,100);
			shape.graphics.lineTo(radius, 0);
			shape.rotation = rotationOffset;
			
			var nSeg:Number = Math.floor (angle/30);
			var pSeg:Number = angle - nSeg * 30;
			var a:Number = 0.268;
			
			for (var i = 0; i < nSeg; i++) {
				var endx:Number = radius * Math.cos ((i + 1)* 30* CONVERT_TO_RADIANS);
				var endy:Number = radius * Math.sin ((i + 1) * 30* CONVERT_TO_RADIANS);
				var ax:Number = endx + radius * a * Math.cos (((i + 1)* 30  - 90) * CONVERT_TO_RADIANS);
				var ay:Number = endy + radius * a * Math.sin (((i + 1)* 30  - 90) * CONVERT_TO_RADIANS);
				shape.graphics.curveTo (ax,ay,endx,endy);
			}
			
			if (pSeg > 0) {
				a = Math.tan (pSeg / 2 * CONVERT_TO_RADIANS);
				endx = radius * Math.cos ((i* 30 + pSeg) * CONVERT_TO_RADIANS);
				endy = radius * Math.sin ((i * 30 + pSeg) * CONVERT_TO_RADIANS);
				ax = endx + radius * a * Math.cos ((i* 30+ pSeg - 90) * CONVERT_TO_RADIANS);
				ay = endy + radius * a * Math.sin ((i* 30+ pSeg - 90) * CONVERT_TO_RADIANS);
				shape.graphics.curveTo (ax,ay,endx,endy);
			}
		}	
	}
}