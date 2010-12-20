<?php
require 'rb12lg.php';

class ApplicationStartupListener {

	public function fireEvent($parameterNames){
		
//		$airport = R::load("airport", 66);
//	
//		echo '<br>'.$airport->airport_name;
		echo '<br>'.$parameterNames["eventType"];
	}


}

?>