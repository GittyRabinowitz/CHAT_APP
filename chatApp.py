from flask import Flask, render_template,redirect, request,session
from flask_session import Session
import os ,csv, base64
from datetime import datetime

app = Flask(__name__)
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)

ROOMS_PATH = os.getenv('ROOMS_PATH')
USERS = os.getenv("CSV_USERS_PATH")



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

def get_user_details():
        username = request.form['username']
        userpass = request.form['password']
        return username, userpass
     
def get_all_users(file):
     return csv.reader(file,delimiter="\n")

def check_input_validation(username, password):
         if username == "" or password == "":
              return "Both username and password are required."
         
def check_if_user_exist(user,username,encodedPassword):
            name ,passwd = user[0].split(",")
            if name == username:
                if passwd == encodedPassword:
                    return redirect("/login")
                else:
                    return "something went wrong!! check your password or if you are new note that the username is already exist..."
         
def add_new_user(username,encodedPassword):
      with open(USERS, 'a') as file:
          file.write(username + "," + encodedPassword + "\n")
          file.close()
          return redirect("/login")
     

def checkUserRegister(username, password):
    result= check_input_validation(username,password)
    if not result:
            encodedPassword=encode_with_base64(password)
            with open(USERS) as usersFile:
                users = get_all_users(usersFile)
                for user in users:
                    result=check_if_user_exist(user,username,encodedPassword)
                if not result:
                     result=add_new_user(username,encodedPassword)
    return result
                       

@app.route("/register", methods=['GET', 'POST'])
def register():
    if request.method == 'GET':
        return render_template("register.html")
    elif request.method == 'POST':
        username ,userpass = get_user_details()
        return checkUserRegister(username, userpass)

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
                     session["username"] = username
                     return redirect("/lobby")
                else:
                    return "something went wrong!! check your password..."
        if not flag:
            return redirect("/register")

@app.route("/login", methods=['GET', 'POST'])
def login():
    if request.method == 'GET':
        return render_template("login.html")
    elif request.method == 'POST':
        username ,userpass = get_user_details()
        return checkUserLogIn(username, userpass)
    
  
def get_all_names_of_rooms(file):
     return [room.strip() for room in file.readlines()]

def create_new_room(rooms,path):
       new_room  = request.form['new_room']
       if new_room  not in rooms:
           with open (f'{path}rooms.txt',"a") as file:
              file.write("\n"+ new_room  )
           with open(f'{path}{new_room }.txt', 'w') as new_room_file:
              pass  # This creates an empty file 

@app.route("/lobby", methods=['GET', 'POST'])
def lobby():
    if not session.get("username"):
        return redirect("/")
    with open(f'{ROOMS_PATH}rooms.txt', "r") as file:
         rooms = get_all_names_of_rooms(file)
         if request.method == 'GET':
              return render_template("lobby.html",rooms=rooms)
         elif request.method == 'POST':
              create_new_room(rooms,ROOMS_PATH)
              return redirect("/lobby" )
         

def get_details_for_message():
      message = request.form['msg']
      username = session['username']
      timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
      return message, username , timestamp

def read_msgs_in_room(path,room):
      with open(f'{path}{room}.txt', 'r') as file:
          file.seek(0)
          all_data = file.read()
          return all_data

def write_msg_into_room(path,room):
      message, username , timestamp = get_details_for_message()
      with open(f'{path}{room}.txt', 'a') as file:
               file.write(f'[{timestamp}] {username}: {message}\n')
     
     
@app.route('/api/chat/<room>', methods=['GET', 'POST'])
def update_chat(room):
     if not session.get("username"):
          return redirect("/")
     if request.method == "POST":
          write_msg_into_room(ROOMS_PATH,room)
     return read_msgs_in_room(ROOMS_PATH,room)

@app.route('/chat/<room>', methods=['GET', 'POST'])
def chat(room):
    if not session.get("username"):
         return redirect("/")
    return render_template('chat.html', room=room)

@app.route("/logout", methods=['GET', 'POST'])
def logout():
     session["username"] = None
     return redirect("/login")

@app.route("/", methods=['GET', 'POST'])
def init():
    if session.get("username"):
        return redirect("/lobby")
    return redirect("/register")


@app.route("/api/chat/<room>/clear_messages", methods=['GET', 'POST'])
def clear_messages(room):
     open(f'{ROOMS_PATH}{room}.txt', 'w').close()
     return redirect("/api/chat/{room}")

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
