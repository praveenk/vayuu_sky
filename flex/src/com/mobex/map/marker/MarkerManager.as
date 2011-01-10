package com.mobex.map.marker
{
	import com.google.maps.LatLng;
	import com.google.maps.LatLngBounds;
	import com.google.maps.Map;
	import com.google.maps.MapMoveEvent;
	import com.google.maps.MapZoomEvent;
	import com.google.maps.overlays.Marker;
	import com.google.maps.overlays.MarkerOptions;
	import com.mobex.map.icon.wind.WeatherWindIcon;
	import com.mobex.map.marker.tab.VayuuInfoPanel;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.utils.Dictionary;
	
	import model.Airport;
	
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	import mx.managers.SystemManager;
	
	import spark.components.Group;
	import spark.components.ToggleButton;
	import spark.primitives.Rect;
	
	public class MarkerManager
	{
		
		private var maxAirport:int = 100;
		
		private var _reviewToggleButton:ToggleButton;
		private var _map:Map;
		private var _markerArray:ArrayList = new ArrayList();
		private var _airportList:ArrayList = null;
		
		private var _undisplayedAirports:ArrayList = new ArrayList();
		
		private var _configurationCache:Dictionary = new Dictionary();
		private var _currentConfiguration:Dictionary = new Dictionary();
		private var _configurationMarkerCount:int = 0;
		//		private var _weatherMarkerArray:ArrayList = new ArrayList();
		
		private var logicalGridCellLength:Number = 14; 
		
		private var maxLat:Number;
		private var minLat:Number;		
		private var maxLng:Number;
		private var minLng:Number;
		
		private var displayedMaxLat:Number;
		private var displayedMinLat:Number;		
		private var displayedMaxLng:Number;
		private var displayedMinLng:Number;
		
		private var actualGridWidth:Number;
		private var actualGridHeight:Number;
		
		private var isZoomCase:Boolean = false;
		private var isMapMoveByPopup:Boolean = false;
		
		public static const AIRPORT_TYPE_ALL:String = "ALL"; 
		public static const AIRPORT_TYPE_AIRPORT:String = "AIRPORT";
		public static const AIRPORT_TYPE_BALLOONPORT:String = "BALLOONPORT";
		public static const AIRPORT_TYPE_GLIDERPORT:String = "GLIDERPORT";
		public static const AIRPORT_TYPE_HELIPORT:String = "HELIPORT";
		public static const AIRPORT_TYPE_SEAPLANE_BASE:String = "SEAPLANE BASE";
		public static const AIRPORT_TYPE_STOLPORT:String = "STOLPORT";
		public static const AIRPORT_TYPE_ULTRALIGHT:String = "ULTRALIGHT";
		
		private var _airportTypesToDisplay:ArrayList = new ArrayList();
		
		private var _selectedMarker:AirportMarker = null; 
		public static const MARKER_SELECT_EVENT:String = "MARKER_SELECT";
		public static const MARKER_UNSELECT_EVENT:String = "MARKER_UNSELECT";
		
		private var parentGroup:Group;
		private var mapRect:Rectangle = null;
		
		public function MarkerManager(map:Map,airportList:ArrayList)
		{
			_map = map;
			_airportTypesToDisplay.addItem(AIRPORT_TYPE_AIRPORT);
			this._airportList = airportList;
			mapRect = new Rectangle(_map.x, _map.y,_map.width, _map.height);
			_map.addEventListener(MapMoveEvent.MOVE_STEP, moveStep);
			map.addEventListener(MapZoomEvent.CONTINUOUS_ZOOM_START, onMapZoomStart);
			map.addEventListener(MapZoomEvent.ZOOM_CHANGED, onMapZoomChanged);
			map.addEventListener(MapMoveEvent.MOVE_END, onMapMove);
		}
		
		private function onMapZoomStart(event:Event):void{
			isZoomCase = true;
		}
		
		private function moveStep(event:Event):void{
			if (_selectedMarker != null && _selectedMarker.popup != null){
				var panel:VayuuInfoPanel = _selectedMarker.popup;
				displayInfoPanelOnStage(panel);
			}
		}
		
		protected function displayInfoPanelOnStage(panel:VayuuInfoPanel, moveCenter:Boolean = false):void{
			var point:Point = _selectedMarker.getDefaultPane(_map).fromLatLngToPaneCoords(_selectedMarker.getLatLng());
			var suggestedY:Number = point.y - panel.height - 21;
			var suggestedX:Number = point.x - panel.width/2 + 18;
			
			panel.x = suggestedX;
			panel.y = suggestedY;
			
			if (moveCenter){
				var rect:Rectangle = _map.getVisibleRect();
				var popupRect:Rectangle = _selectedMarker.popup.getVisibleRect();
				
				if (!rect.containsRect(popupRect)){
					var centerPoint:Point = _map.fromLatLngToPoint(_map.getCenter());
					if (rect.top > popupRect.top){
						var diffTop:Number = rect.top - popupRect.top ;
						centerPoint.y -= diffTop;
					}
					if (rect.right < popupRect.right){
						var diffRight:Number = popupRect.right - rect.right;
						centerPoint.x += diffRight;
					}
					if (rect.left > popupRect.left){
						var diffLeft:Number =  rect.left - popupRect.left;
						centerPoint.x -= diffLeft;
					}
					var centerLatLng:LatLng = _map.fromPointToLatLng(centerPoint);
					isMapMoveByPopup = true;
					_map.panTo(centerLatLng);
				}
			}
		}
		
		private function onMapZoomChanged(event:Event):void
		{		
			if (selectedMarker != null){
				selectedMarker.unSelect();
			}
			removeCurrentMarkerConfiguration();
			placeMarkers();
			isZoomCase = false;
		}
		
		private function onMapMove(event:Event):void
		{					
			if (!isZoomCase){				
				_configurationMarkerCount = 0; 
				
				var verticalChange:Boolean = false;
				var horizontalChange:Boolean = false;
				
				var prevMaxLat:Number = maxLat;
				var prevMinLat:Number = minLat;
				
				var prevMaxLng:Number = maxLng;
				var prevMinLng:Number = minLng;
				
				getLatestBounds();
				
				var newMaxLat:Number = maxLat;
				var newMinLat:Number = minLat;
				
				var newMaxLng:Number = maxLng;
				var newMinLng:Number = minLng;
				
				_currentConfiguration = new Dictionary();
				
				if (minLng < prevMinLng){
					//				Alert.show("Left side buffer");
					newMinLng = minLng;
					newMaxLng = prevMinLng;
					horizontalChange = true;
				}else if (minLng > prevMinLng){
					//				Alert.show("Right side buffer");
					newMinLng = prevMaxLng;
					newMaxLng = maxLng;
					horizontalChange = true;
				}
				if (minLat < prevMinLat){
					//				Alert.show("Down side buffer");
					newMinLat = minLat;
					newMaxLat = prevMinLat;
					verticalChange = true;
				}else if (minLat > prevMinLat){
					//				Alert.show("Up side buffer");
					newMinLat = prevMaxLat;
					newMaxLat = maxLat;
					verticalChange = true;
				}
				
				if (verticalChange){
					if (displayedMinLat > newMinLat){
						displayedMinLat = newMinLat;
					}else{
						verticalChange = false;
					}
					if (displayedMaxLat < newMaxLat){
						displayedMaxLat = newMaxLat;
						verticalChange = true;
					}
				}
				
				if (horizontalChange){
					if (displayedMinLng > newMinLng){
						displayedMinLng = newMinLng;
					}else{
						horizontalChange = false;
					}
					if (displayedMaxLng < newMaxLng){
						displayedMaxLng = newMaxLng;	
						horizontalChange = true;
					}
				}
				
//				if (!isMapMoveByPopup){
					_configurationCache[""+_map.getZoom()] = null;
//				}else{
//					isMapMoveByPopup = false;
//				}
				
				for (var i:int =0; i < _undisplayedAirports.length; i++){
					var airport:Airport = _undisplayedAirports.getItemAt(i) as Airport;
					
					if (_configurationMarkerCount >= maxAirport) break;
					var lat:Number = Number(airport.latitude) ;
					var lng:Number = Number(airport.longitude);
					
					if (verticalChange && lat <= newMaxLat && lat > newMinLat){
						addAirportToCurrentConfiguration(airport, lat,lng, newMinLat, newMinLng);
						i--;
					}else if (horizontalChange && lng <= newMaxLng && lng > newMinLng ){
						addAirportToCurrentConfiguration(airport, lat,lng, newMinLat, newMinLng);
						i--;
					}
				}
				
//				for (var coords:String in _currentConfiguration){
//					var cachedList:ArrayList = cachedConfig[coords] as ArrayList;
//					if (cachedList == null){
//						cachedConfig[coords]= _currentConfiguration[coords];
//					}else{
//						var currentList:ArrayList = _currentConfiguration[coords];
//						for (i = 0; i < currentList.length; i++){
//							airport = currentList.getItemAt(i) as Airport;
//							if (cachedList.getItemIndex(airport) == -1){
//								cachedList.addItem(airport);
//							}
//						}
//					}
//				}
				display();
			}
		}
		
		public function get selectedMarker():AirportMarker
		{
			return _selectedMarker;
		}
		
		public function set selectedMarker(value:AirportMarker):void
		{
			var panel:VayuuInfoPanel = null;
			parentGroup = _map.parent as Group;
			
			if (_selectedMarker != null && _selectedMarker == value){
				if (!(_selectedMarker.popup != null && parentGroup.contains(_selectedMarker.popup))){
					_selectedMarker.popup.resetInfoWindow();
					parentGroup.addElement(_selectedMarker.popup);
				}
				return;
			} 
			
			if (_selectedMarker == null){
				_selectedMarker = value;
			}
			
			if (_selectedMarker != null){
				panel = _selectedMarker.popup;
				
				if (panel != null && parentGroup.contains(panel)){
					parentGroup.removeElement(panel);
				}	
				
				if (_selectedMarker != value && value != null){
					_selectedMarker.unSelect();
				}
				_selectedMarker = value;
				
				if (_selectedMarker != null){
					panel = _selectedMarker.popup;
					
					if (panel != null){
						panel.resetInfoWindow();
						parentGroup.addElement(panel);
					}else{
						
						panel = new VayuuInfoPanel();	
						panel.reviewButton = _reviewToggleButton;
						panel.airport = _selectedMarker.airport;
						_selectedMarker.popup = panel;
						panel.resetInfoWindow();
						parentGroup.addElement(panel);
					}
					displayInfoPanelOnStage(panel, true);
				}
			}
			
		}
		
		private function addAirportToCurrentConfiguration(airport:Airport, lat:Number, lng:Number, minLat:Number, minLng:Number):void{
			var grid_y:Number = Math.abs(Math.abs(lat) - Math.abs(minLat));
			var grid_x:Number = Math.abs(Math.abs(lng) - Math.abs(minLng));
			
			grid_y = Math.floor(grid_y/actualGridHeight);
			grid_x = Math.floor(grid_x/actualGridWidth);
			
			if (_undisplayedAirports.getItemIndex(airport) != -1){
				_undisplayedAirports.removeItem(airport);
			}
			
			if (_currentConfiguration[""+grid_x+"-"+grid_y] == null){
				_currentConfiguration[""+grid_x+"-"+grid_y] = new ArrayList();
				_configurationMarkerCount++;
			}
			
			var list:ArrayList = (_currentConfiguration[""+grid_x+"-"+grid_y] as ArrayList);
			
			if (list.getItemIndex(airport) == -1){
				list.addItem(airport);
			}
		}
		
		private function getLatestBounds():void{
			var neBound:LatLng = _map.getLatLngBounds().getNorthEast();
			var swBound:LatLng = _map.getLatLngBounds().getSouthWest();
			
			maxLat = neBound.lat();
			minLat = swBound.lat();
			
			maxLng = neBound.lng();
			minLng = swBound.lng();
			
			actualGridWidth = Math.abs((Math.abs(maxLng) - Math.abs(minLng)))/logicalGridCellLength;
			actualGridHeight = Math.abs((Math.abs(maxLat) - Math.abs(minLat)))/logicalGridCellLength;
			
			if (minLng > 0){
				minLng = -180 - (180 - minLng);
			}
			
		}
		
		protected function getFilteredAirportListByAirportType():ArrayList{
			var result:ArrayList = new ArrayList();
			if (_airportTypesToDisplay.getItemIndex(AIRPORT_TYPE_ALL) > -1){
				result = _airportList;
			}else{
				for (var i:int =0; i < _airportList.length; i++){
					var airport:Airport = _airportList.getItemAt(i) as Airport;
					
					if (_airportTypesToDisplay.getItemIndex(airport.airportType)>-1){
						result.addItem(airport);
					}
				}
			}
			
			return result;
		}
		
		public function addAirportTypeToDisplay(airportType:String):void{
			clearMarkerCache();
			_airportTypesToDisplay.addItem(airportType);
			removeCurrentMarkerConfiguration();
			placeMarkers();
		}
		
		public function removeAirportTypeFromDisplay(airportType:String):void{
			clearMarkerCache();
			_airportTypesToDisplay.removeItem(airportType);
			removeCurrentMarkerConfiguration();
			placeMarkers();
		}
		
		
		public function placeMarkers(ignoreCoordBounds:Boolean = false):void{
			
			var displayedAirportList:ArrayList = getFilteredAirportListByAirportType();
			placeMarkersByAirportList(displayedAirportList, ignoreCoordBounds);
			
		}
		
		private function placeMarkersByAirportList(displayedAirportList:ArrayList, ignoreCoordBounds:Boolean = false):void{
			
			getLatestBounds();
			
			displayedMaxLat = maxLat;
			displayedMinLat = minLat;
			displayedMaxLng = maxLng;
			displayedMinLng = minLng;
			
			_undisplayedAirports = new ArrayList();
			_configurationMarkerCount = 0;
			
			_undisplayedAirports.addAll(displayedAirportList);
			
			_currentConfiguration = _configurationCache[""+_map.getZoom()];
			
			if (_currentConfiguration == null){
				_currentConfiguration = new Dictionary();
				
				for (var i:int; i < displayedAirportList.length; i++){
					if (_configurationMarkerCount >= maxAirport) break;
					var airport:Airport = displayedAirportList.getItemAt(i) as Airport;
					
					var lat:Number = Number(airport.latitude) ;
					var lng:Number = Number(airport.longitude);
					
					if (ignoreCoordBounds || (!ignoreCoordBounds  && lat <= maxLat && lat > minLat && lng <= maxLng && lng > minLng)){
						addAirportToCurrentConfiguration(airport, lat, lng, minLat, minLng);
					}				
				}
				
				_configurationCache[""+_map.getZoom()] = _currentConfiguration; 
			}
			
			display();
			
			if(displayedAirportList.length == 1){
				airport = displayedAirportList.getItemAt(0) as Airport;
				var marker:Marker = airport.marker;
				_map.panTo(marker.getLatLng());
			}
		}
		
		private function display():void{
			for (var coords:String in _currentConfiguration){			
				var airportList:ArrayList = _currentConfiguration[coords] as ArrayList;
				var marker:Marker = null;
				
				if (airportList != null && airportList.length > 0){
					var airport:Airport = airportList.getItemAt(0) as Airport;
					
					if (airportList.length == 1){
						marker = new AirportMarker(airport);
						airport.marker = marker as AirportMarker;
					}else {						
						var latlng:LatLng = new LatLng( Number(airport.latitude), Number(airport.longitude));
						marker = new AirportClusterMarker(latlng, airportList.length);
					}
					if (marker != null){
						_map.addOverlay(marker);
						_markerArray.addItem(marker);
					}
				}
			}
		}
		
		public function clearMarkerCache():void{
			_configurationCache = new Dictionary();
		}
		
		public function removeCurrentMarkerConfiguration():void{
			
			for (var i:int=0; i < _markerArray.length; i++){
				var marker:ClusterableMarker = _markerArray.getItemAt(i) as ClusterableMarker;
				if (marker != null){				
					_map.removeOverlay(marker);								
				}
			}
			_markerArray.removeAll();
		}
		
		public function set airportList(value:ArrayList):void
		{
			_airportList = value;
		}
		
		public function get reviewToggleButton():ToggleButton
		{
			return _reviewToggleButton;
		}
		
		public function set reviewToggleButton(value:ToggleButton):void
		{
			_reviewToggleButton = value;
		}
		
		public function adjustZoomLevel():void
		{
			var minLatitude:Number =1000000, minLongitude:Number = 1000000, maxLatitude:Number = -1000000, maxLongitude:Number = -1000000;
			var displayedAirportList:ArrayList = getFilteredAirportListByAirportType();
			
			for (var i:int = 0; i < displayedAirportList.length; i++){
				var airport:Airport = displayedAirportList.getItemAt(i) as Airport;
				if (Number(airport.latitude) > maxLatitude && Number(airport.latitude) < 90){
					maxLatitude=Number(airport.latitude); 
				}
				if (Number(airport.latitude) < minLatitude){
					minLatitude=Number(airport.latitude);
				}
				
				if (Number(airport.longitude) > maxLongitude && Number(airport.longitude) < 0){
					maxLongitude=Number(airport.longitude); 
				}
				if (Number(airport.longitude) < minLongitude){
					minLongitude=Number(airport.longitude);
				}
			}
			
			var centerLat:Number = (maxLatitude + minLatitude)/2;
			var centerLng:Number = (maxLongitude + minLongitude)/2;
			
			var latlngBounds:LatLngBounds = new LatLngBounds(new LatLng(minLatitude, minLongitude), new LatLng(maxLatitude, maxLongitude));
			var zoomlevel:Number = _map.getBoundsZoomLevel(latlngBounds);
			if (zoomlevel < 3)zoomlevel  =3;
			if (zoomlevel >= 16) zoomlevel -= 4;
			_map.setZoom(zoomlevel);
			_map.setCenter(new LatLng(centerLat, centerLng));
		}
		
		//		public function toggleWeatherIcons(showWeatherIcons:Boolean):void{
		//			if (showWeatherIcons && _weatherMarkerArray.length == 0){
		//				
		//				for (var i:int=0; i < _markerArray.length; i++){
		//					var marker:Marker = _markerArray.getItemAt(i) as ClusterableMarker;			
		//					if (marker is AirportMarker){
		//						var airport:Airport = (marker as AirportMarker).airport;
		//						var latlng:LatLng = new LatLng( Number(airport.latitude), Number(airport.longitude));
		//						
		//						var weatherMarker:Marker = new Marker(latlng, new MarkerOptions({
		//							icon: new WeatherWindIcon(Number(airport.celcius_temperature), Number(airport.wind_degrees), 
		//								Number(airport.wind_mph)
		//								
		//							),				
		//							distanceScaling: true,
		//							hasShadow: true
		//						}));
		//						_weatherMarkerArray.addItem(weatherMarker);
		//						_map.addOverlay(weatherMarker);						
		//					}
		//				}
		//			}else{
		//				for (i=0; i < _weatherMarkerArray.length; i++){
		//					marker = _weatherMarkerArray.getItemAt(i) as Marker;
		//					marker.visible = showWeatherIcons;
		//				}
		//			}
		//		}
	}
}