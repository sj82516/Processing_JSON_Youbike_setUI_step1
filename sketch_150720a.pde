import http.requests.*;
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;

UnfoldingMap map;
String url = "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=ddb80380-f1b3-4f8e-8016-7ed9cba571d5";
PFont myFont;

void setup(){
  size(1000, 800);
  smooth();
  //載入中文字體
  myFont = createFont("標楷體",15);
  textFont(myFont);
  //map函式初始化
  map = new UnfoldingMap(this, "map");
  //地圖聚焦的經緯度以及放大程度
  map.zoomAndPanTo(new Location(25.05f, 121.55f), 13);
  MapUtils.createDefaultEventDispatcher(this, map);
  
  //第一步驟
  GetRequest get = new GetRequest(url);
  get.send();
  JSONObject response = parseJSONObject(get.getContent());
  JSONArray bikelists = response.getJSONObject("result").getJSONArray("results");
  for(int l=0;l<bikelists.size();l++){
    JSONObject bikelist = bikelists.getJSONObject(l);
    println("地點:" + bikelist.getString("sna") + "經度:" + bikelist.getString("lat") + "緯度:" + bikelist.getString("lng") + " 總車位:" +bikelist.getString("tot") + " 剩餘車位" + bikelist.getString("sbi"));
    Location _location = new Location(Float.parseFloat(bikelist.getString("lat")),Float.parseFloat(bikelist.getString("lng")));
    Station _station = new Station(_location,bikelist.getString("sna"), Integer.parseInt(bikelist.getString("tot")),Integer.parseInt(bikelist.getString("sbi")));
    //在地圖上增加標記
    map.addMarkers(_station);
  }
}

void draw(){
  map.draw();
}

void mouseMoved() {
  // Deselect all marker
  for (Marker marker : map.getMarkers()) {
    marker.setSelected(false);
  }

  // 檢查滑鼠移動位置，如果剛好移到地點上，出現設定的標籤
  Marker marker = map.getFirstHitMarker(mouseX, mouseY);
  if (marker != null) {
    println(marker.getLocation().toString());
    //利用Key(鍵)去讀值
    println(marker.getProperty("tot").toString());
    println(marker.getProperty("sbi").toString());
    marker.setSelected(true);
  }
}

