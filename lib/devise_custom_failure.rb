class DeviseCustomFailure < Devise::FailureApp
  def redirect_url
    return registrar_login_url if request.original_fullpath.to_s.match(/^\/registrar/)
    return admin_login_url if request.original_fullpath.to_s.match(/^\/admin/)
    root_url
  end

  # You need to override respond to eliminate recall
  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end