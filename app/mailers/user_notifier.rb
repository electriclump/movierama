class UserNotifier < ActionMailer::Base
  default from: "info@movierama.dev"

  def new_vote(movie:, voter:, vote:)
    @movie = movie
    @voter = voter
    @vote  = vote

    if @movie.user.email.present?
      mail(to: @movie.user.email, subject: "New vote on #{@movie.title}")
    end
  end
end
