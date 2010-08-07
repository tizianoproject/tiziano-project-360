package org.tizianoproject.utils
{
	import com.asual.swfaddress.SWFAddress;

	public class DeepLink extends Object
	{
		private static const BROWSER_TITLE:String = "Tiziano 360: ";
		
		public static const STORY:String		= "story";
		public static const ABOUT:String		= "about";
		public static const PROFILE:String		= "profile";
		public static const DIRECTORY:String	= "directory";
		
		private var _param:String;
		private var _id:Number;
		private var _type:String;
		
		public function DeepLink()
		{
		}
		
		/**********************************
		 * Methods
		 **********************************/
		public function updateAddress( value:* ):void
		{		
			SWFAddress.setValue( value );
		}
		
		public function updateTitle( value:String ):void
		{
			SWFAddress.setTitle( BROWSER_TITLE + value );
		}
		
		//Evaluate the params and see if any are important
		public function evaluateParam( value:String ):void
		{
			param = "";
			id = -1;
			
			switch( value ){
				case "mentors":
					param = "mentorsBtn";
					type = DIRECTORY;
					break;
				case "mentor":
					param = "mentorsBtn";
					type = DIRECTORY;
					break;
				case "reporters":
					param = "reportersBtn";
					type = DIRECTORY;
					break;
				case "reporter":
					param = "reportersBtn";
					type = DIRECTORY;
					break;
				case "students":
					param = "reportersBtn";
					type = DIRECTORY;
					break;
				case "student":
					param = "reportersBtn";
					type = DIRECTORY;
					break;
				case "about":
					param = "aboutBtn";
					type = ABOUT;
					break;
				//Try to convert the deep link into a Number
				default:
					try{
						var number:Number = Number( value );
						//If number is a Number and is Greater than zero, it's Legit
						//Now wait for the XML to Load 
						if( !isNaN( number ) && number > 0 ) {
							id = number;
							type = STORY;
						}
					}
					catch( e:Error ){
						trace( "DeepLink::onSwfAddressHandler:Error:", e.message );
					}
					break;
			} 			
		}
		
		/**********************************
		 * Getter's Setters
		 **********************************/
		public function set param( value:String ):void
		{
			_param = value
		}
		
		public function get param():String
		{
			return _param;
		}
		
		public function set id( value:Number ):void
		{
			_id = value;
		}
		
		public function get id():Number
		{
			return _id;
		}
		
		public function set type( value:String ):void
		{
			_type = value;
		}
		
		public function get type():String
		{
			return _type;
		}
	}
}