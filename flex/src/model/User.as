package model
{
	[Bindable]
	public class User
	{
		private var _id:Number;
		private var _userName:String;
		private var _email:String;
		
		public function User(id:Number, userName:String, email:String)
		{			
			this.id = id;
			this.userName = userName;
			this.email = email;
		}
	
		public function get userName():String
		{
			return _userName;
		}

		public function set userName(value:String):void
		{
			_userName = value;
		}

		public function get email():String
		{
			return _email;
		}

		public function set email(value:String):void
		{
			_email = value;
		}

		public function get id():Number
		{
			return _id;
		}

		public function set id(value:Number):void
		{
			_id = value;
		}


	}
}