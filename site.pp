class install_docker {

  include ::docker

  class { 'docker' :
    manage_package => true,
    package_name   => 'docker-engine',
  }

}

class code {

  vscrepo { '/home/amolbhawari/code/flask-app': 
    ensure   => present,
    provider => git,
    source   => 'https://GitHub.com/amolbhawari/flask-app',
    user     => 'amolbhawari',
  } ~>
exec { 'pushd_file':
    command  => 'pushd',
    provider => shell,
  } ~>
  exec { 'docker_build':
    command  => 'docker build -t containername:latest .',
    provider => shell,
  } ~>
  exec { 'docker_save':
    command  => 'docker save -o ./containername.tar containername:latest',
    provider => shell,
  } ~>
    exec { 'docker_run':
    command  => 'docker run -it --name dockerimagename -p 5000:5000 containername:latest',
    provider => shell,
  }
} 

class { 'install_docker': }~>
class { 'code': }
