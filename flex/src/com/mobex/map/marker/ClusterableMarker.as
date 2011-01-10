package com.mobex.map.marker
{
	import com.google.maps.LatLng;
	import com.google.maps.overlays.Marker;
	import com.google.maps.overlays.MarkerOptions;
	
	public class ClusterableMarker extends Marker
	{

		private var _cluster:AirportClusterMarker = null;
		
		public function ClusterableMarker(arg0:LatLng, arg1:MarkerOptions=null)
		{
			super( arg0, arg1);
		}

		public function get cluster():AirportClusterMarker
		{
			return _cluster;
		}

		public function set cluster(cluster:AirportClusterMarker):void
		{
			_cluster = cluster;
		}		
	}
}