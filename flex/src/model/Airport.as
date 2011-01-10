package model
{
	import com.google.maps.overlays.Marker;
	import com.mobex.map.marker.AirportMarker;
	
	public class Airport
	{
		private var _airportId:String;
		private var _name:String;
		private var _city:String;
		private var _stateId:String;
		private var _latitude:String;
		private var _longitude:String;        
		
		private var _airportType:String;
		private var _managerPh:String;
		private var _airportElev:String;
		private var _chartName:String;
		private var _fuelTypes:String;
		private var _airportOwnership:String;
		
		
		private var _weather:String;
		private var _temperature_string:String;
		private var _celcius_temperature:String;
		private var _relative_humidity:String;
		private var _wind_dir:String;
		private var _wind_degrees:String;
		private var _wind_mph:String;
			
		private var _marker:AirportMarker;
		
		
		public function Airport(
			airportId:String,
			name:String,
			city:String,
			stateId:String,
			latitude:String,
			longitude:String,
			airportType:String,
			managerPh:String,
			airportElev:String,
			chartName:String,
			fuelTypes:String,
			airportOwnership:String
		){
			_airportId = (airportId!=null && airportId != "")?airportId:"Info not Available"; 
			_name = name;
			_city = (city!=null && city != "")?city:"Info not Available";
			_stateId = stateId;
			_latitude= latitude;
			_longitude = longitude;
			_airportType = (airportType!=null && airportType != "")?airportType:"Info not Available";
			_managerPh = (managerPh!=null && managerPh != "")?managerPh:"Info not Available";
			_airportElev = (airportElev!=null && airportElev != "")?airportElev:"Info not Available";
			_chartName = (chartName!=null && chartName != "")?chartName:"Info not Available";
			_fuelTypes =(fuelTypes!=null && fuelTypes != "")?fuelTypes:"Info not Available";
			_airportOwnership = (airportOwnership!=null && airportOwnership != "")?airportOwnership:"Info not Available";
		}
		
		
		public function get airportId():String
		{
			return _airportId;
		}

		public function get name():String
		{
			return _name;
		}

		public function get city():String
		{
			return _city;
		}

		public function get stateId():String
		{
			return _stateId;
		}



		public function get latitude():String
		{
			return _latitude;
		}

		public function get longitude():String
		{
			return _longitude;
		}

		public function get marker():AirportMarker
		{
			return _marker;
		}

		public function set marker(value:AirportMarker):void
		{
			_marker = value;
		}

		public function get weather():String
		{
			return _weather;
		}

		public function get weather_icon():String
		{
			var weatherIcon:String = "unknown";
			var weather:String = (_weather != null)?_weather.toLowerCase():""; 
			
			if (weather.indexOf("clear") != -1){
				weatherIcon= "clear";
			}else if (weather.indexOf("cloudy") != -1){
				weatherIcon= "cloudy";
			}else if (weather.indexOf("flurries") != -1){
				weatherIcon= "flurries";
			}else if (weather.indexOf("fog") != -1){
				weatherIcon= "fog";
			}else if (weather.indexOf("hazy") != -1){
				weatherIcon= "hazy";
			}else if (weather.indexOf("mostly cloudy") != -1){
				weatherIcon= "mostlycloudy";
			}else if (weather.indexOf("mostly sunny") != -1){
				weatherIcon= "mostlysunny";
			}else if (weather.indexOf("partly cloudy") != -1){
				weatherIcon= "partlycloudy";
			}else if (weather.indexOf("partly sunny") != -1){
				weatherIcon= "partlysunny";
			}else if (weather.indexOf("rain") != -1){
				weatherIcon= "rain";
			}else if (weather.indexOf("sleet") != -1){
				weatherIcon= "sleet";
			}else if (weather.indexOf("snow") != -1){
				weatherIcon= "snow";
			}else if (weather.indexOf("sunny") != -1){
				weatherIcon= "sunny";
			}else if (weather.indexOf("tstorms") != -1){
				weatherIcon= "clear";
			}
			return weatherIcon;
		}
		
		public function set weather(value:String):void
		{
			_weather = value;
		}

		public function get temperature_string():String
		{
			return _temperature_string;
		}

		public function set temperature_string(value:String):void
		{
			_temperature_string = value;
		}

		public function get relative_humidity():String
		{
			return _relative_humidity;
		}

		public function set relative_humidity(value:String):void
		{
			_relative_humidity = value;
		}

		public function get wind_dir():String
		{
			return _wind_dir;
		}

		public function set wind_dir(value:String):void
		{
			_wind_dir = value;
		}

		public function get wind_degrees():String
		{
			return _wind_degrees;
		}

		public function set wind_degrees(value:String):void
		{
			_wind_degrees = value;
		}

		public function get wind_mph():String
		{
			return _wind_mph;
		}

		public function set wind_mph(value:String):void
		{
			_wind_mph = value;
		}

		public function get celcius_temperature():String
		{
			return _celcius_temperature;
		}

		public function set celcius_temperature(value:String):void
		{
			_celcius_temperature = value;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function set stateId(value:String):void
		{
			_stateId = value;
		}

		public function get airportType():String
		{
			return _airportType;
		}

		public function get managerPh():String
		{
			return _managerPh;
		}

		public function get airportElev():String
		{
			return _airportElev;
		}

		public function get chartName():String
		{
			return _chartName;
		}

		public function get fuelTypes():String
		{
			return _fuelTypes;
		}

		public function get airportOwnership():String
		{
			return _airportOwnership;
		}


	}
}