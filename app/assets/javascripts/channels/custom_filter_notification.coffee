App.custom_filter_notification = App.cable.subscriptions.create "CustomFilterNotificationChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel


     # $('#main-container').load window.location.href + ' #main-container'
     $('.dimmer').removeClass 'active'
     # location.reload();
     window.location.href = '/leaderboards/'+data['message']+'/custom';
