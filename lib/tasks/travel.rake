namespace :travel do
  desc "archive automatically where we went on a travel"
  task archive: :environment do
    Travel.archive_places!
  end
end
