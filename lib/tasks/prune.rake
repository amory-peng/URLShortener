namespace :url_shortener do
  task :prune, [:minutes] => :environment do |_, args|
    minutes = args[:minutes].to_i || 20
    puts "Pruning old links..."
    ShortenedUrl.prune(minutes)
  end
end
