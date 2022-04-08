function init() as void
  ' get references to interface
  m.itemImage = m.top.findNode("itemImage") 
  m.itemText = m.top.findNode("itemText")
end function

function itemContentChanged() as void
  ' populate with the data from the JSON when it gets parsed in RegionList
  itemData = m.top.itemContent
  m.itemImage.uri = itemData.posterUrl
  m.itemText.text = itemData.labelText
end function

' By Evan Rafuse 2022