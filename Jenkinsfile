pipeline {
  agent any
  // Global Tool Configuration 에서 설정한 Name
  tools {
    maven 'Maven3' 
  }

  // 해당 스크립트 내에서 사용할 로컬 변수들 설정
  // 레포지토리가 없으면 생성됨
  // Credential들에는 젠킨스 크레덴셜에서 설정한 ID를 사용
  environment {
    dockerHubRegistry = 'cyaninn/demo-eks-cicd' 
    dockerHubRegistryCredential = 'credentials-dockerHub'
    githubCredential = 'credential-github'
    gitEmail = 'sounddevice3@gmail.com'
    gitName = 'cyaninn-entj'
  }

  stages {

    // 깃허브 계정으로 레포지토리를 클론한다.
    stage('Checkout Application Git Branch') {
      steps {
        checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: githubCredential, url: 'https://github.com/cyaninn-entj/mini-cicd-eks-project.git']]])
      }
      // steps 가 끝날 경우 실행한다.
      // steps 가 실패할 경우에는 failure 를 실행하고 성공할 경우에는 success 를 실행한다.
      post {
        failure {
          echo 'Repository clone failure' 
        }
        success {
          echo 'Repository clone success' 
        }
      }
    }
  }

  stage('Docker Image Build') {
    steps {
      // 도커 이미지 빌드
      sh "docker build . -t ${dockerHubRegistry}:${currentBuild.number}"
      sh "docker build . -t ${dockerHubRegistry}:latest"
    }
    // 성공, 실패 시 슬랙에 알람오도록 설정
    post {
      failure {
        echo 'Docker image build failure'
        //slackSend (color: '#FF0000', message: "FAILED: Docker Image Build '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
      }
      success {
        echo 'Docker image build success'
        //slackSend (color: '#0AC9FF', message: "SUCCESS: Docker Image Build '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
      }
    }
  }  

  stage('Docker Image Push') {
    steps {
      // 젠킨스에 등록한 계정으로 도커 허브에 이미지 푸시
      withDockerRegistry(credentialsId: dockerHubRegistryCredential, url: '') {
        sh "docker push ${dockerHubRegistry}:${currentBuild.number}"
        sh "docker push ${dockerHubRegistry}:latest"
        // 10초 쉰 후에 다음 작업 이어나가도록 함
        sleep 10
      } 
    }
    post {
      failure {
        echo 'Docker Image Push failure'
        sh "docker rmi ${dockerHubRegistry}:${currentBuild.number}"
        sh "docker rmi ${dockerHubRegistry}:latest"
        //slackSend (color: '#FF0000', message: "FAILED: Docker Image Push '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
      }
      success {
        echo 'Docker Image Push success'
        sh "docker rmi ${dockerHubRegistry}:${currentBuild.number}"
        sh "docker rmi ${dockerHubRegistry}:latest"
        //slackSend (color: '#0AC9FF', message: "SUCCESS: Docker Image Push '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
      }
    }
  }

   // updated docker image 태그를 git push 
  stage('Deploy') { 
      // 사전 준비
      sh("""
        git config --global user.name ${gitName}
        git config --global user.email ${gitEmail}
        git checkout -B master
      """)
  withCredentials([usernamePassword(credentialsId: githubCredential, usernameVariable: gitName, passwordVariable: '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')]) {   
        sh("""
            #!/usr/bin/env bash
            git config --local credential.helper '!f() { echo username=\\$GIT_USERNAME; echo password=\\$GIT_PASSWORD; }; f'
            cd prod && kustomize edit set image ${dockerHubRegistry}:${currentBuild.number}
            git add kustomization.yaml
            git status
            git commit -m 'update the image tag'
            git push origin HEAD:master
        """)   
    }
  }
}