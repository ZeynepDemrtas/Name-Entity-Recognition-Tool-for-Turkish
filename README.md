# Deep Learning Based Named Entity Recognition (NER) Tool for Turkish 

## Overview

The NER tool is designed to identify and classify named entities in text into predefined categories such as Person (PER), Location (LOC), Organization (ORG), and Date (DATE). This project implements a deep learning-based Named Entity Recognition (NER) tool for the Turkish language. The system allows users to perform NER tasks using three different models: 

- BiLSTM
- BiGRU
- Fine-Tuned BERT 


## System Architecture
The system consists of three main components:

- Trained Models: Models trained on a specially prepared dataset.
- Server: Manages communication between the models and the user interface.
- User Interface: A web-based interface developed using Flutter.

![Alt text](/images/system.png)

## Table of Contents
- [Dataset](#dataset)
  - [Data Cleaning and Preprocessing](#data-cleaning-and-preprocessing)
  - [Data Summary](#dataset-summary)
  - [Example of Data Format](#example-of-data-format)
- [Methodology](#methodology)
  - [Data Preparation](#data-preparation)
  - [Model Training](#model-training)
  - [Web Application](#web-application)
- [Dependencies](#dependencies)
- [Results](#results)


## Dataset
The dataset used for training consists of Turkish Wikipedia articles ([link to dataset](https://www.kaggle.com/datasets/constantinwerner/multilingual-ner-dataset?select=tur.tsv)), which have been re-labeled, cleaned, and augmented. The final dataset comprises columns for words, their corresponding labels, and sentence numbers. The labels include categories such as PERSON, LOC, ORG, and DATE, using the IOB2 format.

### Data Cleaning and Preprocessing

1. **Initial Dataset**: The initial dataset included various entity types beyond PERSON, LOC, ORG, and DATE, such as events, artworks, currencies, and races. These were re-labeled to 'O' (Other) due to their infrequent occurrence.
2. **Sentence Numbering**: Sentences were numbered to facilitate model input.
3. **Label Adjustment**: Entities not relevant to PERSON, LOC, ORG, and DATE were re-labeled as 'O'.
4. **Labeling Format**: Applying IOB2 tagging for entity representation.
5. **Manual Corrections**: Incorrect labels and misspellings were manually corrected.
6. **Padding and Indexing**: Sentences were padded to ensure uniform input length, and words were indexed using pre-trained embeddings or vocabularies derived from the dataset.

The final dataset consists of 26,403 words and 2,067 sentences, with entities labeled as B- (beginning) and I- (inside).

### Dataset Summary
- **Total Words**: 26,403
- **Total Sentences**: 2,067
- **Training Set**: 20,959 words, 1,653 sentences
- **Test Set**: 5,444 words, 414 sentences

Entities|Train|Test|Total
-----|------|-----|-----
B-PER|	1243|	249|	1492|
I-PER|	792|	166|	954|
B-LOC|	1137|	350|	1487|
I-LOC|	309|	127|	436|
B-ORG|	566|	210|	776|
I-ORG|	573|	224|	797|
B-DATE|	606|	191|	797|
I-DATE|	462|	166|	628|
O|	15271|	3765|	19036|



### Example of Data Format
- **Word**: "Türkiye"
- **Label**: "B-LOC"

## Methodology

### Data Preparation

1. **Tokenization and Padding**: Sentences were tokenized striped from punctiations and padded to ensure uniform input lengths for the models.

2. **Embedding Indexing**: Words were indexed using FastText embeddings for BiLSTM and a custom vocabulary for BiGRU.

### Model Training

Three models were developed and trained:

1. **BiLSTM Model**:
   - **Embedding**: Used FastText pre-trained word vectors. You can  find it in this [link](https://fasttext.cc/docs/en/crawl-vectors.html).
   - **Dimensionality Reduction**: Applied PCA to reduce dimensionality from 300 to 100 dimensions.
   - **Training**: 
![Alt text](/images/Bilstm.png)


   - **Performance**: Achieved a macro F1 score of 72%.
![Alt text](/images/Bilstm_F1.PNG)
   

2. **BiGRU Model**:
   - **Embedding**: Used custom vocabulary derived from the dataset.
   - **Training**: 
   ![Alt text](/images/bigru.png)
   - **Performance**: Achieved a macro F1 score of 56%.
   ![Alt text](/images/Bigru_f1.png)

3. **BERT Model**:
   - **Pre-trained Model**: Fine-tuned "dbmdz/bert-base-turkish-cased".
   - **Training**: Fine-tuning conducted using the custom dataset.
   ![Alt text](/images/bert.png)
   - **Performance**: Achieved a macro F1 score of 51%.
   ![Alt text](/images/bert_f1.png)

### Web Application

The web application was developed using Flutter and comprises the following components:

1. **User Interface**: Developed with Flutter using bloc-cubit state management with dependency injection, featuring input fields for text and model selection, and displaying the results.
2. **Server**: Flask server handles requests and communicates with the models.
3. **API Communication**: Uses Retrofit and Dio for network requests.

![Alt text](/images/website.png)


## Dependencies

- **Python Libraries**: TensorFlow, Keras, Pandas, NumPy, Flask, pymongo, transformers, nltk
- **Flutter Packages**: Retrofit, Dio, Bloc-Cubit, Get_it
- **MongoDB** : For Cloud Database
- **FastText**: For word embeddings in the BiLSTM model
- **BERT**: Fine-tuned "dbmdz/bert-base-turkish-cased" model


## Results

The performance of each model was evaluated using the F1 metric:

- **BiLSTM**:
  - **Best Performing Entity**: B-DATE with F1 score of 83%
![Alt-text](/images/Bilstm_Plot.png)

- **BiGRU**:
  - **Best Performing Entity**: I-DATE with F1 score of 77%
![Alt-text](/images/bigru_plot.png)

- **BERT**:

  - **Best Performing Entity**: I-PERSON with F1 score of 56%
![Alt-text](/images/bert_plot.png)

## Developers

This project was developed by Aslıhan Yoldaş and Zeynep Demirtaş.

