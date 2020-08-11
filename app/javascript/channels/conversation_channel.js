
import consumer from "./consumer"


  $(window).on('load', function(){
  const room_element = document.getElementById('conversation-id');
  if (room_element!=null)
    {
      const conversation_id = room_element.getAttribute('data-conversation-id');
    
        console.log(consumer.subscriptions)
    
        consumer.subscriptions.subscriptions.forEach((subscription) => {
          consumer.subscriptions.remove(subscription)
        })
      
        subscribeAllConversations(conversation_id)

        // consumer.subscriptions.create({ channel: "ConversationChannel", id: conversation_id }, {
        //   connected() {
        //     console.log("connected to " + conversation_id)
        //     // Called when the subscription is ready for use on the server
        //   },
    
        //   disconnected(data) {
        //     console.log("disconnected to " + conversation_id)
        //     // Called when the subscription has been terminated by the server
        //   },
    
        //   received(data) {
    
        //     const user_element = document.getElementById('user-id');
        //     const user_id = user_element.getAttribute('data-user-id');
    
        //     let html;
        //     if (user_id === data.message.sender_id.$oid) {
        //       html = data.me
        //     } else { 
        //       console.log("Notification sent")
        //       new Notification(data.sender_name, {body: data.message.content, icon: data.sender_image  })
        //       html = data.theirs
        //     }
        //     $(`#conversation_${data.message.conversation_id.$oid}`).html(data.recent)
        //     var messageContainer = document.getElementsByClassName('msg_history')[0]
        //     messageContainer.innerHTML = messageContainer.innerHTML + html
    
    
    
        //   }
        // });
    }
})


function subscribeAllConversations(unexpect){
    const con_element = document.getElementById('conversation-ids');
    const conversation_ids = con_element.getAttribute('data-conversation-ids');
    const conversations = conversation_ids.split(',')
    $(conversations).filter(function( index ){

          var conversation_id = this

          consumer.subscriptions.create({ channel: "ConversationChannel", id: conversation_id }, {
          connected() {
            console.log("connected to " + conversation_id)
            
          },
    
          disconnected(data) {
            console.log("disconnected to " + conversation_id)
            // Called when the subscription has been terminated by the server
          },
    
          received(data) {
    
            const user_element = document.getElementById('user-id');
            const user_id = user_element.getAttribute('data-user-id');
    
            let html;
            if (user_id === data.message.sender_id.$oid) {
              html = data.me
            } else { 
              console.log("Notification sent")
              new Notification(data.sender_name, {body: data.message.content, icon: data.sender_image  })
              html = data.theirs
            }
              $(`#conversation_${data.message.conversation_id.$oid}`).html(data.recent)
              var messageContainer = document.getElementById(`conversations-${data.message.conversation_id.$oid}`)
              messageContainer.innerHTML = messageContainer.innerHTML + html
          
    
    
    
          }
        });

   })
}


