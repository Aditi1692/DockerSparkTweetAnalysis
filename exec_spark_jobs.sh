#! /bin/bash

CODE_FOLDER="/root/TweetSentimentAnalysisSpark"
FOLDER_NAME="TweetSentimentAnalysisSpark"
cd $CODE_FOLDER/

echo -e "--------------SBT Clean Assembly------------\n"
# Initiate SBT build of the project.
sbt error clean assembly


echo -e "***** Started Spark services...... *****\n"


# Trigger Spark job for creating the Naive Bayes Model.
echo -e "-----------------CD into target--------------\n"
cd $FOLDER_NAME/target/scala-2.11/
echo -e "\n\n***** Starting Naive Bayes Model creation of training data...... *****\n\n"
spark-submit --class "SparkNaiveBayesModelCreator" --master spark://ip-172-31-5-231.us-east-2.compute.internal:7077 tweet-sentiment-analysis_2.11-0.1.jar
echo -e "\n\n***** Naive Bayes Model creation of training data is complete...... *****\n\n"


# Trigger Spark Streaming job for sentiment prediction.
echo -e "\n***** Starting Twitter Sentiment Analysis ...... *****\n"
echo -e "***** Please launch browser on the host machine to http://192.168.99.100:9999 to view Twitter Sentiment visualized on a world map ...... *****\n\n"
cd $CODE_FOLDER/target/scala-2.11/
spark-submit --class "TweetSentimentAnalyzer" --master spark://ip-172-31-5-231.us-east-2.compute.internal:7077 tweet-sentiment-analysis_2.11-0.1.jar

