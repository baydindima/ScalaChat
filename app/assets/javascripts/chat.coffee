$ ->
  ws = new WebSocket $("body").data("ws-url")
  ws.onmessage = (event) ->
    message = JSON.parse event.data
    switch message.type
      when "message"
        $("#board tbody").append("<tr><td>" + message.nickname + "</td><td>" + message.msg + "</td></tr>")
      else
        console.log(message)

  $("#msgform").submit (event) ->
    event.preventDefault()
    console.log($("#msgtext").val())
    # send the message to watch the stock
    ws.send(JSON.stringify({msg: $("#msgtext").val()}))
    $.post(
      "http://" + $("#address").text() + "/message",
      {nickname: $("#nickname").text(), msg: $("#msgtext").val()}
    )
    # reset the form
    $("#msgtext").val("")