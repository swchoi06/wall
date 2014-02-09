define ["sheet/textSheet", "sheet/videoSheet", "jquery"], (TextSheet, VideoSheet, $) ->
  class Menu
    constructor: ->
      @profile = $('#profilePic')
      @logoff = $('#logoutButton')
      @newSheet = $('#newSheetButton')
      @newSheetContainer = $('#newSheetContainer')
      @newSheetButtons = $('.newSheetButtons')
      @deleteSheet = $('#deleteSheetButton')
      @chat = $('#chatButton')
      @minimap = $('#minimapButton')
      @tellButton = $('#tellButton')
      @undoButton = $('#undoButton')
      @redoButton = $('#redoButton')
      @menubar = $('#menuBar')
      @menubar.on 'mousedown', (e) -> e.preventDefault()
      @menubar.css('x', 0) # ios에서 메뉴바 찌그러지는거 막음

      @newSheet.click => @newSheetContainer.slideToggle(300)
      @newSheetButtons.click ->
        switch $(this).attr('rel')
          when 'text'
            TextSheet.create("")
          when 'image'
            $("#fileupload").click()
          when 'video'
            new VideoSheet()
            console.log "videovideo"

      @deleteSheet.click =>
        #TODO link action
        stage.activeSheet.socketRemove() if stage.activeSheet
        @deactivateDelete()

      @minimap.click -> minimap.toggle()
      @chat.click -> chat.toggle()
      @tellButton.click -> stage.activeSheet.glow()
      @undoButton.click -> stage.history.undo()
      @redoButton.click -> stage.history.redo()

    activateDelete: ->
      @deleteSheet.css('background-image', 'url(/assets/images/delete_red.png)')
      
    deactivateDelete: ->
      @deleteSheet.css('background-image', 'url(/assets/images/delete_white.png)')
