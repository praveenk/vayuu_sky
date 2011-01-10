<?php

/**
 * @project 		SKY CHATTER
 * @file 			SearchReviewEventListener.php
 * @author			Adil Farooq
 * @description		The event handler for searching reviews based on either airport id or the review keywords.
 */

class SearchReviewEventListener {

	public function fireEvent($parameterNames){
		$airport_code = @$parameterNames["airport_id"];
		// this airport id will actually be the airport code.

		$reviewKeywords = @$parameterNames["reviewKeywords"];

		$airport = @$parameterNames["airport"];
		
		$reviews = null;

		// if the airport id is provided get the reviews against that airport.
		if ($airport == null && $airport_code != null && $airport_code != ""){
			// get the numeric airport id against the airport code
			$airport = R::findOne("airport", "airport_id=?", array($airport_code));
		}
		if ($airport != null){
			// get the reviews list against the airport id
			$reviews = R::find("user_review", "airport_id = ?", array($airport->id));
		}
		elseif ($reviewKeywords != null && $reviewKeywords != ""){
			$reviews = R::find("user_review", "review_comment like '%".$reviewKeywords."%'");
		}

		$message = "";
		if ($reviews == null || count($reviews) == 0){
			// if there are no reviews fetched from the database, set the messsage
			$message = "No review(s) found!";
		}

		echo JSONConverter::convertReviewsToJson($reviews, $message);
	}


}

?>