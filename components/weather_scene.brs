function init()
    ? "[weather_scene] init"
    ' m.top.backgroundURI = ""
    ' m.top.backgroundColor = "0xFFFFFF"
    m.center_square = m.top.findNode("category_screen")
    m.center_square.setFocus(true)
end function

function onKeyEvent(key, press) as Boolean
    ? "[home_scene] onKeyEvent", key, press
  return false
end function