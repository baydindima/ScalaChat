$ ->
  ws = new WebSocket $("body").data("ws-url")
  ws.onmessage = (event) ->
    message = JSON.parse event.data
    switch message.type
      when "message"
        $("#chatAndMessage").append("<div class=\"messageInChat\"><div class=\"messageClient\">" + message.nickname + ":" + message.msg + "</div></div>")
      else
        console.log(message)

  $("#msgform").submit (event) ->
    event.preventDefault()
    console.log($("#msgtext").val())
    # send the message to watch the stock
    ws.send(JSON.stringify({msg: $("#msgtext").val()}))
    $("#chatAndMessage").append("<div class=\"messageInChat\"><div class=\"messageManager\">" + $("#nickname").text() + ":" + $("#msgtext").val() + "</div></div>")
    $.post(
      "http://" + $("#address").text() + "/message",
      {nickname: $("#nickname").text(), msg: $("#msgtext").val()}
    )
    # reset the form
    $("#msgtext").val("")