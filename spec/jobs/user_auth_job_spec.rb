require 'rails_helper'

RSpec.describe UserAuthJob, type: :job do
  describe "#perfom later" do
    it "autorized user profile" do
      ActiveJob::Base.queue_adapter = :test
      expect {
        UserAuthJob.perform_later('backup')
      }.to have_enqueued_job
    end

  end
end
