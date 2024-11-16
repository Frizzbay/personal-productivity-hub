# Configuration for Personal Productivity Hub

import os


class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY') or '7220660f4e245f42ace00a7f10b2fd5c'
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or \
                            'postgresql://wdcdo:1337@localhost:5432/personal_productivity_hub'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
