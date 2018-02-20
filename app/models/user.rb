class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]


  def self.from_omniauth(access_token)
           data = access_token.info

           user = User.where(email: data['email']).first
           # Uncomment the section below if you want users to be created if they don't exist
          unless user
              user = User.create(
                 email: data['email'],
                 password: Devise.friendly_token[0,20]
              )
          end
           user
  end

  def update_database(api)
    self.update(data: api)
    
  end

  def update_leaderboard(board_type)
    data = {}
    self.data["reports"].first["data"]["rows"].each { |item|
      data[item["dimensions"].first]=item["metrics"].first["values"].first
    }
    case board_type

    when "mainboard"
      params = {
        name: self.name,
        score: self.data["reports"].first["data"]["totals"].first["values"].first,
        id: self.id,
        organic: data["Organic Search"],
        social: data["Social"],
        email: data["Email"],
        direct: data["Direct"],
        paid: data["Paid"]
      }
    end

    Boards::UpdateService.new.execute(params)
  end
end
