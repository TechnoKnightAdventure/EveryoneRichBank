# Adding Haml Compiler to the asset pipeline
Rails.application.assets.register_engine('.haml', Tilt::HamlTemplate)

# Precompiling all the css and js files
Rails.application.config.assets.precompile += [/.*\.js/,/.*\.css/]

Rails.application.config.assets.precompile += %w( bootstrap.min.css )
Rails.application.config.assets.precompile += %w( bootstrap.min.js )
