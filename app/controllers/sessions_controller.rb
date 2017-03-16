class SessionsController < ApplicationController
  def create
    UserRegistration.new(auth_hash).tap do |ur|
      authenticate! ur.user

      if ur.created?
        flash[:notice] = "Account created"
      else
        flash[:notice] = "Welcome back"
      end

      if ur.failed?
        flash[:error] = "Couldn't find email address. Is it public?"
      end
    end
    redirect_to root_url
  end

  def destroy
    logout!
    redirect_to root_url
  end

  def update
    logout!
    redirect_to github_auth_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
