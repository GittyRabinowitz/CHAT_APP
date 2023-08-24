from flask import Flask, render_template,redirect, request,session
from flask_session import Session
import os
import base64
import csv
from datetime import datetime

USERS = "users.csv"

app = Flask(__name__)
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)

ROOMS_PATH = os.getenv('ROOMS_PATH')


def encode_with_base64(message):
     message_bytes = message.encode('ascii')
     base64_bytes = base64.b64encode(message_bytes)
     base64_message = base64_bytes.decode('ascii')
     return base64_message


def decode_with_base64(base64_message):
     base64_bytes = base64_message.encode('ascii')
     message_bytes = base64.b64decode(base64_bytes)
     message = message_bytes.decode('ascii')
     return message

def checkUserRegister(username, password):
    if username == "" or password == "":
         return "Both username and password are required."
    flag = False
    encodedPassword=encode_with_base64(password)
    with open(USERS) as usersFile:
        users = csv.reader(usersFile,delimiter="\n")
        for user in users:
            name ,passwd = user[0].split(",")
            if name == username:
                flag = True
                if passwd == encodedPassword:
                     return redirect("/login")

                else:
                    return "something went wrong!! check your password..."
        if not flag:
                        with open(USERS, 'a') as file:
                               file.write(username + "," + encodedPassword + "\n")
                               file.close()
                               return redirect("/login")



def checkUserLogIn(username, password):
    flag = False
    encodedPassword = encode_with_base64(password)
    with open(USERS) as usersFile:
        users = csv.reader(usersFile,delimiter="\n")
        for user in users:
            name ,passwd = user[0].split(",")
            if name == username:
                flag = True
                if passwd == encodedPassword:
                     return redirect("/lobby")
                else:
                    return "something went wrong!! check your password..."
        if not flag:
            return redirect("/register")

@app.route("/register", methods=['GET', 'POST'])
def register():
    if request.method == 'GET':
        return render_template("register.html")
    elif request.method == 'POST':
        username = request.form['username']
        userpass = request.form['password']
        return checkUserRegister(username, userpass)



             
@app.route("/login", methods=['GET', 'POST'])
def login():
    if request.method == 'GET':
        return render_template("login.html")
    elif request.method == 'POST':
        username = request.form['username']
        userpass = request.form['password']
        session["username"] = username
        return checkUserLogIn(username, userpass)

@app.route("/lobby", methods=['GET', 'POST'])
def lobby():
    if not session.get("username"):
        return redirect("/")
    with open(f'{ROOMS_PATH}rooms.txt', "r") as file:
         rooms = [room.strip() for room in file.readlines()]
         if request.method == 'GET':
              return render_template("lobby.html",rooms=rooms)
         elif request.method == 'POST':
              new_room  = request.form['new_room']
              if new_room  not in rooms:
                   with open (f'{ROOMS_PATH}rooms.txt',"a") as file:
                        file.write("\n"+ new_room  )
                   with open(f'{ROOMS_PATH}{new_room }.txt', 'w') as new_room_file:
                        pass  # This creates an empty file 
              return redirect("/lobby" )
         

@app.route('/chat/<room>', methods=['GET', 'POST'])
def chat(room):
    if not session.get("username"):
         return redirect("/")
    return render_template('chat.html', room=room)

@app.route('/api/chat/<room>', methods=['GET', 'POST'])
def update_chat(room):
     if not session.get("username"):
          return redirect("/")
     if request.method == "POST":
          message = request.form['msg']

          username = session['username']
          timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
          with open(f'{ROOMS_PATH}{room}.txt', 'a') as file:
               file.write(f'[{timestamp}] {username}: {message}\n')
     with open(f'{ROOMS_PATH}{room}.txt', 'r') as file:
          file.seek(0)
          all_data = file.read()
          return all_data


@app.route("/", methods=['GET', 'POST'])
def init():
    if session.get("username"):
        return redirect("/lobby")
    return redirect("/register")

@app.route("/logout", methods=['GET', 'POST'])
def logout():
     session["username"] = None
     return redirect("/login")

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
