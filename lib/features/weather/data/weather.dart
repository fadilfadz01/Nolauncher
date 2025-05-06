class WeatherResponse {
  List<CurrentCondition> currentCondition;
  List<NearestArea> nearestArea;
  List<Request> request;
  List<Weather> weather;

  WeatherResponse({
    required this.currentCondition,
    required this.nearestArea,
    required this.request,
    required this.weather,
  });

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    return WeatherResponse(
      currentCondition:
          (json['current_condition'] as List)
              .map((e) => CurrentCondition.fromJson(e))
              .toList(),
      nearestArea:
          (json['nearest_area'] as List)
              .map((e) => NearestArea.fromJson(e))
              .toList(),
      request:
          (json['request'] as List).map((e) => Request.fromJson(e)).toList(),
      weather:
          (json['weather'] as List).map((e) => Weather.fromJson(e)).toList(),
    );
  }
}

class CurrentCondition {
  String feelsLikeC;
  String feelsLikeF;
  String cloudcover;
  String humidity;
  String localObsDateTime;
  String observationTime;
  String precipInches;
  String precipMM;
  String pressure;
  String pressureInches;
  String tempC;
  String tempF;
  String uvIndex;
  String visibility;
  String visibilityMiles;
  String weatherCode;
  List<WeatherText> weatherDesc;
  List<WeatherText> weatherIconUrl;
  String winddir16Point;
  String winddirDegree;
  String windspeedKmph;
  String windspeedMiles;

  CurrentCondition({
    required this.feelsLikeC,
    required this.feelsLikeF,
    required this.cloudcover,
    required this.humidity,
    required this.localObsDateTime,
    required this.observationTime,
    required this.precipInches,
    required this.precipMM,
    required this.pressure,
    required this.pressureInches,
    required this.tempC,
    required this.tempF,
    required this.uvIndex,
    required this.visibility,
    required this.visibilityMiles,
    required this.weatherCode,
    required this.weatherDesc,
    required this.weatherIconUrl,
    required this.winddir16Point,
    required this.winddirDegree,
    required this.windspeedKmph,
    required this.windspeedMiles,
  });

  factory CurrentCondition.fromJson(Map<String, dynamic> json) {
    return CurrentCondition(
      feelsLikeC: json['FeelsLikeC'],
      feelsLikeF: json['FeelsLikeF'],
      cloudcover: json['cloudcover'],
      humidity: json['humidity'],
      localObsDateTime: json['localObsDateTime'],
      observationTime: json['observation_time'],
      precipInches: json['precipInches'],
      precipMM: json['precipMM'],
      pressure: json['pressure'],
      pressureInches: json['pressureInches'],
      tempC: json['temp_C'],
      tempF: json['temp_F'],
      uvIndex: json['uvIndex'],
      visibility: json['visibility'],
      visibilityMiles: json['visibilityMiles'],
      weatherCode: json['weatherCode'],
      weatherDesc:
          (json['weatherDesc'] as List)
              .map((e) => WeatherText.fromJson(e))
              .toList(),
      weatherIconUrl:
          (json['weatherIconUrl'] as List)
              .map((e) => WeatherText.fromJson(e))
              .toList(),
      winddir16Point: json['winddir16Point'],
      winddirDegree: json['winddirDegree'],
      windspeedKmph: json['windspeedKmph'],
      windspeedMiles: json['windspeedMiles'],
    );
  }
}

class NearestArea {
  List<WeatherText> areaName;
  List<WeatherText> country;
  String latitude;
  String longitude;
  String population;
  List<WeatherText> region;
  List<WeatherText> weatherUrl;

  NearestArea({
    required this.areaName,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.population,
    required this.region,
    required this.weatherUrl,
  });

  factory NearestArea.fromJson(Map<String, dynamic> json) {
    return NearestArea(
      areaName:
          (json['areaName'] as List)
              .map((e) => WeatherText.fromJson(e))
              .toList(),
      country:
          (json['country'] as List)
              .map((e) => WeatherText.fromJson(e))
              .toList(),
      latitude: json['latitude'],
      longitude: json['longitude'],
      population: json['population'],
      region:
          (json['region'] as List).map((e) => WeatherText.fromJson(e)).toList(),
      weatherUrl:
          (json['weatherUrl'] as List)
              .map((e) => WeatherText.fromJson(e))
              .toList(),
    );
  }
}

class Request {
  String query;
  String type;

  Request({required this.query, required this.type});

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(query: json['query'], type: json['type']);
  }
}

class Weather {
  List<Astronomy> astronomy;
  String avgtempC;
  String avgtempF;
  String date;
  List<Hourly> hourly;
  String maxtempC;
  String maxtempF;
  String mintempC;
  String mintempF;
  String sunHour;
  String totalSnowCm;
  String uvIndex;

  Weather({
    required this.astronomy,
    required this.avgtempC,
    required this.avgtempF,
    required this.date,
    required this.hourly,
    required this.maxtempC,
    required this.maxtempF,
    required this.mintempC,
    required this.mintempF,
    required this.sunHour,
    required this.totalSnowCm,
    required this.uvIndex,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      astronomy:
          (json['astronomy'] as List)
              .map((e) => Astronomy.fromJson(e))
              .toList(),
      avgtempC: json['avgtempC'],
      avgtempF: json['avgtempF'],
      date: json['date'],
      hourly: (json['hourly'] as List).map((e) => Hourly.fromJson(e)).toList(),
      maxtempC: json['maxtempC'],
      maxtempF: json['maxtempF'],
      mintempC: json['mintempC'],
      mintempF: json['mintempF'],
      sunHour: json['sunHour'],
      totalSnowCm: json['totalSnow_cm'],
      uvIndex: json['uvIndex'],
    );
  }
}

class Astronomy {
  String moonIllumination;
  String moonPhase;
  String moonrise;
  String moonset;
  String sunrise;
  String sunset;

  Astronomy({
    required this.moonIllumination,
    required this.moonPhase,
    required this.moonrise,
    required this.moonset,
    required this.sunrise,
    required this.sunset,
  });

  factory Astronomy.fromJson(Map<String, dynamic> json) {
    return Astronomy(
      moonIllumination: json['moon_illumination'],
      moonPhase: json['moon_phase'],
      moonrise: json['moonrise'],
      moonset: json['moonset'],
      sunrise: json['sunrise'],
      sunset: json['sunset'],
    );
  }
}

class Hourly {
  String time;
  String tempC;
  String tempF;
  String weatherCode;
  List<WeatherText> weatherDesc;
  List<WeatherText> weatherIconUrl;
  String windspeedMiles;
  String windspeedKmph;
  String winddirDegree;
  String winddir16Point;
  String weatherCodeText;
  String precipMM;
  String precipInches;
  String humidity;
  String visibility;
  String visibilityMiles;
  String pressure;
  String pressureInches;
  String cloudcover;
  String heatIndexC;
  String heatIndexF;
  String dewPointC;
  String dewPointF;
  String windChillC;
  String windChillF;
  String windGustKmph;
  String windGustMiles;
  String feelsLikeC;
  String feelsLikeF;
  String chanceofrain;
  String chanceofremdry;
  String chanceofwindy;
  String chanceofovercast;
  String chanceofsunshine;
  String chanceoffrost;
  String chanceofhightemp;
  String chanceoffog;
  String chanceofsnow;
  String chanceofthunder;
  String uvIndex;
  String shortRad;
  String diffRad;

  Hourly({
    required this.time,
    required this.tempC,
    required this.tempF,
    required this.weatherCode,
    required this.weatherDesc,
    required this.weatherIconUrl,
    required this.windspeedMiles,
    required this.windspeedKmph,
    required this.winddirDegree,
    required this.winddir16Point,
    required this.weatherCodeText,
    required this.precipMM,
    required this.precipInches,
    required this.humidity,
    required this.visibility,
    required this.visibilityMiles,
    required this.pressure,
    required this.pressureInches,
    required this.cloudcover,
    required this.heatIndexC,
    required this.heatIndexF,
    required this.dewPointC,
    required this.dewPointF,
    required this.windChillC,
    required this.windChillF,
    required this.windGustKmph,
    required this.windGustMiles,
    required this.feelsLikeC,
    required this.feelsLikeF,
    required this.chanceofrain,
    required this.chanceofremdry,
    required this.chanceofwindy,
    required this.chanceofovercast,
    required this.chanceofsunshine,
    required this.chanceoffrost,
    required this.chanceofhightemp,
    required this.chanceoffog,
    required this.chanceofsnow,
    required this.chanceofthunder,
    required this.uvIndex,
    required this.shortRad,
    required this.diffRad,
  });

  factory Hourly.fromJson(Map<String, dynamic> json) {
    return Hourly(
      time: json['time'],
      tempC: json['tempC'],
      tempF: json['tempF'],
      weatherCode: json['weatherCode'],
      weatherDesc:
          (json['weatherDesc'] as List)
              .map((e) => WeatherText.fromJson(e))
              .toList(),
      weatherIconUrl:
          (json['weatherIconUrl'] as List)
              .map((e) => WeatherText.fromJson(e))
              .toList(),
      windspeedMiles: json['windspeedMiles'],
      windspeedKmph: json['windspeedKmph'],
      winddirDegree: json['winddirDegree'],
      winddir16Point: json['winddir16Point'],
      weatherCodeText: json['weatherCode'],
      precipMM: json['precipMM'],
      precipInches: json['precipInches'],
      humidity: json['humidity'],
      visibility: json['visibility'],
      visibilityMiles: json['visibilityMiles'],
      pressure: json['pressure'],
      pressureInches: json['pressureInches'],
      cloudcover: json['cloudcover'],
      heatIndexC: json['HeatIndexC'],
      heatIndexF: json['HeatIndexF'],
      dewPointC: json['DewPointC'],
      dewPointF: json['DewPointF'],
      windChillC: json['WindChillC'],
      windChillF: json['WindChillF'],
      windGustKmph: json['WindGustKmph'],
      windGustMiles: json['WindGustMiles'],
      feelsLikeC: json['FeelsLikeC'],
      feelsLikeF: json['FeelsLikeF'],
      chanceofrain: json['chanceofrain'],
      chanceofremdry: json['chanceofremdry'],
      chanceofwindy: json['chanceofwindy'],
      chanceofovercast: json['chanceofovercast'],
      chanceofsunshine: json['chanceofsunshine'],
      chanceoffrost: json['chanceoffrost'],
      chanceofhightemp: json['chanceofhightemp'],
      chanceoffog: json['chanceoffog'],
      chanceofsnow: json['chanceofsnow'],
      chanceofthunder: json['chanceofthunder'],
      uvIndex: json['uvIndex'],
      shortRad: json['shortRad'],
      diffRad: json['diffRad'],
    );
  }
}

class WeatherText {
  String value;

  WeatherText({required this.value});

  factory WeatherText.fromJson(Map<String, dynamic> json) {
    return WeatherText(value: json['value']);
  }
}
