package helpers

import views.html.helper._

/**
 * Contains template helpers, for example for generating HTML forms.
 */
package object infiniteWall {

	/**
	 * Twitter bootstrap input structure.
	 *
	 * {{{
	 * <dl>
	 *   <dt><label for="username"></dt>
	 *   <dd><input type="text" name="username" id="username"></dd>
	 *   <dd class="error">This field is required!</dd>
	 *   <dd class="info">Required field.</dd>
	 * </dl>
	 * }}}
	 */
	import views._

	implicit val twitterBootstrapField = new FieldConstructor {
		def apply(elements: FieldElements) = views.html.forms.defaultFieldConstructor(elements)
	}

}