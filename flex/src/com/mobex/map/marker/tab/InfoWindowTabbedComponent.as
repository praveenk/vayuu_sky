/*
* Copyright 2008 Google Inc. 
* Licensed under the Apache License, Version 2.0:
*  http://www.apache.org/licenses/LICENSE-2.0
*/
package com.mobex.map.marker.tab{
	
	import com.google.maps.LatLng;
	import com.google.maps.Map;
	import com.google.maps.MapEvent;
	import com.google.maps.MapOptions;
	import com.google.maps.MapType;
	import com.google.maps.controls.ControlPosition;
	import com.google.maps.controls.ZoomControl;
	import com.google.maps.controls.ZoomControlOptions;
	import com.google.maps.geom.Attitude;
	import com.mobex.application.framework.ApplicationContext;
	
	import flash.events.Event;
	
	import flashx.textLayout.formats.VerticalAlign;
	
	import model.Airport;
	
	import mx.containers.Canvas;
	import mx.containers.Grid;
	import mx.containers.GridItem;
	import mx.containers.GridRow;
	import mx.containers.TabNavigator;
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.controls.Image;
	import mx.controls.Text;
	import mx.controls.TextArea;
	import mx.core.UIComponent;
	import mx.events.IndexChangedEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.mxml.HTTPService;
	
	import spark.components.BorderContainer;
	import spark.components.HGroup;
	import spark.components.VGroup;
	
	/**
	 * InfoWindowSprite consists of several ellipses arranged in a 'thought bubble'
	 * manner, the largest of which contains an embedded image and a circular
	 * close button.
	 * It can dispatch an Event instance (type: "close"), which the user can listen
	 * for and use to call map.closeInfoWindow();
	 */
	public class InfoWindowTabbedComponent extends UIComponent {
		private var tabNavigator:TabNavigator;
		private var satellitePanel:VBox;
		private var technicalsPanel:VBox;
		private var weatherInfoPanel:VBox;
		private var airport:Airport;
		private var weatherDataCollected:Boolean = false;
		
		public function InfoWindowTabbedComponent(airport:Airport) {
			// Add body text
			this.airport = airport;
			tabNavigator = new TabNavigator();
			tabNavigator.width = 300;
			tabNavigator.height = 270;
			
			satellitePanel = createTab("Satellite", "");
			technicalsPanel = createTab("Technicals", "");
			weatherInfoPanel = createTab("Weather", "");
			
			getAirportInfo(airport);
			
			tabNavigator.addChild(satellitePanel);	
			tabNavigator.addChild(technicalsPanel);
			tabNavigator.addChild(weatherInfoPanel);
			
			tabNavigator.addEventListener(IndexChangedEvent.CHANGE, tabClick);
			addChild(tabNavigator);
			
			cacheAsBitmap = true;
		}
		
		public function init():void{
			tabNavigator.selectedIndex = 0;
		}
		
		private function populateAirportData(grid:HGroup):void{
			
			var lbl:VGroup = new VGroup();
			var val:VGroup = new VGroup();
			lbl.gap = -1;
			val.gap = -1;
			
			lbl.addElement(getGridItem("Airport Code: ", true));
			val.addElement(getGridItem(airport.airportId));
			lbl.addElement(getGridItem("Name: ", true));
			val.addElement(getGridItem(airport.name));
			
			lbl.addElement(getGridItem("City, State: ", true));
			val.addElement(getGridItem(airport.city + ", " + airport.stateId));
			
			lbl.addElement(getGridItem("Airport Type: ", true));
			val.addElement(getGridItem(airport.airportType));
			
			lbl.addElement(getGridItem("Phone: ", true));
			val.addElement(getGridItem(airport.managerPh));
			
			lbl.addElement(getGridItem("Elevation: ", true));
			val.addElement(getGridItem(airport.airportElev));
			
			lbl.addElement(getGridItem("Fuel Types: ", true));
			val.addElement(getGridItem(airport.fuelTypes));
			
			lbl.addElement(getGridItem("Ownership: ", true));
			val.addElement(getGridItem(airport.airportOwnership));
			
			lbl.addElement(getGridItem("Logitude: ", true));
			val.addElement(getGridItem(airport.longitude));
			
			lbl.addElement(getGridItem("Latitude: ", true));
			val.addElement(getGridItem(airport.latitude));
			
			grid.addElement(lbl);
			grid.addElement(val);
			
		}
		
		private function getGridItem(text:String, isBold:Boolean=false):Text{
			var label:Text =  new Text();
			if (isBold){
				label.styleName = "infoWindowHeading";				
			}
//			else{
//				label.htmlText = text;
//			}
			label.text = text;
			label.width = label.textWidth;
			//label.height = 13;
			return label;
		}
		
		private function populateWeatherData(grid:HGroup):void{
			var lbl:VGroup = new VGroup();
			var val:VGroup = new VGroup();
			lbl.gap = 0;
			val.gap = 0;
			
			lbl.addElement(getGridItem("Weather Condition: ", true));
			val.addElement(getGridItem(airport.weather));
			lbl.addElement(getGridItem("Temperature: ", true));
			val.addElement(getGridItem(airport.temperature_string));
			
			lbl.addElement(getGridItem("Relative Humidity: ", true));
			val.addElement(getGridItem(airport.relative_humidity));
			
			lbl.addElement(getGridItem("Wind Direction: ", true));
			val.addElement(getGridItem(airport.wind_dir));
			
			lbl.addElement(getGridItem("Wind Speed: ", true));
			val.addElement(getGridItem(airport.wind_mph));
			
			grid.addElement(lbl);
			grid.addElement(val);
		}
		
		
		private function tabClick(event:Event):void{
			var tabNavigator:TabNavigator = TabNavigator(event.target);
			if (tabNavigator.selectedChild == weatherInfoPanel){
				var innerContainer:Canvas = Canvas(weatherInfoPanel.getChildByName("innerContainer"));
				var innerGrid:HGroup = HGroup(innerContainer.getChildByName("innerGrid"));
				
				if (!weatherDataCollected){
					getWeatherData(airport);
					weatherDataCollected = true;
				}
			}
		}
		
		public function getAirportInfo(airport:Airport):void{
			var latlng:LatLng = new LatLng(Number(airport.latitude), Number(airport.longitude));
			var miniMap:Map = new Map();
			
			miniMap.key = ApplicationContext.gmapKey;
			miniMap.width = 297;
			miniMap.height = 240;
			miniMap.addEventListener(MapEvent.MAP_READY, miniMapReady);
			satellitePanel.addChildAt(miniMap, 0);
			
			var imageContainer:Canvas = new Canvas();
			imageContainer.percentWidth = 100;
			
			var image:Image = new Image();
			image.horizontalCenter = 0;
			image.source = 	"http://maps.google.com/staticmap?center=" + latlng.toUrlValue(6)  + "&zoom=16&maptype=satellite&size=220x130&key="+ApplicationContext.gmapKey
			imageContainer.addElement(image);
			
			technicalsPanel.addChildAt(imageContainer, 0);
			
			airportInfoResponseHandler(null);
		}
		
		private function miniMapReady(event:MapEvent):void{
			var latlng:LatLng = new LatLng(Number(airport.latitude), Number(airport.longitude));
			var map:Map = event.target as Map;
			map.setCenter(latlng);
			map.setZoom(13);
			map.setMapType(MapType.SATELLITE_MAP_TYPE);
			var myMapOptions:MapOptions = new MapOptions();
			//			myMapOptions.zoom = 13;
			//			myMapOptions.center = latlng;
			
			myMapOptions.attitude = new Attitude(0, 30, 0);
			var zoomOptions:ZoomControlOptions = new ZoomControlOptions();
			zoomOptions.hasScrollTrack = false;
			zoomOptions.position = new ControlPosition(ControlPosition.ANCHOR_TOP_LEFT, 5, 5);
			map.setInitOptions(myMapOptions);
			map.addControl(new ZoomControl(zoomOptions));
			map.enableContinuousZoom();
		}
		
		
		
		private function airportInfoResponseHandler(event:ResultEvent):void
		{	
			//			var rawData:String = String(event.result);
			//			var response:Array = JSON.decode(rawData);
			var innerContainer:Canvas = Canvas(technicalsPanel.getChildByName("innerContainer"));
			var innerGrid:HGroup = HGroup(innerContainer.getChildByName("innerGrid"));
			
			populateAirportData(innerGrid);
			//				insideHTML.htmlText = airportInfo;
			
		}
		
		public function getWeatherData(airport:Airport):void{
			var service:HTTPService = new HTTPService();
			service.url = ApplicationContext.instance.currentWeatherApiURL + "?query="+airport.airportId;
			service.method ="GET";
			
			service.addEventListener("result", httpResult);
			service.addEventListener("fault", httpFault);
			
			service.send();
		}
		
		public function httpResult(event:ResultEvent):void {
			var result:Object = event.result;
			var airportId:String = result.current_observation.station_id;
			
			airport.weather = result.current_observation.weather;
			airport.temperature_string = result.current_observation.temperature_string;
			airport.celcius_temperature = result.current_observation.temp_c;
			
			airport.relative_humidity = result.current_observation.relative_humidity;
			airport.wind_dir = result.current_observation.wind_dir;
			airport.wind_degrees = result.current_observation.wind_degrees;
			airport.wind_mph = result.current_observation.wind_mph;
			
			var imageContainer:Canvas = new Canvas();
			imageContainer.percentWidth = 100;
			var image:Image = new Image();
			
			image.source = "assets/"+airport.weather_icon+".gif";
			image.width = 50;
			image.height = 50;
			imageContainer.addElement(image);
			weatherInfoPanel.addElementAt(imageContainer, 0);
			//			weatherInfoPanel.addChildAt(imageContainer, 0);
			
			//			var insideHTML:TextArea = TextArea(weatherInfoPanel.getChildByName("insideHTML"));
			//			insideHTML.htmlText = weatherInfo;
			var innerContainer:Canvas = Canvas(weatherInfoPanel.getChildByName("innerContainer"));
			var innerGrid:HGroup = HGroup(innerContainer.getChildByName("innerGrid"));
			
			populateWeatherData(innerGrid);
		}
		
		
		public function httpFault(event:FaultEvent):void {
			var faultstring:String = event.fault.faultString;
			Alert.show(faultstring);
		}
		
		public function createTab(label:String, text:String):VBox {
			var container:VBox = new VBox();
			container.label = label;
			container.verticalScrollPolicy = "off";
			
			var innerContainer:Canvas = new Canvas();
			
			innerContainer.name = "innerContainer";
			
			innerContainer.verticalScrollPolicy = "auto";
			innerContainer.horizontalScrollPolicy = "off";
			
			var grid:HGroup = new HGroup();
			//grid.horizontalCenter = 0;
			grid.requestedColumnCount = 2;
			grid.horizontalAlign = "left";
			grid.paddingLeft = 7;
			
			innerContainer.percentWidth = 97;
			innerContainer.height = 100;
			grid.name = "innerGrid";
						
			innerContainer.addChild(grid);
			container.addChild(innerContainer);
			innerContainer.horizontalCenter = 0;
			
			return container;
		}
		
	}
}