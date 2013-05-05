/**
 * This class defines all utility functions for textfield.
 * 
 * @author	sm.flashteam@gmail.com
 * @version	1.0
 */
package com.sff.utils {
	import flash.events.FocusEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	public class TextFieldUtils {		
		private static var dicDefaultText	:Dictionary = new Dictionary();
		private static var dicTextType		:Dictionary = new Dictionary();
		
		public function TextFieldUtils() {
			// nothing to do here
		}
		
		//////////////////////////////////////////////////////////////////////////////
		//							DEFAULT TEXT HANDLERS							//
		//////////////////////////////////////////////////////////////////////////////
		/**
		 * Add default text for a textfield
		 * 
		 * @param	textfield		target textfield
		 * @param	defaultText		default text
		 * @param	setText			auto set default text for textfield or not 
		 */
		public static function addDefaultText(textfield:TextField, defaultText:String, setText:Boolean = true, isPassword:Boolean = false):void {
			// remove previous default text if any
			removeDefaultText(textfield);
			
			// store or replace defaultext
			dicDefaultText[textfield] = defaultText;
			dicTextType[textfield] = isPassword;
			
			// add event listener 
			textfield.addEventListener(FocusEvent.FOCUS_IN, onFocusInTextFieldHandler);
			textfield.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutTextFieldHandler);
			
			// set default text if needed
			if (setText) {
				textfield.text = defaultText;
				if (isPassword) {
					textfield.displayAsPassword = false;
				}
			}
		}
		
		/**
		 * Remove default text of textfield
		 * 
		 * @param	textfield	target textfield
		 */
		public static function removeDefaultText(textfield:TextField):void {
			if (!dicDefaultText[textfield]) {
				return;
			}
			
			textfield.removeEventListener(FocusEvent.FOCUS_IN, onFocusInTextFieldHandler);
			textfield.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOutTextFieldHandler);
			
			if (dicTextType[textfield]) {
				textfield.displayAsPassword = true;
			}
			
			delete dicDefaultText[textfield];
		}
		
		/**
		 * Check to see if a textfield has default text or not
		 * 
		 * @param	textfield	target textfield
		 * @return	true if it has default text 
		 */
		public static function hasDefaultText(textfield:TextField):Boolean {
			if (!dicDefaultText[textfield] || dicDefaultText[textfield] != textfield.text) {
				return false;
			}
			
			return true;
		}
		
		/**
		 * Set default text for a textfield
		 * 
		 * @param	textfield	target textfield
		 */
		public static function resetDefaultText(textfield:TextField):void {
			if (!dicDefaultText[textfield]) {
				return;
			}
			
			textfield.text = dicDefaultText[textfield];
			if (dicTextType[textfield]) {
				textfield.displayAsPassword = false;
			}
		}
		
		//////////////////////////////////////////////////////////////////////////////
		//							TEXTFIELD EVENT HANDLERS						//
		//////////////////////////////////////////////////////////////////////////////
		/**
		 * Event listener for textfield - Focus / gain focus
		 * 
		 * @param	evt
		 */
		private static function onFocusInTextFieldHandler(evt:FocusEvent):void {
			var textfield:TextField = evt.currentTarget as TextField;
			
			if (textfield.text == dicDefaultText[textfield]) {
				textfield.text = "";
				
				if (dicTextType[textfield]) {
					textfield.displayAsPassword = true;
				}
			}
		}
		
		/**
		 * Event listener for textfield - Blur / lost focus
		 * 
		 * @param	evt
		 */
		private static function onFocusOutTextFieldHandler(evt:FocusEvent):void {
			var textfield:TextField = evt.currentTarget as TextField;
			
			if (StringUtils.trim(textfield.text) == "") {
				textfield.text = dicDefaultText[textfield];
				if (dicTextType[textfield]) {
					textfield.displayAsPassword = false;
				}
			}
		}
		
		//////////////////////////////////////////////////////////////////////////////
		//							TEXTFIELD TRIM OUT								//
		//////////////////////////////////////////////////////////////////////////////
		/**
		 * Remove excessive characters depends on number of lines
		 * 
		 * @param	textfield		target textfield
		 * @param	maxLine			number of lines
		 * @param	appendText		text will append when some characters must be removed
		 * @param	cutAtSpace		remove last word as a whole or just a part of it
		 */
		public static function cutDownMultiLineText(textfield:TextField, maxLine:int, appendText:String = "...", cutAtSpace:Boolean = true):void {
			// validate
			if (textfield.numLines <= maxLine) {
				return;
			}
			
			// remove excessive characters
			var str:String = "";
			for (var i:int = 0; i < maxLine; i++) {
				str += textfield.getLineText(i);
			}
			
			str = str.replace(/\s*$/, "");
			textfield.text = str + appendText;
			
			// recheck
			if (textfield.numLines > maxLine) {
				if (cutAtSpace) {
					while (textfield.numLines > maxLine && str.indexOf(" ")) {
						str = str.substring(0, str.lastIndexOf(" "));
						textfield.text = str + appendText;
					}
				} else {
					textfield.text = str.substr(0, str.length - 1) + appendText;
				}
			}
		}
		
		/**
		 * Remove excessive characters depends on width of textfield
		 * 
		 * @param	textfield		Target textfield. This textfield must have appropriate autosize.
		 * @param	maxWidth		max width in pixel
		 * @param	appendText		text will append when some characters must be removed
		 * @param	cutAtSpace		remove last word as a whole or just a part of it
		 */
		public static function cutDownTextByWidth(textfield:TextField, maxWidth:Number, appendText:String = "...", cutAtSpace:Boolean = true):void {
			// validate
			if (textfield.textWidth <= maxWidth) {
				return;
			}

			// can we cut down at space ?
			cutAtSpace = cutAtSpace && (textfield.text.indexOf(" ") != -1);
			
			// start check
			textfield.appendText(appendText);
			
			while (textfield.textWidth > maxWidth) {
				if (cutAtSpace) {
					textfield.text = textfield.text.substr(0, textfield.text.lastIndexOf(" ", textfield.length - appendText.length)) + appendText;
				} else {
					textfield.text = textfield.text.substr(0, textfield.length - appendText.length - 1) + appendText;
				}
			}
		}
		
		/**
		 * Remove excessive characters depends on number of characters
		 * 
		 * @param	textfield		target textfield
		 * @param	maxChars		number of chars
		 * @param	appendText		text will append when some characters must be removed
		 * @param	cutAtSpace		remove last word as a whole or just a part of it
		 */
		public static function cutDownTextByLength(textfield:TextField, maxChars:int, appendText:String = "...", cutAtSpace:Boolean = true):void {
			// validate
			if (textfield.length <= maxChars || maxChars < appendText.length) {
				return;
			}
			
			if (!cutAtSpace) {
				textfield.text = textfield.text.substr(0, maxChars - appendText.length) + appendText;
			} else {
				if (textfield.text.charAt(maxChars - appendText.length) == " ") {
					textfield.text = textfield.text.substr(0, maxChars - appendText.length) + appendText;
				} else {
					textfield.text = textfield.text.substr(0, maxChars - appendText.length);
					if (textfield.text.indexOf(" ") != -1) {
						textfield.text = textfield.text.substr(0, textfield.text.lastIndexOf(" ")) + appendText;
					}
				}
			}
		}
		
		//////////////////////////////////////////////////////////////////////////////
		//								OTHERS										//
		//////////////////////////////////////////////////////////////////////////////
		public static function applySubAndSupperScriptText(htmltext:String):String {
			var supStartExpression:RegExp = new RegExp("<sup>", "g")
			var supEndExpression:RegExp = new RegExp("</sup>", "g")
			var subStartExpression:RegExp = new RegExp("<sub>", "g")
			var subEndExpression:RegExp = new RegExp("</sub>", "g")

			htmltext = htmltext.replace(supStartExpression, "<font face=\"GG Superscript\">");
			htmltext = htmltext.replace(supEndExpression, "</font>")
			htmltext = htmltext.replace(subStartExpression, "<font face=\"GG Subscript\">");
			htmltext = htmltext.replace(subEndExpression, "</font>");

			return htmltext;
		}
		
		public static function changeSelectedTextColor(textfield:TextField):void {
			
		}
	}
}