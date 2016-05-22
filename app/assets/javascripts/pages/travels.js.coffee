$(document).on('turbolinks:load',  ->
  $('#travel_form').validate()

  if ($('.dropbox-button').length > 0 )
    file_count = 0
    options = {
      success: (files) ->
        content = "<a target='_blank' href=#{files[0].link}>#{files[0].name}</a><br>"
        content += "<input type='hidden' name='travel[dropbox_files_attributes][#{file_count}][name]' id='travel_dropbox_files_attributes_#{file_count}_name' value=#{files[0].name}>"
        content += "<input type='hidden' name='travel[dropbox_files_attributes][#{file_count}][url]' id='travel_dropbox_files_attributes_#{file_count}_url' value=#{files[0].link}>"
        $('.dropbox-files').append(content)
        $('#dropbox-file-submit').removeAttr('disabled')
        file_count += 1
    }
    button = Dropbox.createChooseButton(options)
    $('.dropbox-button').append(button)

  $('.travel_date').on('click',  (e) ->
    travel_date_id = $(e.target).data("travel-date-id")
    $('#schedule_travel_date_id').val(travel_date_id)
  )
)
