/* 
Initial schema for Personal Productivity Hub
A task management system with categories, tags, time tracking, and dependencies.
*/

/* Enable UUID generation for unique identifiers across all tables */
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

/* Custom enumerated types for task properties */
CREATE TYPE task_status AS ENUM ('not_started', 'in_progress', 'completed', 'on_hold');
CREATE TYPE task_priority AS ENUM ('low', 'medium', 'high', 'urgent');

/* 
Categories Table
Organizes tasks into broad groupings with unique names
Includes automatic timestamp tracking for creation and updates
*/
CREATE TABLE categories (
    category_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE categories ADD CONSTRAINT categories_name_key UNIQUE (name);

/* 
Tags Table
Flexible labeling system for tasks
Ensures tag names are unique across the system
*/
CREATE TABLE tags (
    tag_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

/* 
Tasks Table
Core table for task management
Links to categories and supports multiple tags
Includes status, priority, timing, and tracking information
*/
CREATE TABLE tasks (
    task_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(200) NOT NULL,
    description TEXT,
    status task_status DEFAULT 'not_started',
    priority task_priority DEFAULT 'medium',
    category_id UUID REFERENCES categories(category_id),
    due_date TIMESTAMP WITH TIME ZONE,
    estimated_duration INTERVAL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

/* 
Task_Tags Table
Junction table implementing many-to-many relationship between tasks and tags
Includes cascade deletion to maintain referential integrity
*/
CREATE TABLE task_tags (
    task_id UUID REFERENCES tasks(task_id) ON DELETE CASCADE,
    tag_id UUID REFERENCES tags(tag_id) ON DELETE CASCADE,
    PRIMARY KEY (task_id, tag_id)
);

/* 
Time_Entries Table
Tracks time spent on specific tasks
Automatically calculates duration from start and end times
Supports additional notes for each time entry
*/
CREATE TABLE time_entries (
    entry_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), 
    task_id UUID REFERENCES tasks(task_id) ON DELETE CASCADE,
    start_time TIMESTAMP WITH TIME ZONE NOT NULL,
    end_time TIMESTAMP WITH TIME ZONE,
    duration INTERVAL GENERATED ALWAYS AS (end_time - start_time) STORED,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

/* 
Task_Dependencies Table
Manages prerequisite relationships between tasks
Prevents circular dependencies through self-referencing check
*/
CREATE TABLE task_dependencies (
    dependency_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    dependent_task_id UUID REFERENCES tasks(task_id),
    prerequisite_task_id UUID REFERENCES tasks(task_id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CHECK (dependent_task_id != prerequisite_task_id)
);

/* 
Timestamp Update Function
Automatically updates the updated_at timestamp when records are modified
Used by triggers on tables with timestamp tracking
*/
CREATE OR REPLACE FUNCTION updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN new;
END; 
$$ language 'plpgsql';

/* Create triggers for automatic timestamp updates */
CREATE TRIGGER update_tasks_timestamp
    BEFORE UPDATE ON tasks
    FOR EACH ROW
    EXECUTE FUNCTION updated_at_column();

CREATE TRIGGER update_categories_timestamp
    BEFORE UPDATE ON categories
    FOR EACH ROW
    EXECUTE FUNCTION updated_at_column();