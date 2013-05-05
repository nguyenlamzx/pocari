/**
 * This class handles a lot of work when you work with form.
 * It validates form item with validate type you defined.
 * It captures keyboard event to handle ENTER key.
 * 
 * @usage
 * 		FormHelper.init(this, form, [
 * 									new FormItem(txtEmail, FormItem.TYPE_REQUIRED | FormItem.TYPE_EMAIL, "Email is not valid")
 * 									], btnSubmit, onSubmitHandler, onErrorHandler, onCustomHandler);
 * 
 * @throws	ArgumentError
 * @author	sm.flashteam@gmail.com
 * @version	1.0
 */
package com.sff.form {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	public class FormHelper {
		private static var dictForms:Dictionary;
		
		public function FormHelper() {
			// nothing to do here
		}
		
		/**
		 * Initialize a form
		 * 
		 * @param	target			Object defines onError and onSubmit function
		 * @param	form			Form object
		 * @param	arrItems		An array of FormItem
		 * @param	submitButton	Button invoke submit action
		 * @param	onSubmit		Function will be called when form is valid.
		 * 							The signature of this function MUST be: <function name>():void
		 * 
		 * @param	onError			Function will be called when a form item is invalid.
		 * 							The signature of this function MUST be: <function name>(item:FormItem):void
		 * 
		 * @param	onCustom		If a form item needs a custom validate, this function will be called.
		 * 							The signature of this function MUST be: <function name>(item:FormItem):Boolean
		 * 							If this function return TRUE, it means the item is valid, otherwise it's invalid.
		 */
		public static function init(target:Object, form:DisplayObjectContainer, arrItems:Array, submitButton:InteractiveObject, onSubmit:Function, onError:Function, onCustom:Function = null):void {
			// validate parameters
			if (!target || !form || !arrItems || arrItems.length == 0 || !submitButton || onSubmit == null || onError == null) {
				throw ArgumentError("Invalid argument(s)");
			}
			
			// init for the first time
			if (!dictForms) {
				dictForms = new Dictionary();
			}
			
			// do not duplicate work
			if (dictForms[form]) {
				dispose(form);
			}
			
			// store
			dictForms[form] = {
				target:target,
				form:form, 
				arrItems:arrItems,
				submitButton:submitButton,
				onSubmit:onSubmit,
				onError:onError,
				onCustom:onCustom				
			};
			
			// validate and init form item
			for (var i:int = 0; i < arrItems.length; i++) {
				if (!(arrItems[i] is FormItem)) {
					throw ArgumentError("Invalid item");
				}
				
				arrItems[i].init(i);
			}
						
			if (submitButton is MovieClip) {
				MovieClip(submitButton).buttonMode = true;
				MovieClip(submitButton).mouseChildren = false;
			}
			
			if (submitButton) {
				submitButton.addEventListener(MouseEvent.CLICK, onClickSubmitButtonHandler);
			}
			
			// handle ENTER key
			form.addEventListener(KeyboardEvent.KEY_UP, onKeyUpFormHandler);
		}
		
		/**
		 * Reset all fields
		 * 
		 * @param	form	input form
		 */
		public static function reset(form:DisplayObjectContainer):void {
			if (!dictForms[form]) {
				return;
			}
			
			var obj:Object = dictForms[form];
			for (var i:int = 0; i < obj.arrItems.length; i++) {
				obj.arrItems[i].reset();
			}
		}
		
		/**
		 * Release memory
		 */
		public static function dispose(form:DisplayObjectContainer):void {
			if (!dictForms[form]) {
				return;
			}
			
			var obj:Object = dictForms[form];
			for (var i:int = 0; i < obj.arrItems.length; i++) {
				obj.arrItems[i].dispose();
			}
			
			if (obj.submitButton) {
				obj.submitButton.removeEventListener(MouseEvent.CLICK, onClickSubmitButtonHandler);
			}
			
			form.removeEventListener(KeyboardEvent.KEY_UP, onKeyUpFormHandler);			
			delete dictForms[form];
		}
		
		/**
		 * Handle ENTER key
		 * 
		 * @param	evt
		 */
		private static function onKeyUpFormHandler(evt:KeyboardEvent):void {
			if (evt.charCode != Keyboard.ENTER) {
				return;
			}
			
			if (evt.target as TextField && TextField(evt.target).multiline) {
				return;
			}
			
			checkForm(evt.currentTarget as DisplayObjectContainer);
		}
		
		/**
		 * Handle submit button
		 * 
		 * @param	evt
		 */
		private static function onClickSubmitButtonHandler(evt:MouseEvent):void {
			for (var i in dictForms) {
				if (dictForms[i].submitButton == evt.currentTarget) {
					checkForm(dictForms[i].form as DisplayObjectContainer);
					return;
				}
			}
		}
		
		/**
		 * Validate form
		 * 
		 * @param	form	input form
		 */
		private static function checkForm(form:DisplayObjectContainer):void {
			form.stage.focus = null;
			var obj:Object = dictForms[form];
			for (var i:int = 0; i < obj.arrItems.length; i++) {
				if (!obj.arrItems[i].IsValid || (obj.arrItems[i].IsCustom && obj.onCustom  != null && !obj.onCustom.apply(obj.target, [obj.arrItems[i]]))) {
					obj.onError.apply(obj.target, [obj.arrItems[i]]);
					form.stage.focus = obj.arrItems[i].Field;
					return;
				}
			}
			
			// if everything is ok
			obj.onSubmit.apply(obj.target);
		}
	}	
}