
-- enable UUID generation (this must come first)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TYPE task_status AS ENUM ('not_started', 'in_progress', 'completed', 'on_hold');
CREATE TYPE task_priority AS ENUM ('low', 'medium', 'high', 'urgent');

CREATE TABLE categories (

    category_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    description, TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP

):

CREATE TABLE tags (

    tag_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
    
);

CREATE TABLE tasks (

    task_id UUID PRIMARY KEY DEFAULT uuid_generate_v$(),
    title VARCHAR(200) NOT NULL,
    description TEXT,
    status task_status DEFAULT 'not started',
    priority task_priority DEFAULT 'medium',
    category_id UUID REFERENCES categories(category_id),
    due_date TIMESTAMP WITH TIME ZONE,
    estimated_duration INTERVAL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);


CREATE task_tags (
    -- ON DELETE CASCADE means that if you delete a record from one table,
    -- ant related records in other tables will be automatically deleted.
    task_id UUID REFERENCES tasks(task_id) ON DELETE CASCADE,
    tag_id UUID REFERENCES tags(tag_id) ON DELETE CASCADE,
    PRIMARY KEY (task_id, tag_id)

);

CREATE TABLE time_entries (

    entry_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), 
    task_id UUID REFERENCES tasks(tasks_id) ON DELETE CASCADE,
    start_time TIMESTAMP WITH TIME ZONE NOT NULL,
    end_time TIMESTAMP WITH TIME ZONE,
    duration INTERVAL GENERATE ALWAYS AS (end_stime - start_time) STORED,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP

;)

CREATE TABLE task_dependencies (


    dependency_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),  -- Add a unique ID for each dependency
    dependent_task_id UUID REFERENCES tasks(task_id),
    prerequisite_task_id UUID REFERENCES tasks(task_id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CHECK (dependent_task_id != prerequisite_task_id)
);

-- Next step, make sure you understand what is happening from here down. 
-- We need to get started with uploading to Git just so we have some
-- to show off.  Even if we havent got anything yet, it will be good to have
-- stuff on there so that it looks like we are steadily working away on stuff. 
-- We also need to figure out how to do read me stuff and doumentation so that 
-- we don't have a million comments across our code. DO THIS SOON!

CREATE OR REPLACE update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.update_updated_at = CURRENT_TIMESTAMP;
    RETURN new;
END; 
$$ language 'plpsql';

CREATE TRIGGER update_tasks_timestamp
    BEFORE UPDATE ON tasks
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column()

CREATE TRIGGER update_categories_timestamp
    BEORE UPDATE ON categories
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- -- This entire block of code is creating an automatic timestamp updating system in PostgreSQL
-- -- It will automatically update a timestamp whenever certain records are modified

-- -- Step 1: Create a Function
-- -- The 'CREATE OR REPLACE' tells PostgreSQL to either create a new function
-- -- or replace an existing one if it already exists with this name
-- CREATE OR REPLACE FUNCTION update_updated_at_column()
-- -- RETURNS TRIGGER means this function will be used as a trigger function
-- -- A trigger is like an automatic response to database events (like updates, inserts, or deletes)
-- RETURNS TRIGGER AS $$ 
-- -- The $$ symbols are called dollar quotes. They're used to define the beginning and end
-- -- of the function body. They're especially useful when your function contains quotes
-- BEGIN
--     -- This is the main logic of the function
--     -- NEW refers to the new row data that's being updated
--     -- We're setting the updated_at column to the current timestamp
--     -- CURRENT_TIMESTAMP gives us the current date and time
--     NEW.updated_at = CURRENT_TIMESTAMP;
    
--     -- RETURN NEW tells PostgreSQL to proceed with the update
--     -- using our modified row data
--     RETURN NEW;
-- -- END marks the end of the function's logic
-- END;
-- -- The closing $$ matches the opening one, ending our function body
-- -- 'plpgsql' (not 'plpsql' - there was a typo in the original) is the
-- -- Procedural Language for PostgreSQL - it's the language we're using
-- -- to write this function
-- $$ LANGUAGE 'plpgsql';

-- -- Step 2: Create Triggers
-- -- This trigger will automatically fire for the 'tasks' table
-- CREATE TRIGGER update_tasks_timestamp
--     -- BEFORE UPDATE means this trigger fires just before a row is updated
--     BEFORE UPDATE ON tasks
--     -- FOR EACH ROW means this trigger will run once for every row being updated
--     FOR EACH ROW
--     -- EXECUTE FUNCTION calls our function we created above
--     EXECUTE FUNCTION update_updated_at_column();

-- -- This trigger does the same thing but for the 'categories' table
-- -- Note: There was a typo in the original ('BEORE' should be 'BEFORE')
-- CREATE TRIGGER update_categories_timestamp
--     BEFORE UPDATE ON categories
--     FOR EACH ROW
--     EXECUTE FUNCTION update_updated_at_column();