from joblib import load
import numpy as np
import json
import pandas as pd



def my_prediction_file(file_name):
  my_model = load('resources/tree_model.pkl')
  missing_value=["Undefined"]
  user_arry = pd.read_csv(file_name, na_values=missing_value, index_col=False)
  prediction = my_model.predict(user_arry)
  df = pd.DataFrame(prediction)
  df.to_csv('new.csv')
  new_json = df.to_json()
  return new_json
