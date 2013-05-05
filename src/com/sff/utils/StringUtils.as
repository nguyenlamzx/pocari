/**
 * This class contains utility functions for string
 *
 * @author	sm.flashteam@gmail.com
 * @version	1.0
 */
package com.sff.utils {	
	public class StringUtils {
		
		public function StringUtils() {
			// nothing to do here
		}
		
		/**
		 * Removes whitespace from the front and the end of the specified string.
		 *
		 * @param	input	The String whose beginning and ending whitespace will will be removed.
		 * @return			A String with whitespace removed from the begining and end
		 *
		 */
		public static function trim(input:String):String {
			return leftTrim(rightTrim(input));
		}

		/**
		 * Removes whitespace from the front of the specified string.
		 *
		 * @param	input	The String whose beginning whitespace will will be removed.
		 * @return			A String with whitespace removed from the begining
		 */
		public static function leftTrim(input:String):String {
			return input.replace(/^\s*/, "");
		}

		/**
		 * Removes whitespace from the end of the specified string.
		 *
		 * @param	input	The String whose ending whitespace will will be removed.
		 * @return			A String with whitespace removed from the end
		 */
		public static function rightTrim(input:String):String {
			return input.replace(/\s*$/, "");
		}
		
		/**
		 * Validates the passed-in {@code email} adress to a predefined email pattern.
		 *
		 * @param email 	The email to check whether it is well-formatted
		 * @return 			{@code true} if the email matches the email pattern else {@code false}
		 */
		public static function isValidEmail(email:String):Boolean {
			return (/^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$/.test(email));
		}
		
		/**
		 * Checks a string if it contains nothing or only space characters
		 * 
		 * @param	str		Input string
		 * @return			{@code true} if it is empty
		 */
		public static function isEmpty(str:String):Boolean {
			return (trim(str) == "");
		}
		
		/**
		 * Validates the passed-in {@code postcode} value to a predefined postcode pattern.
		 * Please be careful when using this function. This function check if the postcode has 3 to 5 digits.
		 * Depend on each country, the postcode may difference.
		 * 
		 * @param	postcode	Postcode value
		 * @return				{@code true} if it is a valid postcode
		 */
		public static function isValidPostCode(postcode:String, minChars:int = 3, maxChars:int = 5):Boolean {
			var reg:RegExp = new RegExp("^\\d{" + minChars + "," + maxChars + "}$");
			return (reg.test(postcode));
		}
		
		/**
		 * Validates a domain string
		 * 
		 * @param	str		Input domain
		 * @return			{@code true} if it is a valid domain
		 */
		public static function isValidDomain(str:String):Boolean {
			return (/^http:\/\/([a-z0-9_\-]+\.)+[a-z]{2,3}$/ig.test(str));
		}
		
		/**
		 * Convert a string to a HEXA string that contains hexa code of all characters of original string.
		 * 
		 * @param	str		Input string
		 * @return			String contains hexa code of all characters of input string
		 */
		public static function bin2hex(str:String):String {
			var result:String = "";
			for (var i:int = 0; i < str.length; i++) {
				result += str.charCodeAt(i).toString(16);
			}
			
			return result;
		}
		
		/**
		 * Remove excessive characters depends on number of characters
		 * 
		 * @param	text			source text
		 * @param	maxChars		number of chars
		 * @param	appendText		text will append when some characters must be removed
		 * @param	cutAtSpace		remove last word as a whole or just a part of it
		 */
		public static function cutDownTextByLength(text:String, maxChars:int, appendText:String = "...", cutAtSpace:Boolean = true):String {
			// validate
			if (text.length <= maxChars || maxChars < appendText.length) {
				return text;
			}
			
			if (!cutAtSpace) {
				text = text.substr(0, maxChars - appendText.length) + appendText;
			} else {
				if (text.charAt(maxChars - appendText.length) == " ") {
					text = text.substr(0, maxChars - appendText.length) + appendText;
				} else {
					text = text.substr(0, maxChars - appendText.length);
					if (text.indexOf(" ") != -1) {
						text = text.substr(0, text.lastIndexOf(" ")) + appendText;
					}
				}
			}
			
			return text;
		}
	}
}