/**
 * This class contains utility functions for date / time
 *
 * @author	sm.flashteam@gmail.com
 * @version	1.0
 */
package com.sff.utils {	
	public class DateTimeUtils {
		public static const LOCALE_FR:String = "fr";
		public static const LOCALE_EN:String = "en";
		
		public static const ENDays:Array = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
		public static const ENMonths:Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

		public static const FRDays:Array = ["Dimanche", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi"];
		public static const FRMonths:Array = ["Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"];
		
		public function DateTimeUtils() {
			// nothing to do here
		}
		
		/**
		 * Convert a date string into Date object.
		 * If year is smaller than 1000, 2000 will be added.
		 * 
		 * @param	dateString	string of date
		 * @param	format		format for date string. Following are all supported characters
		 * 							y - year digit
		 * 							m - month digit
		 * 							d - day digit
		 * 							H - hour digit
		 * 							M - minute digit
		 * 							S - second digit
		 * 							i - mili second digit
		 * @param	acceptNull	If there's something wrong, this function returns null {@code true} or throw an ArgumentError (@code false}
		 * 
		 * @throws	ArgumentError	Date / Format string is invalid
		 * @usage	
		 * 			parseDateString("2000/08/24 00:52:32", "yyyy/mm/dd HH:MM:SS");
		 * 
		 * @return	a date object 
		 */
		public static function parseDateString(dateString:String, format:String, acceptNull:Boolean = false):Date {
			var lastChar	:String;
			var str			:String;
			var i			:int = 0; 
			
			// parts of date
			var year		:int = -1;
			var month		:int = -1;
			var day			:int = -1;
			var hour		:int = -1;
			var minute		:int = -1;
			var second		:int = -1;
			var miliSecond	:int = -1;
			var error		:Boolean = false;
			
			// check all format characters
			while (i < format.length) {
				lastChar = format.charAt(i);
				
				if (lastChar == "y" || lastChar == "m" || lastChar == "d" || lastChar == "H" || lastChar == "M" || lastChar == "S" || lastChar == "i") {
					str = "";
					
					while (i < format.length && lastChar == format.charAt(i)) {
						str += dateString.charAt(i);
						i++;
					}
					
					// test the number
					error = !(/^\d*$/.test(str));
					
					switch (lastChar) {
						case "y": // year
							if (year == -1) {
								year = parseInt(str);
							} else {
								error = true;
							}							
							break;
							
						case "m": // month
							if (month == -1) {
								month = parseInt(str);
							} else {
								error = true;
							}	
							break;
							
						case "d": // day
							if (day == -1) {
								day = parseInt(str);
							} else {
								error = true;
							}
							break;
							
						case "H": // hour
							if (hour == -1) {
								hour = parseInt(str);
							} else {
								error = true;
							}	
							break;
							
						case "M": // minute
							if (minute == -1) {
								minute = parseInt(str);
							} else {
								error = true;
							}
							break;
							
						case "S": // second
							if (second == -1) {
								second = parseInt(str);
							} else {
								error = true;
							}
							break;
							
						case "i": // milisecond
							if (miliSecond == -1) {
								miliSecond = parseInt(str);
							} else {
								error = true;
							}
							break;
					}
				} else {
					i++;
				}
				
				if (error) {
					if (acceptNull) {
						return null;
					} else {
						throw new ArgumentError("Format string is invalid");
					}
				}
			}
			
			hour = hour != -1 ? hour : 0;
			minute = minute != -1 ? minute : 0;
			second = second != -1 ? second : 0;
			miliSecond = miliSecond != -1 ? miliSecond : 0;
			
			// validate date
			if (year < 1000) {
				year += 2000;
			}
			
			// return validate
			if (isValidDate(day, month, year) && (0 <= hour && hour < 24) && (0 <= minute && minute < 60) && (0 <= second && second < 60) && (0 <= miliSecond && miliSecond < 1000)) {
				return new Date(year, month - 1, day, hour, minute, second);				
			} else {
				if (acceptNull) {
					return null;
				} else {
					throw new ArgumentError("Date string is invalid");
				}
			}
		}
		
		/**
		 * Validate date information
		 * 
		 * @param	day		day value (1 - 31)
		 * @param	month	month value (1 - 12)
		 * @param	year	year value
		 * 
		 * @return			{@code true} if it is an valid date
		 */
		public static function isValidDate(day:uint, month:uint, year:uint):Boolean {
			switch (month) {
				case 1:
				case 3:
				case 5:
				case 7:
				case 8:
				case 10:
				case 12:
					if (day > 31) {
						return false;
					} else {
						return true;
					}
				
				case 4:
				case 6:
				case 9:
				case 11:
					if (day > 30) {
						return false;
					} else {
						return true;
					}
					
				case 2:
					if (year % 4 == 0) {
						if (day > 29) {
							return false;
						}
					} else {
						if (day > 28) {
							return false;
						}
					}
					
					return true;
				
				default:
					return false;
			}
			
			// never happen
			return true;
		}
		
		/**
		 * Get number of second / milisecond from a time string.
		 * 
		 * @param	timeString	string of time
		 * @param	format		format for time string. Following are all supported characters:
		 * 							H - hour digit
		 * 							M - minute digit
		 * 							S - second digit
		 * 							i - mili second digit
		 * @param	getMiliSecond	returned value is milisecond (true) or second (false)
		 * @param	acceptZero	If there's something wrong, this function returns 0 {@code true} or throw an ArgumentError (@code false}
		 * 
		 * @throws	ArgumentError	Format string does not match date string
		 * @usage	
		 * 			parseDateString("00:52:32:250", "HH:MM:SS:iii");
		 * 
		 * @return	number of second or milisecond
		 */
		public static function parseTimeString(timeString:String, format:String, getMiliSecond:Boolean = false, acceptZero:Boolean = false):int {
			var lastChar	:String;
			var str			:String;
			var i			:int = 0; 
			
			// parts of date
			var year		:int = -1;
			var month		:int = -1;
			var day			:int = -1;
			var hour		:int = -1;
			var minute		:int = -1;
			var second		:int = -1;
			var miliSecond	:int = -1;
			var error		:Boolean = false;
			
			// check all format characters
			while (i < format.length) {
				lastChar = format.charAt(i);
				
				if (lastChar == "H" || lastChar == "M" || lastChar == "S" || lastChar == "i") {
					str = "";
					
					while (i < format.length && lastChar == format.charAt(i)) {
						str += timeString.charAt(i);
						i++;
					}
					
					// test the number
					error = !(/^\d*$/.test(str));
					
					switch (lastChar) {
						case "H": // hour
							if (hour == -1) {
								hour = parseInt(str);
							} else {
								error = true;
							}	
							break;
							
						case "M": // minute
							if (minute == -1) {
								minute = parseInt(str);
							} else {
								error = true;
							}
							break;
							
						case "S": // second
							if (second == -1) {
								second = parseInt(str);
							} else {
								error = true;
							}
							break;
							
						case "i": // milisecond
							if (miliSecond == -1) {
								miliSecond = parseInt(str);
							} else {
								error = true;
							}
							break;
					}
				} else {
					i++;
				}
				
				if (error) {
					if (acceptZero) {
						return 0;
					} else {
						throw new ArgumentError("Format string is invalid");
					}
				}
			}
			
			hour = hour != -1 ? hour : 0;
			minute = minute != -1 ? minute : 0;
			second = second != -1 ? second : 0;
			miliSecond = miliSecond != -1 ? miliSecond : 0;

			if (getMiliSecond) {
				return (hour * 3600 + minute * 60 + second) * 1000 + miliSecond;
			} else {
				return hour * 3600 + minute * 60 + second;
			}
		}
		
		/**
		 * Convert a date object to string
		 * 
		 * @param	date		date object
		 * @param	format		format for date string. Following are all supported characters
		 * 							y - year digit
		 * 							m - month digit
		 * 							d - day digit
		 * 							H - hour digit
		 * 							M - minute digit
		 * 							S - second digit
		 * 							i - mili second digit
		 * 							N - name of month (UPPER CASE) (3 letters) 
		 * 						   NN - name of month (UPPER CASE)
		 * 							n - name of month (Capitalize) (3 letters)
		 * 						   nn - name of month (Capitalize) 
		 * 							W - day of week (UPPER CASE) (3 letters)
		 * 						   WW - day of week (UPPER CASE)
		 * 							w - day of week (Capitalize) (3 letters)
		 * 						   ww - day of week (Capitalize)
		 * 
		 * @param	acceptNull	If there's something wrong, this function returns null {@code true} or throw an ArgumentError (@code false}
		 * @throws	ArgumentError	Format string is invalid
		 * @usage	
		 * 			convertDateToString(date, "dd N, yyyy"); -> 18 September, 2000
		 * 			convertDateToString(date, "dd n, yyyy"); -> 18 september, 2000
		 * 
		 * @return				result text
		 */
		public static function convertDateToString(date:Date, format:String, locale:String = DateTimeUtils.LOCALE_EN, acceptNull:Boolean = false):String {
			var acceptValues:String = "ymdHMSiNnWw";
			
			var lastChar	:String;
			var str			:String;
			var result		:String = "";
			var i			:int = 0; 
			var isError		:Boolean = false;
			var tempStr		:String;
			
			// check all format characters
			while (i < format.length) {
				lastChar = format.charAt(i);
				
				if (acceptValues.indexOf(lastChar) != -1) {
					str = "";
					
					while (i < format.length && lastChar == format.charAt(i)) {
						str += lastChar;
						i++;
					}
										
					switch (lastChar) {
						case "y": // year
							if (str.length == 4) {
								result += date.fullYear.toString();
							} else if (str.length == 2) {
								if (date.fullYear % 100 < 10) {
									result += "0" + (date.fullYear % 100);
								} else {
									result += date.fullYear % 100;
								}
							} else {
								isError = true;
							}
							break;
						
						case "m": // month
							if (str.length <= 2) {
								if (str.length == 2 && date.month < 9) {
									result += "0";
								}								
								result += (date.month + 1).toString();
							} else {
								isError = true;
							}
							break;
							
						case "d": // day
							if (str.length <= 2) {
								if (str.length == 2 && date.date < 10) {
									result += "0";
								}								
								result += date.date.toString();
							} else {
								isError = true;
							}
							break;
							
						case "H": // hour
							if (str.length <= 2) {
								if (str.length == 2 && date.hours < 10) {
									result += "0";
								}								
								result += date.hours.toString();
							} else {
								isError = true;
							}
							break;
							
						case "M": // minute
							if (str.length <= 2) {
								if (str.length == 2 && date.minutes < 10) {
									result += "0";
								}								
								result += date.minutes.toString();
							} else {
								isError = true;
							}
							break;
							
						case "S": // second
							if (str.length <= 2) {
								if (str.length == 2 && date.seconds < 10) {
									result += "0";
								}								
								result += date.seconds.toString();
							} else {
								isError = true;
							}
							break;
							
						case "i": // milisecond
							if (str.length <= 3) {
								if (str.length == 3 && date.milliseconds < 100) {
									result += "00";
								} else if (str.length == 2 && date.milliseconds < 10) {
									result += "0";
								}
								
								result += date.milliseconds.toString();
							} else {
								isError = true;
							}
							break;
						
						case "W": // day of week
						case "w":
							tempStr = getDayOfWeek(date.day, locale);
							
							if (str.length == 1) {
								tempStr = tempStr.substr(0, 3);
								result += (lastChar == "W") ? tempStr.toUpperCase() : tempStr;
							} else if (str.length == 2) {
								result += (str.charAt(0) == "W") ? tempStr.toUpperCase() : tempStr;
							} else {
								isError = true;
							}
							break;
							
						case "N": // name of month
						case "n":
							tempStr = getMonth(date.month, locale);
							
							if (str.length == 1) {
								tempStr = tempStr.substr(0, 3);
								result += (lastChar == "N") ? tempStr.toUpperCase() : tempStr;
							} else if (str.length == 2) {
								result += (str.charAt(0) == "N") ? tempStr.toUpperCase() : tempStr;
							} else {
								isError = true;
							}
							break;
					}
				} else {
					result += lastChar;
					i++;
				}
				
				if (isError) {
					if (acceptNull) {
						return null;
					} else {
						throw new ArgumentError("Format string is invalid");
					}
				}
			}

			return result;
		}
		
		private static function getMonth(month:int, locale:String):String {
			switch (locale) {
				case DateTimeUtils.LOCALE_EN:
					return DateTimeUtils.ENMonths[month];
					break;
				
				case DateTimeUtils.LOCALE_FR:
					return DateTimeUtils.FRMonths[month];
					break;
			}
			
			return "";
		}
		
		private static function getDayOfWeek(month:int, locale:String):String {
			switch (locale) {
				case DateTimeUtils.LOCALE_EN:
					return DateTimeUtils.ENDays[month];
					break;
				
				case DateTimeUtils.LOCALE_FR:
					return DateTimeUtils.FRDays[month];
					break;
			}
			
			return "";
		}
	}
}