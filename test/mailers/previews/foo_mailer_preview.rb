# Preview all emails at http://localhost:3000/rails/mailers/foo_mailer
class FooMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/foo_mailer/user
  def user
    FooMailer.user
  end

end
