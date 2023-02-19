node{
    stage('Git Checkout'){
        git branch: 'main', credentialsId: 'git-creds', url: 'https://github.com/NvkAnirudh/Financial-Services-Analysis-using-R-and-MongoDB'
    }
    stage('Build Docker Image'){
        sh 'docker build -t anirudh124/mongodb-analysis .'
    }
    stage('Push Docker Image'){
        withCredentials([string(credentialsId: 'docker-pwd2', variable: 'DockerHubPwd')]) {
            sh "docker login -u anirudh124 -p ${DockerHubPwd}"
        }
        sh 'docker push anirudh124/mongodb-analysis'
    }
    stage('Run Docker Container on Dev Server'){
        sh 'docker run -p 8081:8081 -d anirudh124/mongodb-analysis'
    }
}
