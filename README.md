# Financial-Services-Analysis-using-R-and-MongoDB

This project emphasizes more on CI/CD of Docker rather than analysis of data in R with MongoDB sample dataset. 

## Project Description:
Exploratory Data Analysis was performed on sample collection provided by MongoDB Atlas (sample-analytics) using R as tool. The goal of this project is to run the analysis on a remote server (AWS EC2 instance). To achieve the goal I built a docker image with the appropriate R code and ran the docker container using Jenkins pipeline on AWS EC2 instance. The remote server was same as the server that was hosting Jenkins. For future advancements, you can create two separate remote servers each for Jenkins and for dev environment and run the docker container with analysis code on the latter server. 

Steps to successfully execute the project:
1) Start a MongDB cluster on MongoDB Atlas to connect to the sample collection (sample-analytics).
2) Run the R code.
3) (Optional) Create a docker build locally and run the container.
4) Create an AWS EC2 instance with custom security group and key-value pair (PEM key).
5) Run jenkins on EC2 instance using docker jenkins container.
6) Configure the Jenkinsfile (attached) on jenkins and build the pipeline as final step.
