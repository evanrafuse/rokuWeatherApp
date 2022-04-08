function init()
    ? "IN REGIONLIST: Creating RowList of Regions"
    ' reference the template for row objects
    m.top.itemComponentName = "RegionListItem"
    ' define rowlist
    m.top.numRows = 2
    m.top.itemSize = [196 * 3 + 20 * 2, 213]
    m.top.rowHeights = [213]
    m.top.rowItemSize = [ [196, 213], [196, 213], [196, 213] ]
    m.top.itemSpacing = [ 0, 80 ]
    m.top.rowItemSpacing = [ [20, 0] ]
    m.top.rowLabelOffset = [ [0, 20] ]
    m.top.rowFocusAnimationStyle = "fixedFocusWrap"
    m.top.showRowLabel = [true, true]
    m.top.rowLabelColor="0xFFFFFF"
    m.top.rowLabelFont="font:MediumBoldSystemFont"
    ' Parse JSON for the city data
    m.top.content = GetRowListContent()
    ? "IN REGIONLIST: RowList Ready!"
    m.top.visible = true
    m.top.SetFocus(true)
end function

' Parses the JSON for list of regions+cities and populates rowlist
function GetRowListContent() as object
    ? "IN REGIONLIST: Retrieving Region+City data from JSON file"
    jsonAsString = ReadAsciiFile("pkg:/feed/cities.json")
    jsondata = ParseJson(jsonAsString)
    'Populate the RowList content here
    data = CreateObject("roSGNode", "ContentNode")
    for each region in jsondata.regions
        row = data.CreateChild("ContentNode")
        row.title = region.name
        for each city in region.cities
            item = row.CreateChild("RegionListItemData")
            item.posterUrl = "pkg:/images/rowImages/" + city.name + ".jpg"
            item.labelText = city.name + ", " + city.province
            item.cityName = city.name
        end for
    end for
    return data
end function
