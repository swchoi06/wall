package components.contents
{
	import mx.core.IVisualElement;
	
	import spark.components.TextArea;
	import spark.events.TextOperationEvent;
	
	import storages.IXMLizable;
	
	public class TextContent extends Content implements ITextContent
	{
		protected var textarea:TextArea = new TextArea;
		
		override protected function get visualElement():IVisualElement { return textarea; }
		
		public function TextContent()
		{
			super();

			textarea.percentWidth = 100;
			textarea.percentHeight = 70;
			textarea.addEventListener(TextOperationEvent.CHANGE, function(e:TextOperationEvent):void
			{
				dispatchCommitEvent(self, "TEXT_CHANGE", [textarea.text]);
			});
		}
		
		/**
		 * 	<content>
		 * 		<text text="...">
		 * 	</content>
		 */ 
		
		override public function toXML():XML {
			var xml:XML = super.toXML();
			if(textarea.text != "") {
				var textXML:XML = <text/>;
				textXML.@text = textarea.text;
				xml.appendChild(textXML);
			}
			return xml;
		}
		
		override public function fromXML(xml:XML):IXMLizable {
			
			var textxml:XML = xml.text[0];
			textarea.text = textxml.@text;
			return this;
		}
		public function getTextData():String {
			return textarea.text;
		}
	}
}