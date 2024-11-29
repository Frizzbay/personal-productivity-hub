from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from config import Config

db = SQLAlchemy()

"""

Personal Productivity Hub
Core application initialization

"""

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

    db.init_app(app)

    from app import routes
    
    routes.init_app(app)

    return app
