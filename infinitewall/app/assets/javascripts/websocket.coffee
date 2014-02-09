# required for extending:
# @timestamp
# @url
# @scope

# states: CONNECTED <=> TRYING
define ["EventDispatcher", "jquery"], (EventDispatcher, $) ->

  # get websocket url adjusted to current viewing protocol (http->ws/https->wss)
  websocketURLAdjusted = (url) ->
    if location.protocol == "https:"
      protocol = "wss:"
    else
      protocol = "ws:"

    if url.match(/^wss:\/\//)? or url.match(/^ws:\/\//)?
      url = url.replace(/^(wss|ws):\/\//,  protocol + "//")
    else
      url = protocol + "//" + url

    url


  class PersistentWebsocket extends EventDispatcher
    
    constructor: (@url, scope = "WS", @timestamp) ->
      super()
      @WS = if window['MozWebSocket'] then MozWebSocket else window['WebSocket']
      @status = "TRYING"
      @numRetry = 0
      @scope = "[#{scope}]"
      @buffered = [] # emergency buffer
      @pending = []

      @url = websocketURLAdjusted(@url)

      if @WS?
      	@connect()
      else
        setTimeout (() => @trigger('close')), 0

    isConnected:() ->
      @status == "CONNECTED"

    withTimestamp:() =>
      if @url.indexOf('?') != -1
        "&timestamp=#{@timestamp}"
      else
        "?timestamp=#{@timestamp}"

    connect: ()=>
      console.info(@scope, "Retrying to connect... ", @numRetry, "ts: #{@timestamp}") if @numRetry > 0 
      @socket = new @WS(@url + if @timestamp? then @withTimestamp() else "")
      @socket.onopen = @onOpen
      @socket.onerror = @onError
      @socket.onclose = @onClose

    send: (msg) ->
      console.info(@scope, "sending #{msg.length} characters", msg)
      @socket.send(msg)

    close: ()->
      @socket.close()


    # @override
    onReceive: (e) =>
      data = JSON.parse(e.data)
      #console.log(@scope, data)
      @trigger('receive', data)

    onOpen: (e) =>
      @socket.onmessage = @onReceive
      console.info(@scope, "connection established: ", e)
      @trigger('open', e)
      @status = "CONNECTED"
      @numRetry = 0
        

    onClose: (e) =>
      @status = "TRYING"
      @socket.onclose = null
      @socket.onopen = null
      @socket.onmessage = null
      @socket.onerror = null

      setTimeout(@connect, Math.pow(2, @numRetry) * 1000)
      @numRetry += 1 if @numRetry < 5
      console.warn(@scope, "connection closed: ", e, "Will retry connect")
      @trigger('close', e)

    onError: (e) =>
      if @status == "TRYING"
        console.warn(@scope, "cannot establish connnection: ", e)
      else
        console.error(@scope, "chat connection caught error: ", e)
      @trigger('error', e)
