package com.pocari.view.base 
{
	
	public interface IView 
	{
		function init(data:Object = null):void;
		
		function show(delay:Number = 0):Number;
		function hide(delay:Number = 0):Number;
		
		function dispose():void;
	}
	
}