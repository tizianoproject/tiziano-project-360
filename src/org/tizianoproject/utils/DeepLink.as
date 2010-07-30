package org.tizianoproject.utils
{
	import com.asual.swfaddress.SWFAddress;

	public class DeepLink extends Object
	{
		private var _param:String;
		private var _id:Number;
		
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
			SWFAddress.setTitle( "Tiziano 360: " + value );
		}
		
		//Evaluate the params and see if any are important
		public function evaluateParam( value:String ):void
		{
			switch( value ){
				case "mentors":
					param = "mentorsView";
					break;
				case "mentor":
					param = "mentorsView";
					break;
				case "reporters":
					param = "studentsView";
					break;
				case "reporter":
					param = "studentsView";
					break;
				case "students":
					param = "studentsView";
					break;
				case "student":
					param = "studentsView";
					break;
				//Try to convert the deep link into a Number
				default:
					try{
						var number:Number = Number( value );
						//If number is a Number and is Greater than zero, it's Legit
						//Now wait for the XML to Load 
						if( !isNaN( number ) && number > 0 ) id = number;
					}
					catch( e:Error ){
						trace( "Application::onSwfAddressHandler:Error:", e.message );
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
	}
}