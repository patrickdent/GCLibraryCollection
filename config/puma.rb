workers Integer(ENV['PUMA_CUSTOM_WEB_CONCURRENCY'] || 1)
threads_count = Integer(ENV['PUMA_CUSTOM_MAX_THREADS'] || 5)
threads 2, threads_count
preload_app!
rackup DefaultRackup
port ENV['PORT'] || 3000
environment ENV['RACK_ENV'] || 'development'
on_worker_boot do
  ActiveRecord::Base.establish_connection
end
