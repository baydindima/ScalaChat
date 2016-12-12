package actors

import akka.actor.Actor
import akka.actor.ActorLogging
import akka.event.LoggingReceive
import akka.actor.ActorRef
import akka.actor.Terminated
import play.libs.Akka
import akka.actor.Props

class BoardActor extends Actor with ActorLogging {
  var users = Set[ActorRef]()

  def receive = LoggingReceive {
    case m: Message =>
      users foreach { user =>
        user ! m
      }
    case Subscribe =>
      users += sender
      context watch sender
    case Terminated(user) =>
      users -= user
  }
}

object BoardActor {
  lazy val board: ActorRef = Akka.system().actorOf(Props[BoardActor])
  def apply(): ActorRef = board
}

case class Message(nickname: String, userId: Int, msg: String)
object Subscribe
