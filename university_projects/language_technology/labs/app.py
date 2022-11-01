import streamlit as st
text = st.text_input('Input a piece of text to translate to swedish')
def encode(input_text):
  input_seq = np.zeros((1,max_encoder_seq_length,num_encoder_tokens), dtype="float32")
  for t, char in enumerate(input_text):
        input_seq[0,t, input_token_index[char]] = 1.0
  input_seq[0, t + 1 :, input_token_index[" "]] = 1.0
  return input_seq

# Write your code here
def translate(input_text):
  input_seq = encode(input_text)
  decoded_sentence = decode_sequence(input_seq)
  return decoded_sentence


