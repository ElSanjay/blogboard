module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user, :uuid


    def connect

      if !env['warden'].user
        self.uuid = SecureRandom.urlsafe_base64
      else
        self.current_user = find_verified_user
      end
      # logger.add_tags 'ActionCable', current_user.email
    end

    protected

    def find_verified_user # this checks whether a user is authenticated with devise

      if verified_user = env['warden'].user

        verified_user
      else

        reject_unauthorized_connection
      end
    end
  # end

  # class Connection < ActionCable::Connection::Base
  #    identified_by :current_user, :uuid
  #
  #    def connect
  #      self.uuid = SecureRandom.urlsafe_base64
  #    end
   end
end
