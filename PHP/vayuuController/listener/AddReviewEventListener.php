<?php
/**
 * @project 		SKY CHATTER
 * @file 			AddReviewEventListener.php
 * @author			Adil Farooq
 * @description		The event handler for adding review
 */

class AddReviewEventListener {

	public function fireEvent($parameterNames){
		// Getting request parameters
		$airport_id = $parameterNames["airport_id"];
		$userId = $parameterNames["user_id"];
		$comment = $parameterNames["comment"];

		// airport's numeric id is required against the airport code 
		$airport = R::findOne("airport", "airport_id=?", array($airport_id));

		$userReview = R::dispense("user_review");
		
		// Setting the review's properties 
		$userReview->user_id = $userId;
		$userReview->airport_id = $airport->id;
		$userReview->date_of_entry = date("Y-m-d, h:i:s");
		$userReview->review_comment = $comment;
		$message = null;
		try {
			// Saving the review.
			R::store($userReview);

		} catch (Exception $e) {
			$message = "Error During Add Review ".$e->getMessage();
		}

		if ($message == null){
			// If there is no error, get the list of all reviews according to the airport id. 
			$searchReviewEventListener = new SearchReviewEventListener();
			$searchReviewEventListener->fireEvent($parameterNames);
		}
	}
}

?>