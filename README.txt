# Personal Productivity Hub

A PostgreSQL-based task management system built for learning database design and SQL while creating a practical productivity tool.

## Project Overview

This system helps manage personal tasks and productivity by tracking:
- Tasks and their statuses
- Categories for organization
- Tags for flexible labeling
- Time spent on tasks
- Task dependencies

## Database Schema

### Core Tables

#### Categories
- Stores task categories (e.g., Work, Personal, Learning)
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

### Automatic Timestamp Updates
The system automatically updates timestamps when records are modified using:
- PostgreSQL triggers
- Custom functions for timestamp management

## Directory Structure