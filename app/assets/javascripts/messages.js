$(document).ready(function () {
  $(".chat-message")[0].scrollTop =  $(".chat-message")[0].scrollHeight;

  $('body').on('click','#send-message-btn', function(event){
    var message = $('#message-to-send').val()
      if(message.trim() == ""){
          return false;
      }
      var sender_id = $('#message-data').attr('data-sender')
      var complaint_id = $('#message-data').attr('data-complaint-id')
      jQuery.ajax({
          data: {body: message, sender_id: sender_id, complaint_id: complaint_id},
          type: 'post',
          url: "/admin/complaints/" + complaint_id + "/add_message",
          //url: '/conversations/'+conversation_id+'/messages',

          success: function (data, status, xhr) {
              $('#total-chat-history').append(data);
              $('#message-to-send').val('')
              $(".chat-message")[0].scrollTop =  $(".chat-message")[0].scrollHeight;
          }
      });
  })


  $('body').on('click','.chat-user', function(event){
   	var user_id =   $(event.currentTarget).attr('data-user-id')

    jQuery.ajax({
        data: {user_id: user_id},
        type: 'get',
        url: '/conversations/chats',

        success: function (data, status, xhr) {
            $('.chat-messages').empty().append(data);
            $('.chat-user').removeClass('active')
            $(event.currentTarget).addClass('active')
            $('#message-to-send').val('')
            $(".chat-message")[0].scrollTop =  $(".chat-message")[0].scrollHeight;
            $(event.currentTarget).find('.chat-alert').addClass('hide')
            if ($('#messages-count').attr('data-badge') > 0){
              $('#messages-count').attr('data-badge', $('#messages-count').attr('data-badge') - 1)
              $('#messages-count').attr('title', $('#messages-count').attr('data-badge') + ' unread messages')
            }
        }
    });
  })

  $('body').on('click','#get-users-list', function(event){
   	var type =   $(event.currentTarget).attr('data-type')
   	alert(type)

    jQuery.ajax({
        data: {type: type},
        type: 'get',
        url: '/conversations/chats',

        success: function (data, status, xhr) {
            $('.chat-messages').empty().append(data);
            $('.chat-user').removeClass('active')
            $(event.currentTarget).addClass('active')
            $('#message-to-send').val('')
            $(".chat-message")[0].scrollTop =  $(".chat-message")[0].scrollHeight;
        }
    });
  })
})

