<?php
/**
 * @project 		SKY CHATTER
 * @file 			index.php
 * @author			Adil Farooq
 * @description		The Main controller of the application. The flex UI will call this
 * 					controller with POSTED params and the controller will call the respective
 * 					event and fire the event.
 */

require_once 'listener/ApplicationStartupListener.php';
require_once 'listener/LoginEventListener.php';
require_once 'listener/SignupEventListener.php';
require_once 'listener/SearchReviewEventListener.php';
require_once 'listener/AddReviewEventListener.php';
require_once 'listener/SearchReviewEventListener.php';
require_once 'listener/AirportInfoEventListener.php';
require_once 'rb12lg.php';

// setting up the database connection
R::setup("mysql:host=cool2fly2dev.db.6045347.hostedresource.com;dbname=cool2fly2dev","cool2fly2dev","Dexter123");
//R::setup("mysql:host=localhost;dbname=cool2fly2_development","root","");
R::freeze();
// events registery
$eventListeners=array("ON_APPLICATION_STARTUP"=>new ApplicationStartupListener(),
		"ON_LOGIN"=>new LoginEventListener(),
		"ON_SIGNUP"=>new SignupEventListener(),
		"ON_SEARCH_REVIEW"=>new SearchReviewEventListener(),
		"ON_ADD_REVIEW"=>new AddReviewEventListener(),
		"ON_AIRPOR_INFO"=>new AirportInfoEventListener()
);

$eventType = $_REQUEST["eventType"];

$listener = $eventListeners[$eventType];
$parameterNames = $_REQUEST;

if ($listener != null) {
	$listener->fireEvent($parameterNames);
}

?>