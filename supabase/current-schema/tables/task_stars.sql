CREATE TABLE task_stars (
  id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  task_id BIGINT REFERENCES tasks(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  UNIQUE(user_id, task_id)
);

CREATE INDEX idx_task_stars_user_id ON task_stars(user_id);
CREATE INDEX idx_task_stars_task_id ON task_stars(task_id);

-- Enable RLS
ALTER TABLE task_stars ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can manage their own task stars"
ON task_stars
USING (user_id = auth.uid()); 