namespace :scripts do
  desc 'Runs an external R script'
  task :detect_spam, [:sentence] => :environment do |_t, args|
    sentence = args[:sentence]
    filepath = Rails.root.join('lib', 'external_scripts', 'spam_detect.R')

    arg = { words: sentence.downcase.split }.to_json

    output = `Rscript --vanilla #{filepath} -p '#{arg}'`
    puts output
  end
end
