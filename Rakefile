require 'rake'
require 'yaml'

def master_docker_compose_yml
  YAML.load(`git show master:docker-compose.yml`) || {}
end

def future_docker_compose_yml
  YAML.load(`cat docker-compose.yml`) || {}
end

def changed_roles
  roles = []
  master = master_docker_compose_yml
  future = future_docker_compose_yml
  future.each do |k,v|
    unless k == 'base'
      roles.push(k) if !master.has_key?(k) || \
                       v['environment']['REVISION'] > master[k]['environment']['REVISION'] || \
                       v['environment']['NGINX_VERSION'].delete("^0-9") > master[k]['environment']['NGINX_VERSION'].delete("^0-9")
    end
  end
  roles
end

def build_rpm role
  sh 'docker-compose down -v || true'
  sh "docker-compose build #{role}"
  sh "docker-compose up    #{role}"
  sh 'docker-compose down -v || true'
end

desc "build nginx RPM changed roles (default)"
task :build do
  roles = changed_roles
  if roles.empty?
    puts "no change"
  else
    build_rpm(roles.join(' '))
  end
end

future_docker_compose_yml.keys.each do |role|
  next if role == 'base'
  desc "build nginx RPM role: #{role}"
  task "build_#{role}" do
    build_rpm(role)
  end
end

desc "show changed roles"
task :changed_roles do
  puts changed_roles.join(' ')
end

task default: :build
