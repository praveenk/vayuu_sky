<?php
/**
 * @project 		SKY CHATTER
 * @file 			SignupEventListener.php
 * @author			Adil Farooq
 * @description		The event handler for signing up a new user.
 */

class SignupEventListener {

	public function fireEvent($parameterNames){
		$userName = $parameterNames["userName"];
		$email = $parameterNames["email"];
		$password = $parameterNames["password"];
		$homeAirport = $parameterNames["homeAirport"];
		
		
		// check if there already is a user that has the same user name or email address
		$user = R::findOne("user", "user_name=? or email=?", array($userName, $email));
		$message = "";
				
		if ($user != null){
			$user =null;
			$message = "User Name or email address is already registered by another user!";
		}else{
			// in cse the email and the user name is unique, create a new user bean, 
			// fill it up and save it in the database.
			$user = R::dispense("user");
			
			$user->user_name = $userName;
			$user->email = $email;
			$user->password = $password;
			$user->home_airport = $homeAirport;

			R::store($user);
		}
		
		echo JSONConverter::convertUserToJson($user, $message);
	}


}

?>