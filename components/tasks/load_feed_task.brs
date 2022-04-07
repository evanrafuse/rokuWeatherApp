sub init()
  m.top.functionname = "request"
  m.top.response = ""
end sub

' Calls the API and gets the weather data
function request()
  ' get the url
  url = m.top.url
  ' create http object and give it a port
  http = createObject("roUrlTransfer")
  http.RetainBodyOnError(true)
  port = createObject("roMessagePort")
  http.setPort(port)
  ' set the cert
  http.setCertificatesFile("common:/certs/ca-bundle.crt")
  http.InitClientCertificates()
  http.enablehostverification(false)
  http.enablepeerverification(false)
  http.setUrl(url)
  ' make the call to the api
  if http.AsyncGetToString() Then
    msg = wait(10000, port)
    if (type(msg) = "roUrlEvent")
      if (msg.getresponsecode() > 0 and  msg.getresponsecode() < 400)
        ' set the response to include the received data
        ' this field will be watched in RegionListScene
        m.top.response = msg.getstring()
      else
        ? "feed load failed: "; msg.getfailurereason();" "; msg.getresponsecode();" "; m.top.url
        m.top.response = ""
      end if
      http.asynccancel()
    else if (msg = invalid)
      ' This would be sad
      ? "feed load failed."
      m.top.response =""
      http.asynccancel()
    end if
  end if
end function