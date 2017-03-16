require 'rails_helper'

RSpec.describe UserNotifier, :type => :mailer do
  describe 'new_vote' do
    let(:author) {
      User.create(
        uid:  'null|12345',
        name: 'Bob',
        email: 'bob@bob.com'
      )
    }

    let(:voter) {
      User.create(
        uid:  'null|23456',
        name: 'Dave',
        email: 'dave@dave.com'
      )
    }

    let(:movie) {
      Movie.create(
        title:        'This Is Spinal Tap',
        description:  'This one goes up to 11',
        date:         '1984-02-13',
        user:         author
      )
    }

    let(:vote) { :like }

    let(:mail) do
      described_class.new_vote(
        movie: movie,
        voter: voter,
        vote: vote
      ).deliver!
    end

    describe "email properties" do
      specify { expect(mail.subject).to eq 'New vote on This Is Spinal Tap' }
      specify { expect(mail.to).to eq ['bob@bob.com'] }
      specify { expect(mail.from).to eq ['info@movierama.dev'] }

      specify do
        expect(mail.body.encoded).to match(
          "Your movie 'This Is Spinal Tap' just received a vote from Dave"
        )
      end
    end

    describe "likes/hates" do
      context "likes" do
        specify { expect(mail.body.encoded).to match("They liked it!") }
      end

      context "hates" do
        let(:vote) { :hate }

        specify { expect(mail.body.encoded).to match("They hated it!") }
      end
    end

    describe "no email address for author" do
      let(:author) { User.create( uid:  'null|12345', name: 'Bob') }

      specify { expect(mail).to be_nil }
    end
  end
end
