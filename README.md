# Personal Productivity Hub

A full-stack task management system built with PostgreSQL and Python, designed for robust task tracking and productivity analytics.

## Project Overview

This system provides comprehensive task and productivity management through:
- Task and project organization
- Flexible categorization and tagging
- Detailed time tracking
- Task dependency management
- Productivity analytics and reporting
- Python-based backend processing
- RESTful API integration

## Database Schema

### Core Tables

#### Categories
- Stores task categories (e.g., Work, Personal, Projects)
- Has unique names to prevent duplicates
- Tracks creation and update times

#### Tags
- Flexible labeling system
- Unique tag names
- Examples: urgent, deepwork, quick-win

#### Tasks
- Main table for task management
- Links to categories
- Includes:
  - Title and description
  - Status (not_started, in_progress, completed, on_hold)
  - Priority (low, medium, high, urgent)
  - Due dates
  - Estimated duration
  - Creation and update timestamps

#### Task Tags
- Links tasks with tags (many-to-many relationship)
- Automatically removes relationships when either task or tag is deleted

#### Time Entries
- Tracks time spent on tasks
- Records start and end times
- Automatically calculates duration
- Allows notes for each time entry

#### Task Dependencies
- Manages prerequisites between tasks
- Prevents circular dependencies
- Tracks creation time of dependencies

### System Features
- Automated timestamp management using PostgreSQL triggers
- Python-based data processing and analytics
- Robust data integrity constraints
- Efficient query optimization
- RESTful API endpoints for data access

## Technology Stack
- PostgreSQL for robust data storage
- Python for backend processing
- SQL for complex data queries and analytics
- RESTful API for service integration

## Directory Structure

personal_productivity_hub/
├── app/
│   ├── templates/
│   ├── init.py
│   ├── models.py
│   └── routes.py
├── sql/
│   ├── migrations/
│   │   ├── 01_initial_schema.sql
│   │   └── 02_sample_data.sql
│   ├── queries/
│   ├── functions/
│   ├── views/
│   └── procedures/
├── config.py
├── run.py
└── requirements.txt

## Setup and Installation
(To be added)

## Usage
(To be added)