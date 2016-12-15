namespace :notes do
  task :expires do
    # NOTE: puts as defined as `EXPIRES: yyyy-mmdd`
    SourceAnnotationExtractor.enumerate("EXPIRES")
  end
end
