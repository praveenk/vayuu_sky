<?php
/**
 * @project 		SKY CHATTER
 * @file 			LoginEventListener.php
 * @author			Adil Farooq
 * @description		The event handler for login
 */

require_once 'converter/JsonConverter.php';

class LoginEventListener {

	public function fireEvent($parameterNames){
		$email = $parameterNames["email"];
		$password = $parameterNames["password"];
		
		// Checking the email address and the password.
		$user = R::findOne("user", "email=? and password=?", array($email, $password));

		$message = "";
		if ($user == null){
			$message = "Email or password provided are incorrect!";
		}
		echo JSONConverter::convertUserToJson($user, $message);
	}


}

?>