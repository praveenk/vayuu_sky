package com.mobex.map.marker
{
	import com.google.maps.InfoWindowOptions;
	import com.google.maps.LatLng;
	import com.google.maps.Map;
	import com.google.maps.MapMouseEvent;
	import com.google.maps.overlays.MarkerOptions;
	import com.google.maps.styles.FillStyle;
	import com.mobex.application.framework.ApplicationContext;
	import com.mobex.map.marker.tab.ClusterInfoPanel;
	
	import flash.display.Loader;
	import flash.geom.Point;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	import mx.controls.TextArea;
	
	import spark.components.Group;
	
	public class AirportClusterMarker extends ClusterableMarker
	{
		private var containedMarkers:ArrayList = new ArrayList();
		[Embed(source="assets/cluster.png")]
		public var AirportClusterIcon:Class;  
		private var count:int = 0;
		
		public function AirportClusterMarker(latlng:LatLng, count:int)
		{
		this.count = count;
		
			super(latlng, new MarkerOptions({				
				icon: new AirportClusterIcon(),
				iconAlignment: MarkerOptions.ALIGN_BOTTOM,
				hasShadow: true
			}));
			
			addEventListener(MapMouseEvent.CLICK, openAirportInfoWindow);	
		}
		
		public function contains(clusterableMarker:ClusterableMarker):Boolean{
			return containedMarkers.getItemIndex(clusterableMarker) != -1;
		}
		
		private function openAirportInfoWindow(e:MapMouseEvent):void			
		{
			var map:Map = this.pane.map as Map;
			
			var clusterWindow:ClusterInfoPanel = new ClusterInfoPanel();
			clusterWindow.percentHeight = 100;
			clusterWindow.percentWidth = 100;
			(map.parent as Group).addElement(clusterWindow);
		}
		

	}
}