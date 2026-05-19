pipeline {
    agent {
        kubernetes {
            label 'jenkins-agent-my-app'
            yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    component: ci
spec:
  containers:
  - name: python
    image: python:3.11
    command:
    - cat
    tty: true
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    command:
    - sleep
    args:
    - 99d
    volumeMounts:
    - name: kaniko-secret
      mountPath: /kaniko/.docker
  - name: kubectl
    image: lachlanevenson/k8s-kubectl:v1.17.2
    command:
    - cat
    tty: true
  volumes:
  - name: kaniko-secret
    emptyDir: {}
"""
        }
    }
    triggers {
        pollSCM('* * * * *')
    }
    stages {
        stage('Test python') {
            steps {
                container('python') {
                    sh "pip install --timeout=120 -r requirements.txt"
                    sh "python test.py"
                }
            }
        }
        stage('Build image') {
            steps {
                container('kaniko') {
                    sh """
                        /kaniko/executor \
                        --context=. \
                        --destination=172.19.0.1:4000/pythontest:latest \
                        --insecure \
                        --skip-tls-verify
                    """
                }
            }
        }
        stage('Deploy') {
            steps {
                container('kubectl') {
                    sh "kubectl apply -f ./kubernetes/deployment.yaml"
                    sh "kubectl apply -f ./kubernetes/service.yaml"
                }
            }
        }
    }
}