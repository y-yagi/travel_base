require 'test_helper'

class ExTest < ActiveSupport::TestCase
  test 'ex command test' do
    puts "ex command test start"
    file = Rails.root.join("dummy.txt")
    p file.read
    run_edit_command(editor: "ex -c %s/#//g -c wq")
    p file.read
    puts "ex command test end"
  end

  def run_edit_command(editor: )
    `EDITOR="#{editor}" bin/rails secrets:edit`
  end
end
