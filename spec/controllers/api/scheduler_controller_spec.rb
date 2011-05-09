require File.dirname(__FILE__) + '/../../spec_helper'

describe Api::SchedulerController do
  describe "GET 'schedule'" do
    before(:each) do
      @job = Factory(:job)
      Runner.stub!(:schedule!).and_return [@job]
    end
    
    def do_get
      get 'schedule', :format => :json
    end
    
    it "should let the runner schedule" do
      Runner.should_receive(:schedule!)
      do_get
    end
    
    it "should render the jobs" do
      do_get
      response.body.should == [@job].to_json
    end
  end
end
