set :ssh_options, {
    keys: %w(/home/vasile/RubymineProjects/hsctm_test/tmp/vps),
    forward_agent: true,
    user: 'hiscore'
}

server '23.92.65.226', port: 22, roles: [:web, :app, :db], primary: true

set :application, 'HsctmTest'
set :repo_url, 'git@github.com:vasile-buza/hsctm-test.git'
set :stage, :production

set :deploy_to, '/home/hiscore/hsctm_test'
set :scm, :git
set :branch, 'master'
set :user, 'hiscore'

