package models

import play.api.Play.current
import ContentType._
import play.api.libs.json._
import play.api.Logger
import org.apache.commons.lang.StringEscapeUtils._
import ActiveRecord._

class SheetLink(val fromSheet: Sheet, val toSheet: Sheet, var wall: Wall) extends Entity {
	def frozen = transactional {
		SheetLink.Frozen(id, fromSheet.id, toSheet.id, wall.id)
	}
}

object SheetLink extends ActiveRecord[SheetLink] {

	case class Frozen(id: String, fromId: String, toId: String, wallId: String) {
		def toJson() = {
			Json.obj(
				"id" -> id,
				"sheetId" -> fromId,
				"fromSheetId" -> fromId, // added redundancy... remove?
				"toSheetId" -> toId,
				"wall_id" -> wallId).toString()
		}
	}

	def create(fromId: String, toId: String, wallId: String) = transactional {
		val fromSheet = Sheet.findById(fromId).get
		val toSheet = Sheet.findById(toId).get
		val wall = Wall.findById(wallId).get
		new SheetLink(fromSheet, toSheet, wall).id
	}

	def remove(fromId: String, toId: String) {
		transactional {
			val fromSheet = byId[Sheet](fromId)
			val toSheet = byId[Sheet](toId)
			val entities = select[SheetLink] where (link =>
				(link.fromSheet :== fromSheet) :&& (link.toSheet :== toSheet))
			entities.map(_.delete)
		}
	}

	def findAllByWallId(wallId: String) = transactional {
		val wall = byId[Wall](wallId)
		select[SheetLink] where (_.wall :== wall)
	}

}
