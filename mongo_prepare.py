import pandas
import numpy as np
from gensim.models import FastText



# Saving word vectors to csv file for the BiLSTM model

ft = FastText.load_fasttext_format('cc.tr.300.bin')

vectors = []
words = []
for index_nu in range(len(ft.wv.index_to_key)):
    word = ft.wv.index_to_key[index_nu]
    vectors.append(ft.wv[word])
    words.append(word)
    
df_words_vectors = pandas.DataFrame({"words":words, "vectors":vectors})

dict_padding = {"words": "PADDING"}
df_words_vectors.loc[2000000] = dict_padding

dict_unfinded = {"words": "UNFINDED"}
df_words_vectors.loc[2000001] = dict_unfinded

df_words_vectors = df_words_vectors.drop(df_words_vectors.columns[1], axis=1)

df_words_vectors["index_id"] = df_words_vectors.index

df_words_vectors.to_csv('word_vectors.csv', index = False)

# Saving dataset words to csv file for the BiGRU model

data = pandas.read_excel('dataset4.xlsx')

words = list(data['Kelime'].unique())
indexs = [i for i, t in enumerate(words)]

df_dataset_words = pandas.DataFrame({"word": words, "index_id": indexs})

df_dataset_words.loc[len(df_dataset_words)]={"word": 'PADDING', "index_id": len(df_dataset_words)}

df_dataset_words.to_csv('dataset_words.csv', index = False)

# Saving labels

labels = list(data['Etiket'].unique())
labels.append("PAD")

labels_indeks = [t  for t, i in enumerate(labels)]

# This  csv files upload to the mongoDB later used in predicting

# Mongo Connection
from secret import url
import pymongo
cluster = pymongo.MongoClient(url)
cluster.list_database_names()