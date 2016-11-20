package controllers

import actors.{BoardActor, Message, UserActor}
import play.api.Logger
import play.api.Play.current
import play.api.libs.json.JsValue
import play.api.mvc.{Action, Controller, WebSocket}

import scala.concurrent.Future

object Application extends Controller {
  val Nick = "nickname"
  val Address = "address"
  val Msg = "msg"

  def index = Action { implicit request =>
    Ok(views.html.index.apply).withNewSession
  }

  def chat = Action { implicit request =>
    Ok(views.html.chat(
      request.queryString(Nick).head, request.queryString(Address).head)
    ).withSession(request.session + (Nick -> request.queryString(Nick).head))
  }

  def message = Action { implicit req =>
    val nick = req.body.asFormUrlEncoded.get.filter(_._1 == Nick).map(_._2.head).head
    val msg = req.body.asFormUrlEncoded.get.filter(_._1 == Msg).map(_._2.head).head
    BoardActor() ! Message(nick, msg)
    Ok("Success")
  }

  def ws = WebSocket.tryAcceptWithActor[JsValue, JsValue] { implicit request =>
    Future.successful(request.session.get(Nick) match {
      case None => Left(Forbidden)
      case Some(nick) => Right(UserActor.props(nick))
    })
  }

}
