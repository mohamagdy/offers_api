require "rails_helper"

RSpec.describe HashKeyGenerator do
  let(:klass) { Class.new(ActiveResource::Base) { include HashKeyGenerator } }

  context "hash key calculation" do
    it "calculate the hash key from params" do
      params = { b: 2, a: 1, c: 3 }
      hash_key = Digest::SHA1.hexdigest("a=1&b=2&c=3&#{Rails.application.secrets.api['key']}")

      expect(klass.new.generate_hash_key(params)).to eq(hash_key)
    end
  end
end