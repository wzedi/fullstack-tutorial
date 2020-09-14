# Apollo tutorial

This is the fullstack app for the [Apollo tutorial](http://apollographql.com/docs/tutorial/introduction.html). 🚀

## View it

To view the example setup, go [here](http://fullstack-gql-website-deployment.s3-website-ap-southeast-2.amazonaws.com/).

## Run it locally

1. In the `client` folder, create a file named `.env.local` with the following contents:

  ```
  REACT_APP_CLIENT_URI=http://localhost:4000/dev/graphql
  ```
  
1. Run the following commands in three separate terminal windows, from the root directory:

  ```bash
  cd server && npm i
  npm run start-dynamo-local
  ```

  ```bash
  cd server
  npm start
  ```

  ```bash
  cd client && npm i && npm start
  ```

## CI/CD and Secrets Management

This project uses [Github Actions](https://github.com/features/actions) for CI/CD.  This is partly because Github Actions allows users to manage secrets from within a repository, and makes it extremely difficult to accidentally print secrets to the command line.  It also allows anyone with access to a repository to view the CI/CD pipeline without needing to manage extra permissions, and comes with AWS integration out of the box (the AWS CLI is installed on all Github-hosted task runners, and AWS has developed Actions for several common workflows).

## Deploy it yourself

1. Fork this repository to your GitHub account.

1. In AWS, create an IAM user with full admin permissions.

1. Under `your IAM user` > `Security credentials`, generate an access key for your user.  We'll need this in the next step.

1. In your Github repository, go to `Settings` > `Secrets`.  Using the `New secret` button, create the following two secrets:

  ```
  Name: AWS_ACCESS_KEY_ID
  Value: The ID portion of your access key (all caps)
  ```
  
  ```
  Name: AWS_SECRET_ACCESS_KEY
  Value: The Secret Key portion of your access key
  ```

1. Run the pipeline to see the build results.  Github is currently in the process of adding support for manually running pipelines - until this is added, you may need to push a commit with a newline added to a file to get the project to build.  The project will be deployed into the `ap-southeast-2` region of your AWS account.

## Known Issues

- In production, there is a bug which causes the API to return an `ERR_INVALID_REDIRECT` when the website hits it.  This bug does not exist in the local configuration.  I've attempted to debug it, and my best guess is that it may be due to the way that browsers handle CORS requests.  However, for an issue such as this one, I would typically want to pair with someone to try to get to the root of it.
- The pipeline task that builds the production `dotenv` file has the `ap-southeast-2` region hard-coded into it.  I believe that it should be possible to fix this by making the AWS region a variable shared by the whole pipeline, and using that for both the credentials and the `dotenv` file.

## Tradeoffs, Limitations, and Improvements

- I used an IAM user with full admin permissions for the deployment, so that I didn't have to worry about going in and tweaking the policies.  If I had more time, I would reduce the permissions on the IAM user that Github Actions uses to build, and test it before changing the instructions.  I believe that Full Access permissions to API Gateway, CloudFormation, Lambda, DynamoDB, and S3 should be sufficient.
- I chose to build out a Cloudformation template for the AWS deployment for a couple of reasons.  I'm not familiar with Serverless Framework, and couldn't find an easy way to get Serverless to handle having multiple configuration files.  I also decided that building out a Cloudformation template would enable me to get a better understanding of the infrastructure that I was working on, rather than just copying and pasting.  Given this understanding, I would probably modify the Serverless Framework workflow were I to complete this task again.
- The advice on checking local `dotenv` files into a Github repository seems to vary.  I've left them out in this case, and given instructions for how to set the file up locally yourself.  This should mean that anyone building the project locally can change their configuration if they wish, which is one advantage of this approach.
- I chose to use trunk-based deployment because the Github Actions pipeline only builds on the `default` branch, and I wanted to be able to test things and catch small bugs quickly.  When working on my own, I prefer to make small changes incrementally so that I can catch issues early rather than relying on a review process.  For a larger-scale project with a better-architected pipeline, I would use branch-based deployment instead.
- There is a lot of scope for improvement in the local run workflow.  If I had time, I would probably Dockerise this, and set it up so that the whole application could build using one `docker-compose` command from the root directory.
- From there, it would be possible to host the application on a custom URL using a Cloudfront distribution and LetsEncrypt certificate, as well as improving security.  I would probably focus on HSTS headers first to ensure that the site was less vulnerable to man-in-the-middle attacks, and then I would look at securing the traffic between the Lambda and the DynamoDB.
