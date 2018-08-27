namespace :scripts do
  desc 'Runs an external R script'
  task run_r: :environment do
    filepath = Rails.root.join('lib', 'external_scripts', 'hello_world.R')
    output = `Rscript --vanilla #{filepath} 'Mietek'`
    puts output
  end
end
