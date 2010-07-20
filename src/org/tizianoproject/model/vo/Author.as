package org.tizianoproject.model.vo
{
	public class Author
	{
		private var _id:Number;
		private var _avatar:String;
		private var _firstName:String;
		private var _lastName:String;
		private var _city:String;
		private var _region:String;
		private var _grade:String;
		private var _intro:String;
		private var _stories:Array;
		
		public function Author()
		{
		}
		
		public function get fullName():String
		{
			return firstName + " " + lastName;
		}
		
		/**********************************
		 * Read Write Accessors
		 **********************************/
		public function set id( value:Number ):void
		{
			_id = value;
		}
		
		public function get id():Number
		{
			return _id;
		}

		public function set avatar( value:String ):void
		{
			_avatar = value;
		}
		
		public function get avatar():String
		{
			return _avatar;
		}
		
		public function set firstName( value:String ):void
		{
			_firstName = value;
		}
		
		public function get firstName():String
		{
			return _firstName;
		}
		
		public function set lastName( value:String ):void
		{
			_lastName = value;
		}
		
		public function get lastName():String
		{
			return _lastName;
		}
		
		public function set city( value:String ):void
		{
			_city = value;
		}
		
		public function get city():String
		{
			return _city;
		}
		
		public function set region( value:String ):void
		{
			_region = value;
		}
		
		public function get region():String
		{
			return _region;
		}
		
		public function set grade( value:String ):void
		{
			_grade = value;
		}
		
		public function get grade():String
		{
			return _grade;
		}
		
		public function set intro( value:String ):void
		{
			_intro = value;
		}
		
		public function get intro():String
		{
			return _intro;
		}
	}
}