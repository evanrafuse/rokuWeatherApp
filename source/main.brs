sub main()
    screen = createObject("roSGScreen")
    scene = screen.createScene("weather_scene")
    screen.Show()
    port = createObject("roMessagePort")
    screen.setMessagePort(m.port)
    while(true)
        ' insert code here
    end while
end sub