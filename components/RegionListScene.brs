function init()
    ? m.top.backgroundColor
    ? "IN REGIONLISTSCENE: Initiating RegionList Secene"
    m.theRegionList = m.top.FindNode("theRegionList")
    m.loadingLabel = m.top.FindNode("loadingLabel")
    '~~~ References to weather report fields ~~~
    m.weatherReport = m.top.FindNode("weatherReport")
    m.cityLabel = m.weatherReport.FindNode("cityText")
    m.weatherIcon = m.weatherReport.FindNode("weatherImage")
    m.condLabel = m.weatherReport.FindNode("condText")
    ' Temperature
    m.feelsTempLabel = m.weatherReport.FindNode("feelsTempText")
    m.rangeTempLabel = m.weatherReport.FindNode("rangeTempText")
    ' Precipitation
    m.precipLabel = m.weatherReport.FindNode("precipText")
    ' Wind
    m.windLabel = m.weatherReport.FindNode("windText")
    m.theRegionList.SetFocus(true)
    ' Set the data in interface by default to the first city in the first row
    defaultCity = m.theRegionList.content.getChild(0).getChild(0)
    m.cityLabel["text"] = defaultCity.labelText
    ? "IN REGIONLISTSCENE: Calling to load data on default city (top left corner)"
    loadFeed(defaultCity.cityName)
    ' Watch to see which city the user is on
    m.theRegionList.ObserveField("rowItemSelected", "onRowItemSelected")
end function

' Finds the city user is on
function onRowItemSelected() as void
    m.weatherReport.visible = false
    m.loadingLabel.visible = true
    ? "IN REGIONLISTSCENE: Row Item Selected! " 
    ' Get coordinates in the rowList for which city is focused on
    row = m.theRegionList.rowItemSelected[0]
    col = m.theRegionList.rowItemSelected[1]
    ' Get reference to specific city name, get name from cityName interface
    chosenCity = m.theRegionList.content.getChild(row).getChild(col)
    cityName = chosenCity.cityName
    ? "IN REGIONLISTSCENE: City Selected -> "; cityName
    ' Show City Name and Province at top of weather report (Includes Province unlike cityName)
    m.cityLabel["text"] = chosenCity.labelText
    ' Get weather data based on cityName
    loadFeed(cityName)
end function

' Hits API for Weather Data
sub loadFeed(city)
    ' Just plug the cityname into the url to get the weather data
    url = "https://api.openweathermap.org/data/2.5/weather?q=" + city + ",CA&appid=6b8afb74e995c5015cfcfb7d0796fca2&units=metric"
    ' create the task that hits the api and run it
    ? "IN REGIONLISTSCENE: About to call API at -> "; url
    m.feed_task = createObject("roSGNode", "load_feed_task")
    m.feed_task.observeField("response", "onFeedResponse")
    m.feed_task.url = url
    m.feed_task.control = "RUN"
  end sub

' Updates interface with Weather Data when response is received
sub onFeedResponse(obj)
    ? "IN REGIONLISTSCENE: Received Response from API Call";
    ' Parse the response for weather data
    response = obj.getData()
    m.weatherData = parseJSON(response)

    ' Make sure the response is actually readable so the app doesn't crash if the api is down
    if m.weatherData <> invalid and m.weatherData["weather"] <> invalid
        ? "IN REGIONLISTSCENE: API RESPONSE VALID";
        '~~~ Add Data to weather report section ~~~
        m.weatherIcon["uri"] = "https://openweathermap.org/img/wn/" + m.weatherData["weather"][0]["icon"] + "@2x.png"
        m.condLabel["text"] = Str(Cint(m.weatherData["main"]["temp"])) + Chr(176) + "C and " + m.weatherData["weather"][0]["description"]

        ' Feels like at the top because that's what everybody actually looks for
        ' Cleaner to do a range for min and max
        feelsTemp = Str(Cint(m.weatherData["main"]["feels_like"]))
        minTemp = Str(Cint(m.weatherData["main"]["temp_min"]))
        maxTemp = Str(Cint(m.weatherData["main"]["temp_max"]))
        m.feelsTempLabel["text"] = "Feels Like: " + feelsTemp + Chr(176) + "C"
        m.rangeTempLabel["text"] = "Temp: " + minTemp + Chr(176) + "C - " + maxTemp + Chr(176) + "C"

        ' If there is no precip the JSON won't even have the fields, so check
        ' It doesn't give a 24 hour estimate, just the current 1hr forecast
        ' Extrapolating it isn't as simple as multiplying by 24, so best to just leave this hourly
        if m.weatherData["rain"] <> invalid then
            rainNumb = Str(Cint(m.weatherData["rain"]["1h"]))
            m.precipLabel["text"] = "Rain: " + rainNumb + "mm/hr"
        else if m.weatherData["snow"] <> invalid then
            snowNumb = Str(Cint(m.weatherData["snow"]["1h"]))
            m.precipLabel["text"] = "Snow: " + snowNumb + "cm/hr"
        else
            m.precipLabel["text"] = "No Precipitation"
        end if

        ' Combining the speed and direction for a cleaner interface
        ' Converting the windspeed to km/hr, default is m/s
        windSpeed = Str(Cint(m.weatherData["wind"]["speed"] * 3.6))
        ' Direction is given in degrees so this will have to be a large if statement
        windDeg = m.weatherData["wind"]["deg"]
        ' gross
        if windDeg > 338
            windDir = "North"
        else if windDeg > 315
            windDir = "North-Northwest"
        else if windDeg > 293
            windDir = "Northwest"
        else if windDeg > 271
            windDir = "West-Northwest"
        else if windDeg > 248
            windDir = "West-Southwest"
        else if windDeg > 225
            windDir = "Southwest"
        else if windDeg > 203
            windDir = "South-Southwest"
        else if windDeg > 180
            windDir = "South"
        else if windDeg > 158
            windDir = "South-Southeast"
        else if windDeg > 135
            windDir = "Southeast"
        else if windDeg > 113
            windDir = "East-Southeast"
        else if windDeg > 90
            windDir = "East"
        else if windDeg > 68
            windDir = "East-Northeast"
        else if windDeg > 45
            windDir = "Northeast"
        else
            windDir = "North-Northeast"
        end if
        m.windLabel["text"] = "Wind: " + windSpeed + " km/hr " + windDir
        ? "IN REGIONLISTSCENE: Weather Data updated!";
        m.loadingLabel.visible = false
        m.weatherReport.visible = true
    else
        ? "IN REGIONLISTSCENE: API RESPONSE INVALID, CHECK URL";
    end if

end sub

' By Evan Rafuse 2022