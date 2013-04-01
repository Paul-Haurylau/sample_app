require 'spec_helper'

describe PagesController do
  render_views

  before(:each) do
    @attr = 'Ruby on Rails Tutorial | '
  end

  describe "GET 'home'" do
    it "returns http success" do
      get 'home'
      response.should be_success
    end

    it "should have the right title" do
      get 'home'
      response.should have_selector('title',
                      content: @attr + 'Home')
    end
  end

  describe "GET 'contact'" do
    it "returns http success" do
      get 'contact'
      response.should be_success
    end

    it 'should have the right title' do
      get 'contact'
      response.should have_selector('title',
                      content: @attr + 'Contact')
    end
  end

  describe "GET 'help'" do
    it "returns http success" do
      get 'help'
      response.should be_success
    end

    it 'should have the right title' do
      get 'help'
      response.should have_selector('title',
                      content: @attr + 'Help')
    end
  end

  describe "GET 'about'" do
    it "returns http success" do
      get 'about'
      response.should be_success
    end

    it 'should return the right title' do
      get 'about'
      response.should have_selector('title',
                      content: @attr + 'About')
    end
  end

end
