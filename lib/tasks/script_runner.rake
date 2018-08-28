namespace :scripts do
  desc 'Runs an external R script'
  task run_r: :environment do
    filepath = Rails.root.join('lib', 'external_scripts', 'spam_detect.R')
    output = `Rscript --vanilla #{filepath}`
    puts output
  end
end
