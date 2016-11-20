package actors

import akka.actor.Actor
import akka.actor.ActorLogging
import akka.event.LoggingReceive
import play.api.libs.json.JsValue
import play.api.libs.json.Json
import akka.actor.ActorRef
import akka.actor.Props
import scala.xml.Utility

class UserActor(nick: String, board: ActorRef, out: ActorRef) extends Actor with ActorLogging {
  override def preStart() = {
    board ! Subscribe
  }

  def receive = LoggingReceive {
    case Message(nickname, s) if sender == board =>
      val js = Json.obj("type" -> "message", "nickname" -> nickname, "msg" -> s)
      out ! js
    case js: JsValue =>
      (js \ "msg").validate[String] map {
        Utility.escape
      } foreach {
        board ! Message(nick, _)
      }
    case other =>
      log.error("unhandled: " + other)
  }
}

object UserActor {
  def props(nick: String)(out: ActorRef) = Props(new UserActor(nick, BoardActor(), out))
}
