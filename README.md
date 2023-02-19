# Financial-Services-Analysis-using-R-and-MongoDB

Steps to successfully execute the project:
1) Start a MongDB cluster on MongoDB Atlas to connect to the sample collection (sample-analytics).
2) Run the R code.
3) (Optional) Create a docker build locally and run the container.
4) Create an AWS EC2 instance with custom security group and key-value pair (PEM key).
5) Run jenkins on EC2 instance using docker jenkins container.
6) Configure the Jenkinsfile (attached) on jenkins and build the pipeline as final step.
