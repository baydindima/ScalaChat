own_id = -1;

$ ->
  ws = new WebSocket $("body").data("ws-url")
  ws.onmessage = (event) ->
    message = JSON.parse event.data
    switch message.type
      when "message"
        $("#chatAndMessage").append("<div class=\"messageInChat\"><div class=\"messageClient\">" + "<img align='left' src=\"" + "http://" + window.location.hostname + ":" + window.location.port + "/assets/images/" + message.img + ".png" + "\" height=\"20\" width=\"20\" />" + message.nickname + ":" + message.msg + "</div></div>")
      when "info"
        own_id = message.img
      else
        console.log(message)

  $("#msgform").submit (event) ->
    event.preventDefault()
    console.log($("#msgtext").val())
    # send the message to watch the stock
    ws.send(JSON.stringify({msg: $("#msgtext").val()}))
    $("#chatAndMessage").append("<div class=\"messageInChat\"><div class=\"messageManager\">" + "<img align='left' src=\"" + "http://" + window.location.hostname + ":" + window.location.port + "/assets/images/" + own_id + ".png" + "\" height=\"20\" width=\"20\" />" + $("#nickname").text() + ":" + $("#msgtext").val() + "</div></div>")
    $.post(
      "http://" + $("#address").text() + "/message",
      {nickname: $("#nickname").text(), msg: $("#msgtext").val()}
    )
    # reset the form
    $("#msgtext").val("")