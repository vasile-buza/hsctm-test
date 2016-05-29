set :ssh_options, {
    keys: %w(/home/vasile/RubymineProjects/hsctm_test/tmp/vps),
    forward_agent: true,
    user: 'hiscore'
}

server '23.92.65.226', port: 22, roles: [:web, :app, :db], primary: true

set :application, 'HsctmTest'
set :repo_url, 'git@github.com:vasile-buza/hsctm-test.git'
set :stage, :production
set :use_sudo, false

set :deploy_to, '/home/hiscore/hsctm_test'
set :scm, :git
set :branch, 'master'
set :user, 'hiscore'

namespace :deploy do

  desc 'Install ember deps'
  task :install_ember_deps do
    on roles(:app) do
      %w(hsctm).each do |ember_app|
        execute "cd #{release_path}/ember/#{ember_app} && npm install && bower install"
      end
    end
  end

  task :updating => :new_release_path do
    invoke 'deploy:upload_release'
    invoke 'deploy:install_ember_deps'
  end

  desc 'Compiling ember'
  task :compile_ember do
    on release_roles(fetch(:assets_roles)) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'ember:compile'
        end
      end
    end
  end

  after  :finishing,         :compile_assets
  after  :compile_assets,    :compile_ember
end

