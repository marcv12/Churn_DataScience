# Bank Customer Churn Analysis with R

Through this project, you will be able to predict whether customers in your bank are likely to churn (leave) or not. We've also provided the prediction results in a file for your reference.

## Description
"To Churn or Not To Churn" is a data analysis project aimed at predicting bank customer churn using machine learning models. The primary model we've decided to use for this task is the Random Forest (RF) with grid search. This project takes you through different stages of the machine learning pipeline, from data exploration to model creation, optimization, and interpretation of final results.

## Installation
The project is written in R. We recommend using RStudio to run the code. You can install the required packages using the install.packages() function in R:

```R
install.packages(c('dplyr', 'ggplot2', 'randomForest', 'caret'))
```

The main libraries used in this project are:

- dplyr
- ggplot2
- randomForest
- caret

## Project Motivation
In the banking industry, understanding and predicting customer churn is a key strategy for maintaining a healthy and profitable customer base. Our aim with this project is to create and optimize machine learning models that effectively predict customer churn. We are motivated by the potential impact of our work in assisting banks to understand their customers better and ultimately maintain customer loyalty.

## File Description
The repository contains the following key files:

- midterm_project_DA4B.R: Part 1 of the project where the data exploration and preprocessing is performed.
- mid_proj_Part2.R: Part 2 of the project where the model creation and optimization take place.
- bank_accounts_train.csv: The training dataset used in the project.
- bank_accounts_test.csv: The testing dataset used in the project.
- probs_pred.csv: File containing the predictions of whether a customer will churn or not according to our best performing algorithm (random forest with grid search).
- purchases.csv: Additional data on customer purchases.
- README.md: The file you are currently reading.

## How to Interact with this Project
The main project code is divided into two parts: part 1 is in the midterm_project_DA4B.R file and part 2 is in the mid_proj_Part2.R file. 

After installing the required packages, you can interact with this project by running the code within RStudio.

I hope you enjoy this project as much as I did creating it, and if you have any comments, I would be glad to respond!

## Licensing
This project is licensed under the Apache License 2.0 - see the LICENSE file for more details.

## Acknowledgements
We would like to express our deepest gratitude to our professors and mentors who guided us throughout the project. We also acknowledge OpenAI's GPT-4 model for assisting in generating the text and insights for this README file. We appreciate the creators of the dataset and everyone else who contributed to making this project a success.
