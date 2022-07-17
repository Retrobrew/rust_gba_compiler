pipeline {
    agent any

    tools {
        dockerTool 'docker-agent'
    }

    stages {
        stage("SCM") {
            steps {
                checkout scm
            }
        }
        stage("Build Docker image") {
            steps {
                script {
                    nodejs(nodeJSInstallationName: 'nodejs'){
                        def docker = tool 'docker-agent';
                        sh('docker build -t rust_gba .');
                    }
                }
            }
        }
        stage("Deploy to production") {
            when {
                anyOf {
                    branch 'master'
                }
            }
            steps {
                script {
                    withCredentials([file(credentialsId: 'retrobrew-gba_c-credentials', variable: 'FILE')]) {
                        nodejs(nodeJSInstallationName: 'nodejs') {
                            sh "aws configure import --csv file://$FILE"
                            sh "aws configure set region eu-west-1 --profile retrobrew_jenkins"
                            sh "docker login -u AWS https://692527062901.dkr.ecr.eu-west-1.amazonaws.com -p `aws ecr get-login-password --profile retrobrew_jenkins`"
                            sh "docker tag rust_gba:latest 692527062901.dkr.ecr.eu-west-1.amazonaws.com/rust_gba:latest"
                            sh "docker push 692527062901.dkr.ecr.eu-west-1.amazonaws.com/rust_gba:latest"
                        }
                    }
                }
            }
        }
        stage("Cleanup") {
            steps {
                script {
                    nodejs(nodeJSInstallationName: 'nodejs') {
                        sh "for i in `docker images |grep 'rust_gba' | awk -F' ' '{print \$3}'`; do if [ ! -z \"`docker images |grep \$i`\" ]; then docker rmi \$i --force; fi; done"
                    }
                }
            }
        }
    }
}
