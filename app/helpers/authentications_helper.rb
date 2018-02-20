module AuthenticationsHelper
  class Encryptor
    def initialize
      key = Base64.decode64(ENV['KEY'])
      @encryptor = ActiveSupport::MessageEncryptor.new(key)
    end

    def encrypt(plaintext)
      @encryptor.encrypt_and_sign(plaintext)
    end

    def decrypt(encrypted_data)
      @encryptor.decrypt_and_verify(encrypted_data)
    end
  end
end
