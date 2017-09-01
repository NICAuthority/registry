module Admin
  class BaseController < ApplicationController
    before_action :authenticate_user!
    helper_method :head_title_sufix

    def head_title_sufix
      t(:admin_head_title_sufix)
    end
  end
end
