/**
 * Defines types and rules for validating a form item. Each item corresponds to a field / object on stage.
 * In this version, only text field can be validate by this class. For other objects (MovieClip, Sprite,...), 
 * you should use TYPE_CUSTOM for validate type, and validate this field by yourself.
 * 
 * @author	sm.flashteam@gmail.com
 * @version	1.0
 */
package com.sff.form {
	import com.sff.sff.utils.StringUtils;
	import com.sff.sff.utils.TextFieldUtils;
	import flash.display.InteractiveObject;
	import flash.text.TextField;
	
	public class FormItem {		
		public static const TYPE_REQUIRED	:int = 1;		// required or not
		public static const TYPE_EMAIL		:int = 2;		
		public static const TYPE_POSTCODE	:int = 4;		// auto restrict the accepted characters
		public static const TYPE_PASSWORD	:int = 8;
		public static const TYPE_CUSTOM		:int = 16;		// you will handle this item by yourself.
		public static const TYPE_PHONE		:int = 32;		// auto restrict the accepted characters
		public static const TYPE_DOMAIN		:int = 64;
		
		public static const TYPE_MIN_VALUE	:int = 128;		// entered value must larger than or equal this one
		public static const TYPE_MAX_VALUE	:int = 256;		// entered value must smaller than or equal this one
		public static const TYPE_MIN_LENGTH	:int = 512;		// minimum length
		public static const TYPE_MAX_LENGTH	:int = 1024;	// auto restrict maximum characters
		
		private var field					:Object;
		private var type					:int;
		private var errorMessage			:String;
		private var defaultValue			:Object;
		
		private var minValue				:Object;
		private var maxValue				:Object;
		private var minLength				:uint;
		private var maxLength				:uint;
		
		/**
		 * Create new item for form
		 * 
		 * @param	field			Target field
		 * @param	type			Validating rule. You can apply several rules on a field. Ex: TYPE_REQUIRED | TYPE_EMAIL
		 * @param	errorMessage	Error message if the field is not valid. If you have a message for each error, please 
		 * 							create several FormItem which each one corresponds to an error.
		 * @param	defaultValue	You can set default text for textfield here. This can work with password.
		 * @param	minValue		Minimum value
		 * @param	maxValue		Maximum value
		 * @param	minLength		Minimum length
		 * @param	maxLength		Maximum length
		 */
		public function FormItem(field:Object, type:uint, errorMessage:String = null, defaultValue:Object = null, minValue:Object = null, maxValue:Object = null, minLength:uint = 0, maxLength:uint = 0) {
			if (minValue !== null) {
				type |= TYPE_MIN_VALUE;
			}
			
			if (maxValue !== null) {
				type |= TYPE_MAX_VALUE;
			}
			
			if (minLength > 0) {
				type |= TYPE_MIN_LENGTH;
			}
			
			if (maxLength > 0) {
				type |= TYPE_MAX_LENGTH;
			}
			
			this.field 			= field;
			this.type 			= type;
			this.errorMessage 	= errorMessage;
			this.defaultValue 	= defaultValue;
			
			this.minValue		= minValue;
			this.maxValue		= maxValue;
			this.minLength		= minLength;
			this.maxLength		= maxLength;
		}
		
		/**
		 * Get corresponding field
		 */
		public function get Field():Object {
			return field;
		}
		
		/**
		 * Get error message
		 */
		public function get ErrorMessage():String {
			return errorMessage;
		}
		
		/**
		 * Init this item. Re-order corresponding field.
		 * 
		 * @param	tabIndex	tabIndex for field
		 */
		internal function init(tabIndex:int = 0):void {
			if (field is TextField) {
				TextField(field).scrollH = 0;
				TextField(field).scrollV = 0;
				
				if (defaultValue) {
					TextFieldUtils.addDefaultText(field as TextField, defaultValue.toString(), true, (type & TYPE_PASSWORD) != 0);
				}
				
				if (type & TYPE_POSTCODE) {
					TextField(field).restrict = "0-9";
				}
				
				if (type & TYPE_PHONE) {
					TextField(field).restrict = "0-9 ()\\-";
				}
				
				if (type & TYPE_MAX_LENGTH) {
					TextField(field).maxChars = maxLength;
				}
			}
			
			if (field is InteractiveObject) {
				InteractiveObject(field).tabEnabled = true;
				InteractiveObject(field).tabIndex = tabIndex;
			}
		}
		
		/**
		 * Reset field
		 */
		internal function reset():void {
			if (field is TextField) {
				if (defaultValue) {
					TextFieldUtils.resetDefaultText(field as TextField);
				} else {
					field.text = ""
				}
				
				TextField(field).scrollH = 0;
				TextField(field).scrollV = 0;
			}
		}
		
		/**
		 * Release memory
		 */
		internal function dispose():void {
			if (field is TextField && defaultValue) {
				TextFieldUtils.removeDefaultText(field as TextField);
			}
		}
		
		/**
		 * Determine this field requires a custom validate or not
		 */
		internal function get IsCustom():Boolean {
			if (type & TYPE_CUSTOM) {
				return true;
			}
			
			return false;
		}
		
		/**
		 * Validate field
		 */
		internal function get IsValid():Boolean {
			if (field is TextField) {
				if (type & TYPE_REQUIRED) {
					if (StringUtils.isEmpty(field.text) || TextFieldUtils.hasDefaultText(field as TextField)) {
						return false;
					}
				} else if (field.text == "") {
					return true;
				}
				
				if ((type & TYPE_EMAIL) && !StringUtils.isValidEmail(field.text)) {
					return false;
				}
				
				if ((type & TYPE_POSTCODE) && !StringUtils.isValidPostCode(field.text)) {
					return false;
				}
				
				if ((type & TYPE_DOMAIN) && !StringUtils.isValidDomain(field.text)) {
					return false;
				}
				
				if ((type & TYPE_MIN_VALUE) && parseFloat(field.text) < minValue) {
					return false;
				}
				
				if ((type & TYPE_MAX_VALUE) && parseFloat(field.text) > maxValue) {
					return false;
				}
				
				if ((type & TYPE_MIN_LENGTH) && field.length < minLength) {
					return false;
				}
			}
			
			return true;
		}
	}
}