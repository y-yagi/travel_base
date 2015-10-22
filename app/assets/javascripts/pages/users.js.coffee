$ ->
  $('#user_form').validate()

  options = {
      success: (files) ->
        alert("Here's the file link: " + files[0].link)
        link = "<a target='_blank' href=" + files[0].link + ">" + files[0].name + "</a>"
        $('.files').append(link)
      linkType: "direct"
  }
  button = Dropbox.createChooseButton(options)
  $('#dropbox').append(button)
