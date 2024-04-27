pipeline {
    agent any
    environment {
        registry = 'us-central1-docker.pkg.dev/sanbox-credit/fromjenkins'
        registryCredential = 'gcloud-cred'
       // googleCred2 = 'gcloud-cred'
        googleCred = credentials('gcloud-cred')
        PROJECT_ID = 'sanbox-credit'
        //IMAGE_NAME = 'us-central1-docker.pkg.dev/sanbox-credit/fromjenkins'

        PROJECT = "sanbox-credit"
        APP_NAME = "testapp"
        REPO_NAME = "fromjenkins"
        REPO_LOCATION = "us-central1"
        IMAGE_NAME = "${REPO_LOCATION}-docker.pkg.dev/${PROJECT}/${REPO_NAME}/${APP_NAME}"
    }
    stages {
        stage('Fetch code') {
            steps {
                git branch: 'main', url: 'https://github.com/FFSiyam/practice-project.git'
            }
        }
        stage('dependencies install') {
            steps {
                sh 'sudo npm install'
            }
        }
        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }

        stage('gcloud connect') {
        steps{
            sh 'gcloud version'
            sh 'gcloud auth activate-service-account --key-file="$googleCred"'
            sh 'gcloud compute zones list'
            sh 'gcloud config set compute/region us-central1'
            sh 'gcloud config set compute/zone us-central1-a'

        }
    }
    
   stage('Build docker image') {
      steps{
            sh 'pwd'
            sh 'docker build -t ${IMAGE_NAME}:v$BUILD_NUMBER .'
            withCredentials([file(credentialsId: 'gcloud-cred', variable: 'gcloud-cred')]){
            //   sh 'cat "${GCR_CRED}" | docker login -u _json_key_base64 --password-stdin https://"${REPO_LOCATION}"-docker.pkg.dev'
              sh 'docker push ${IMAGE_NAME}:v$BUILD_NUMBER'
              sh 'docker logout https://"${REPO_LOCATION}"-docker.pkg.dev'
            }
            //sh 'docker rmi ${IMAGE_NAME}:v$BUILD_NUMBER'
            echo 'Build docker image Finish'
          }
        
      }

    stage('cloud run') {
        steps{
            sh "gcloud run deploy jenkins --image '$registry'/'$APP_NAME':v'$BUILD_NUMBER' --region us-central1"
        }
    }
    stage('invoker') {
        steps{
            sh "gcloud run services add-iam-policy-binding jenkins \
                --member='serviceAccount:jenkinspipeline@sanbox-credit.iam.gserviceaccount.com' \
                --region='us-central1' \
                --member='allUsers' \
                --role='roles/run.invoker'" 
        }
    }
    
}
     
    
}

