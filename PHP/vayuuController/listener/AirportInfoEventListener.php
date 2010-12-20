<?php
class AirportInfoEventListener {

	public function fireEvent($parameterNames){
		echo $parameterNames["eventType"];
	}


}

?>