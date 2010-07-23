package org.tizianoproject.model.vo
{
	public class Author
	{
		private var _id:Number;
		private var _avatar:String;
		private var _name:String;
		private var _type:String;
		private var _city:String;
		private var _region:String;
		private var _age:String;
		private var _intro:String;
		private var _stories:Array;
		
		public function Author()
		{
		}
		
		public function get fullName():String
		{
			return name;
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
		
		public function set name( value:String ):void
		{
			_name = value;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function set type( value:String ):void
		{
			_type = value;
		}
		
		public function get type():String
		{
			return _type;
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
		
		public function set age( value:String ):void
		{
			_age = value;
		}
		
		public function get age():String
		{
			return _age;
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