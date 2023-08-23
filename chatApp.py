# from flask import Flask
# app = Flask(__name__)

# @app.route("/")
# def home():
#     return "Hello, Flask!"

# @app.route("/hello/<name>")
# def hello_there(name):
#     return "hello "+ name

# if __name__ == "__main__":
#   app.run(host="0.0.0.0")





from flask import Flask, render_template

app = Flask(__name__)

# Pass the required route to the decorator.
@app.route("/hello")
def hello():
	#return render_template('index.html')
     return "Hello, Welcome to GeeksForGeeks"
	
@app.route("/")
def index():
	return "Homepage of GeeksForGeeks"

if __name__ == "__main__":
	app.run(host="0.0.0.0" ,debug=True)
