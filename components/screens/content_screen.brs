sub init()
    m.content_grid = m.top.FindNode("content_grid")
    m.header = m.top.FindNode("header")
end sub  

sub onFeedChanged(obj)
    feed = obj.getData()
    m.header.text = "Regions"
    postercontent = createObject("roSGNode","ContentNode")
    ' for  i=0 to 5 step 1
    for each region in feed.regions
        for each city in region.cities
            node = createObject("roSGNode","ContentNode")
            node.HDGRIDPOSTERURL = "pkg:/images/icon_focus_hd.jpg"
            node.SHORTDESCRIPTIONLINE1 = city.name
            postercontent.appendChild(node)
        end for
    end for
    showpostergrid(postercontent)
end sub  

sub showpostergrid(content)
  m.content_grid.content=content
  m.content_grid.visible=true
  m.content_grid.setFocus(true)
end sub