import streamlit as st
st.write("Hello World")
box_1 = st.selectbox('What do you want to do' , ['NN Playground','Simon Style GAN'])
if box_1 == 'Simon Style GAN':
  st.write('https://openai.com/dall-e-2/')
