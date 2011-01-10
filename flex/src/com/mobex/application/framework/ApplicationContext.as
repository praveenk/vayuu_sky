package com.mobex.application.framework
{
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	
	[Bindable]
	public class ApplicationContext 
	{
		private var _configModel:XML;
		private static var context:ApplicationContext = new ApplicationContext();
		

		public static var gmapKey:String;
		
		public function ApplicationContext()
		{
			
		}
		
		public static function get instance():ApplicationContext{
			return context;
		}
	
		
		public function get googleMapKey():String{			
			return _configModel.google_map_key;
		}
		public function get currentWeatherApiURL():String{			
			return _configModel.current_weather_api_url;
		}

		public function get airportIconImage():String{			
			return _configModel.airport_icon_image;
		}
		public function get airportClusterImage():String{			
			return _configModel.airport_cluster_image;
		}
		public function get radarImageURL():String{			
			return _configModel.radar_image_url;
		}
		public function get crossdomainPolicyURL():String{			
			return _configModel.crossdomain_policy_url;
		}
		public function get serviceUrl():String{			
			return _configModel.service_url;
		}

		public function set configModel(value:XML):void
		{
			_configModel = value;
			gmapKey = _configModel.google_map_key;
		}

	}
}