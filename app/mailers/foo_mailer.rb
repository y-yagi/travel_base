class FooMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.foo_mailer.user.subject
  #
  def user
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
