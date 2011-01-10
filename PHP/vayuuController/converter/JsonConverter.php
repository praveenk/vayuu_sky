<?php

/**
 * @project 		SKY CHATTER
 * @file 			JsonConverter.php
 * @author			Adil Farooq
 * @description		As the name implies, the JSON converter takes and model object,
 * 					converts it to a php associative array and returns a JSON
 * 					representation of the object.
 */

class JSONConverter{

	/**
	 * @author			Adil Farooq
	 * @description		Method to take a list of reviews and convert each object into
	 * 					JSON representation.
	 */
	public static function convertReviewsToJson($reviews, $message){
		$reviewsArray= array();

		if ($reviews != null){
			foreach ($reviews as $review){
				$reviewJSONArray = JSONConverter::getReviewArray($review);
				$reviewsArray[count($reviewsArray)] = $reviewJSONArray;
			}
		}
		return JSONConverter::convert($reviewsArray, $message);
	}

	/**
	 * @author			Adil Farooq
	 * @description		Just a controlling method for the conversion of user bean
	 */
	public static function convertUserToJson($user, $message){
		$userarray = JSONConverter::getUserArray($user);
		return JSONConverter::convert($userarray, $message);
	}

	/**
	 * @author			Adil Farooq
	 * @description		Convert review bean into an associative array. fetch the corresponding
	 * 					airport and the user beans from the database
	 */
	private static function getReviewArray($review){
		$reviewarray = null;

		if ($review != null){
			$reviewarray = array();
			$reviewarray["id"]=$review->id;
			$reviewarray["dateOfEntry"]=$review->date_of_entry;
			
			$reviewarray["reviewComment"]=htmlentities($review->review_comment);

			$airport = R::findOne("airport", "id=?", array($review->airport_id));
			if ($airport == null){
				$airport = R::dispense("airport");
			}
			$reviewarray["airportId"]=$airport->airport_id;
			$reviewarray["airportName"]=$airport->airport_name;

			$user = R::findOne("user", "id=?", array($review->user_id));
			if ($user == null){
				$user = R::dispense("user");
			}
			$reviewarray["userName"]=$user->user_name;
		}
		return $reviewarray;

	}

	/**
	 * @author			Adil Farooq
	 * @description		Convert a single user bean into an associative array
	 */
	private static function getUserArray($user){
		$userarray = null;

		if ($user != null){
			$userarray = array();
			$userarray["userId"]=$user->id;
			$userarray["userName"]=$user->user_name;
			$userarray["email"]=$user->email;
			$userarray["password"]=$user->password;
			$userarray["homeAirport"]=$user->home_airport;
		}
		return $userarray;
	}

	/**
	 * @author			Adil Farooq
	 * @description		Convert an associative array representation of a model
	 * 					object into JSON
	 */
	private static function convert($entityArray, $message){
		$jsonarray = array();
		$msgarray = array("message"=>$message);
		$jsonarray[0]=$msgarray;
		$jsonarray[1]=$entityArray;

		return json_encode($jsonarray);

	}
}

?>