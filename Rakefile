##############
#   Build    #
##############

# Generate the site
# Minify, optimize, and compress

desc "build the site"
task :build do
  system "JEKYLL_ENV=production bundle exec jekyll build --incremental"
end

##############
#   Develop  #
##############

# Useful for development
# It watches for chagnes and updates when it finds them

desc "Watch the site and regenerate when it changes"
task :watch do
  system "JEKYLL_ENV=development bundle exec jekyll serve --config '_config.yml,_config_localhost.yml' --watch"
end

################
#   Gem Theme  #
################
desc "create the gem"
task :buildgem do
  system "JEKYLL_ENV=production bundle exec gem build starving-artist.gemspec"
end

desc "release the gem"
task :releasegem do
  system "JEKYLL_ENV=production bundle exec gem push starving-artist-jekyll-theme-*.gem"
end
