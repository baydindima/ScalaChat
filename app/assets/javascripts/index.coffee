$ ->
  $("#startchat").submit (event) ->
    event.preventDefault()

    console.log($("#address").val())
    console.log($("#nickname").val())
    #    # send the message to watch the stock
    window.location.replace(
      "http://" + window.location.hostname + ":" + window.location.port +
        "/chat?nickname=" + $("#nickname").val() + "&address=" + $("#address").val()
    )