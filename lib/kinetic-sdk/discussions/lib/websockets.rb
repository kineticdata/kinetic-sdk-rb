require 'kontena-websocket-client'

################################################################################
#
# NOTE: All of the Discussion Web Socket methods are experimental.
#
# Websocket status codes
# https://developer.mozilla.org/en-US/docs/Web/API/CloseEvent#Status_codes
# 
################################################################################

module KineticSdk
  class Discussions

    # Subscribes an existing user or invited user to the specified discussion.
    #
    # @param discussion_id [String] id of the discussion to subscribe the person to
    # @param invitation_token [String] UUID of the invitation user token, 
    #     nil for an existing user
    def subscribe(discussion_id, invitation_token=nil)
      ws_client(join_msg(discussion_id, invitation_token))
    end


    private

    def identify_msg
      {
        "action": "identify",
        "payload": { "token": @jwt },
        "ref": "identify-ref",
        "topic": "topichub"
      }.to_json
    end

    def join_msg(discussion_id, invitation_token)
      {
        "action": "subscribe",
        "payload": {
          "topic": "discussions/discussion/#{discussion_id}",
          "userInvitationToken": invitation_token
        },
        "ref": "subscription-ref",
        "topic": "topichub"
      }.to_json
    end


    def ws_writer(ws, msg)
      info("Websocket send message: #{msg}")
      ws.send(msg)
    end

    def ws_reader(ws, send_msg=nil)
      ws.read do |msg|
        info("Websocket read: #{msg}")
        o = JSON.parse(msg)
        if ("error$".match(o['event']))
          info("Websocket failure: #{o['payload']}")
        elsif (o['event'] == "participant:updated")
          info("Websocket close: EOF")
          ws.close(1000, "EOF")
          break
        else
          unless send_msg.nil?
            ws_writer(ws, send_msg)
            send_msg = nil
          end
        end
      end
    end

    def ws_client(message)
      write_thread = nil
      info("Websocket connecting to #{@topics_ws_server}")
      Kontena::Websocket::Client.connect(@topics_ws_server) do |ws|
        info("Websocket connected to #{ws.url}")
        write_thread = Thread.new {
          ws_writer(ws, identify_msg())
        }
        ws_reader(ws, message)
        info("Websocket client closed connection with code #{ws.close_code}: #{ws.close_reason}")
      end
    rescue Kontena::Websocket::CloseError => e
      info(e)
    rescue Kontena::Websocket::Error => e
      info(e)
    ensure
      if write_thread
        write_thread.kill
        write_thread.join
      end
    end

  end
end
